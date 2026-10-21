# KofTerm — terminal com autocomplete inteligente, 100% offline, em KOF

## Contexto
Primeiro projeto em KOF (https://koflang.github.io, v0.6.6). Objetivo: um comando `kofterm`, instalável a partir do GitHub, que roda dentro de qualquer terminal Linux e oferece:
- sugestão em *ghost text* estilo VS Code/Gemini: aceita com **TAB**, considerando o contexto das linhas anteriores (ex.: `apt update` → sugere `sudo apt upgrade`);
- um "cérebro" local treinado só com comandos Linux, sem rede;
- painel lateral / aba dividida com um índice offline dos comandos e o que cada um faz.

**Princípio central: KOF é o coração do projeto.** Todo código do produto (terminal, IA, treino, instalador, testes) é escrito em KOF. Quando faltar algo na linguagem ou na stdlib, a solução é criar uma **biblioteca KOF paralela** (repo próprio, reutilizável pela comunidade) e consumi-la via `kof deps`. Nada de Python, C ou llama.cpp no caminho. A única fronteira externa é o próprio sistema operacional (chamadas da libc/kernel via `extern`), que qualquer terminal precisa usar.

Decisões já tomadas: **front-end TUI de shell** (não um emulador gráfico), **target Native x86_64**, **IA faseada** (n-gram em KOF puro primeiro, LLM pequena opcional depois), índice com **tldr + man local + material ss64 tratado legalmente** (veja §5).

## O que o KOF oferece e o que falta (pesquisa)
- Native gera ELF direto. `extern` FFI liga a libc sob demanda, passa String↔char*, String[]→char**, `Buffer(U8)` in-out e records por valor. **É assim que obtemos PTY e termios.**
- A stdlib **não** tem modo raw, termios, leitura de stdin byte a byte nem stdin em `process.spawn` (o `write` não faz nada). Então o bash **não** pode ser controlado por `kof.process`: tudo de terminal vai por FFI.
- Tem `spawn/await` (pthread no native), `List/Map/Set`, `kof.io`, `kof.json`, `kof test`, `kof fmt`, `kof.db` (SQLite em todos os targets).
- Repo de referência `lunalully/koffuster`: layout `bin/<launcher bash>` + `src/*.kf` modular (`main.kf`, `cli.kf`, …) + `docs/` + `labs/`. Vamos copiar esse layout.
- Risco nº 1: a sintaxe exata do `extern` não está documentada no site. Ela fica no corpus `KofLang/Kof4j/training`, e a Fase 0 valida isso antes de qualquer outra coisa.

## Arquitetura
```
 terminal do usuário (qualquer: gnome-terminal, xterm, tty…)
        │ stdin raw / stdout ANSI
 ┌──────▼─────────────────────────────────────────────┐
 │ kofterm (ELF nativo)                                │
 │  input loop ─► LineEditor ─► Suggest Engine ─► ghost│
 │      │              │ Enter        ▲   ▲            │
 │      │              ▼              │   │            │
 │      │        PTY master ◄──► bash │ ContextTracker │
 │      │        (forkpty)  saída ────┘  (cwd, últimos │
 │      ▼                                  N comandos) │
 │  Layout/Render (ANSI): [área do shell | painel docs]│
 └─────────────────────────────────────────────────────┘
   dados locais: ~/.local/share/kofterm/{model.bin, index.db}
```
Modelo de interação: o kofterm é dono da linha que está sendo editada (como o fish). Ao apertar Enter, envia a linha ao bash pelo PTY e repassa a saída do bash (com cores e programas full-screen como `vim`/`htop`, em modo passthrough) para a região do shell. O prompt é detectado com um marcador OSC injetado em `PROMPT_COMMAND`, que também informa `cwd` e o exit code.

### Módulos (`src/`)
| Arquivo | Responsabilidade |
|---|---|
| `main.kf` | entrada, subcomandos (`kofterm`, `kofterm train`, `kofterm docs <cmd>`, `kofterm doctor`) |
| `cli.kf` | parsing de argumentos (mesmo padrão do koffuster) |
| `sys/ffi.kf` | todos os `extern` da libc: `forkpty`, `execvp`, `tcgetattr/tcsetattr`, `cfmakeraw`, `read`, `write`, `poll`, `ioctl(TIOCGWINSZ/TIOCSWINSZ)`, `waitpid`, `signal(SIGWINCH)` |
| `sys/tty.kf` | entrar/sair do modo raw com restauração garantida (try/finally + handler de saída) |
| `sys/pty.kf` | abre o bash em um PTY, repassa I/O, sincroniza o tamanho da janela |
| `term/keys.kf` | decodifica bytes → teclas (setas, TAB, Ctrl-*, Alt-*, sequências CSI) |
| `term/screen.kf` | escrita ANSI, regiões de rolagem (DECSTBM) para dividir a tela, ghost text em cinza (`\e[90m`) |
| `term/layout.kf` | split horizontal/vertical, painel de docs, alternância (F1 / Ctrl+K), modo "aba" (tela alternativa) |
| `edit/line.kf` | editor de linha: cursor, histórico ↑/↓, Ctrl-R, aceitar sugestão inteira (TAB) ou palavra a palavra (Ctrl+→) |
| `ctx/tracker.kf` | contexto: últimos N comandos, exit codes, cwd, se o último falhou por permissão ("Permission denied" → sugere `sudo !!`) |
| `ai/tokenize.kf` | tokenização de shell (comando, subcomando, flags, args, pipes, `sudo` como prefixo) |
| `ai/ngram.kf` | modelo n-gram com back-off (Kneser-Ney simplificado) sobre tokens + bigrama entre comandos ("cmd anterior → próximo cmd") |
| `ai/grammar.kf` | conhecimento estrutural: subcomandos e flags válidos por comando (do índice) e completion de caminhos do FS |
| `ai/rank.kf` | combina as fontes (histórico do usuário > n-gram > gramática > caminhos) em um ranking e escolhe 1 ghost + lista alternativa |
| `ai/safety.kf` | marca comandos perigosos (`rm -rf /`, `dd of=/dev/sd*`, `mkfs`, fork bomb, `chmod -R 777 /`) em vermelho e **nunca** os sugere |
| `docs/index.kf` | consulta o `index.db` (SQLite): nome, resumo, sintaxe, flags, exemplos, fonte/licença |
| `train/build.kf` | `kofterm train`: compila o corpus em `model.bin` |

### Garantia de "100% seguro e offline"
- O código não importa `kof.web`, `kof.net`, `http` nem `fetch`. Um teste de CI faz grep no `src/` e falha se algum aparecer.
- `kofterm doctor` roda `strace -f -e trace=network` em uma sessão de teste e confirma zero sockets.
- Nada é executado sem Enter explícito. TAB só preenche texto.
- O histórico/modelo do usuário fica só em `~/.local/share/kofterm`, com permissão 0600.

## IA de autocomplete (faseada)
**v1: n-gram em KOF puro (alvo <5 ms por tecla)**
- Corpus: exemplos do tldr-pages (CC-BY 4.0), sinopses de `man` da própria máquina, um conjunto de sequências de comandos escrito pelo projeto (`corpus/sessions/*.txt`, ex.: `git add .` → `git commit -m` → `git push`) e o `~/.bash_history` do usuário (opt-in, treinado localmente).
- Contexto entre linhas: o modelo pontua P(próximo comando | comando anterior, exit code anterior, cwd tem `.git`/`package.json`/etc.).
- "Refatoração" (como no VS Code): regras de reescrita sugeridas como ghost alternativo, ex.: `cat f | grep x` → `grep x f`, comando que falhou por permissão → `sudo …`, typo `gti` → `git` (distância de Levenshtein contra o índice).

**v2: modelo neural local, 100% KOF (fase posterior, só depois da v1 estável)**
- Projeto paralelo **`kof-nn`**: tensores em `double[]`/`float[]`, matmul, softmax, LayerNorm, atenção causal, AdamW, backprop. Começa com um transformer minúsculo (~1–5M params, vocabulário de tokens de shell), que dá para treinar em CPU em horas só com o corpus de comandos.
- `kofterm train --neural` treina na própria máquina, e o arquivo de pesos usa um formato próprio e simples (`.kofw`), lido e escrito por `kof.io`.
- Inferência em uma thread `spawn`. O n-gram continua como fallback instantâneo e o modelo neural só refina quando o usuário pausa a digitação por mais de 300 ms.
- Se o desempenho do KOF native não alcançar a meta, otimizar dentro de `kof-nn` (quantização int8, cache de KV), sem trocar de linguagem.

## Índice de comandos (painel lateral) e a questão do ss64
Atribuir crédito **não** dá direito de redistribuir: o ss64 é protegido por copyright e o projeto ser sem fins lucrativos não muda isso. Para ter o índice offline e completo sem risco para o repositório:
1. **Embutido no repo (pode ser distribuído):**
   - tldr-pages (CC-BY 4.0), com atribuição em `NOTICE`;
   - **a lista de nomes de comandos** do ss64 (fatos, não texto) como checklist de cobertura, mais o **link** para a página ss64 de cada comando (`ss64.com/bash/<cmd>.html`), aberto só se o usuário quiser;
   - resumos em PT-BR/EN **escritos pelo projeto** para os comandos da lista que o tldr não cobrir.
2. **Gerado na máquina do usuário na instalação (nada sai dela):** extração de `man -P cat`, `help <builtin>` e `<cmd> --help` dos comandos instalados → `index.db`.
3. **Conteúdo do ss64 em si:** abrir um issue/e-mail para o mantenedor do ss64 pedindo permissão para embutir. Se ele permitir, entra como pacote opcional `kofterm docs --with-ss64` com a licença dele. Até lá, só links.
4. Outras fontes abertas para avaliar: GNU Bash Reference Manual (GFDL), páginas da man-pages project (licenças permissivas por página; checar uma a uma), Arch Wiki (GFDL).

UI: `F1` ou `Ctrl+K` abre o painel à direita (ou embaixo se a largura for <100 colunas) mostrando a doc do comando sob o cursor. Dentro do painel, `/` faz busca fuzzy, Enter insere um exemplo na linha (sem executar) e `Esc` fecha. `Ctrl+T` abre a "aba" em tela cheia (tela alternativa).

## Ecossistema KOF (projetos paralelos que fecham o ciclo)
Cada lacuna vira uma biblioteca KOF própria, com testes e repositório separados. O `kofterm` só as consome.
| Biblioteca | Preenche | Quando nasce |
|---|---|---|
| `kof-tty` | termios, modo raw, PTY (`forkpty`), `poll`, `SIGWINCH`, tamanho da janela, encapsulando os `extern` da libc em uma API segura | Fase 0–1 (extraída do `src/sys/`) |
| `kof-ansi` | decodificação de teclas, escrita ANSI, regiões, cores, *diff* de tela | Fase 1–2 (extraída do `src/term/`) |
| `kof-nn` | tensores, transformer pequeno, treino e inferência | Fase 6 |
| `kof-index` (opcional) | parser de man/tldr → SQLite, busca fuzzy | Fase 3 se ficar grande |

Regra de segurança: dependências só destas bibliotecas próprias e da stdlib KOF, todas com versão fixa no lock de `kof deps`. Nenhuma dependência do Maven Central.

## Estrutura do repositório
```
kofterm/
  bin/kofterm            # symlink para o ELF nativo
  src/…                  # módulos acima, todos .kf
  corpus/{tldr/, sessions/, commands.txt}
  tests/*.kf             # kof test
  labs/*.ks              # roteiros de teste na VM, em KofScript
  install.ks             # instalador em KofScript: kof build --target native, instala em ~/.local/bin, roda kofterm train
  install.sh             # 5 linhas de bootstrap: confere se `kof` existe e chama `kof run install.ks`
  LICENSE (GPLv3) NOTICE README.md docs/
```
Instalação pelo usuário final:
```bash
git clone https://github.com/DATAdotPDF/kofterm && cd kofterm && ./install.sh
```

## Fases de entrega
0. ✅ **Spike de FFI (concluído 21/10/2026; achados em `spikes/README.md`):** na VM Linux, instalar o KOF 0.6.6, ler `Kof4j/training` para pegar a sintaxe do `extern` e provar 3 coisas em arquivos de ~50 linhas: (a) `tcsetattr` em modo raw lendo teclas byte a byte, (b) `forkpty`+`execvp("bash")` repassando I/O com `poll`, (c) `ioctl TIOCGWINSZ`. Se o FFI não conseguir lidar com a struct `termios`, o plano B é usar `Buffer(U8)` de 60 bytes com offsets fixos. Se ainda faltar algo, o plano C é implementar a peça na própria linguagem ou no compilador: abrir um issue/PR no `KofLang/Kof4j` e, enquanto isso, usar o que der em KOF.
1. **Passthrough:** `kofterm` abre o bash no PTY, tudo funciona como um terminal normal (incluindo `vim`, `htop`, Ctrl-C, redimensionamento).
2. **Editor de linha + ghost text:** sugestões só do histórico, TAB aceita.
3. **Índice + painel lateral:** importação de tldr/man → SQLite, split screen.
4. **n-gram + contexto + gramática + safety:** a "IA" v1, mais as regras de refatoração.
5. **Empacotamento:** `install.sh`, README, CI (GitHub Actions: `kof test` + build native + checagem de "sem rede"), primeira release.
6. **(Opcional) modelo neural v2**: criar `kof-nn` e integrar.

## Verificação
- `kof test` em cada módulo puro: tokenizer, n-gram (dado o corpus X, `apt update` → top-1 contém `upgrade`), keys decoder (sequências CSI conhecidas), safety (lista de comandos perigosos nunca sugerida), rank.
- Na VM Linux: executar `kofterm`, rodar `ls`, `vim`, `htop`, `sudo -k; sudo ls` (prompt de senha passa pelo PTY), redimensionar a janela, Ctrl-C, `exit`, e confirmar que o terminal volta ao estado normal (`stty -a` igual ao de antes).
- Cenário de contexto: `cat /etc/shadow` (falha) → ghost sugere `sudo cat /etc/shadow`; `git add .` → ghost `git commit -m ""`.
- `strace -f -e trace=network kofterm` sem nenhuma chamada de socket.
- Latência: medir o tempo da sugestão por tecla (meta <5 ms no n-gram).
