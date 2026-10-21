<p align="center">
  <img src="docs/images/banner.svg" alt="Banner do KofTerm: terminal Linux com autocomplete por IA offline, escrito em KOF">
</p>

---

<h1 align="center">KOFTERM · TERMINAL COM IA OFFLINE PARA LINUX</h1>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/Licen%C3%A7a-GPLv3-blue?style=flat-square" alt="Licença GPLv3"></a>
  <a href="https://github.com/KofLang/Kof4j"><img src="https://img.shields.io/badge/Feito_com-KOF_0.6.6-f59e0b?style=flat-square" alt="Feito com KOF 0.6.6"></a>
  <img src="https://img.shields.io/badge/Plataforma-Linux_x86__64-FCC624?style=flat-square&logo=linux&logoColor=black" alt="Linux x86_64">
  <img src="https://img.shields.io/badge/Rede-nenhuma-22c55e?style=flat-square" alt="Sem rede">
  <img src="https://img.shields.io/badge/Status-Fase_1_conclu%C3%ADda-8b5cf6?style=flat-square" alt="Fase 1 concluída">
</p>

<p align="center">
  <a href="README.md">English</a> ·
  <a href="docs/PLAN.md">Plano</a> ·
  <a href="docs/JOURNAL.md">Diário de desenvolvimento</a> ·
  <a href="spikes/README.md">Resultados da Fase 0</a>
</p>

###

<h3 align="left">SOBRE:</h3>

###

<p align="left">
  O KofTerm é um terminal para Linux <b>feito para quem está estudando Bash</b>. Ele traz para o shell o autocomplete no estilo VS Code / Gemini: enquanto você digita, o resto da linha aparece em cinza, e o <b>TAB</b> aceita.<br><br>
  A sugestão não é só uma busca no histórico. Ela lê o contexto da sessão: o que você já escreveu, o comando anterior, se ele falhou, as pastas que você visitou. Quanto mais você digita, mais ele aprende com você. Digite <code>sudo apt update</code> e a próxima linha sugere <code>sudo apt upgrade</code>. Um comando que falha com <i>Permission denied</i> é oferecido de novo com <code>sudo</code>. Um erro de digitação como <code>gti</code> vira <code>git</code>.<br><br>
  Tudo roda <b>localmente e offline</b>. O modelo é treinado só com comandos Linux, na sua própria máquina, e o binário nunca abre um socket de rede. Se você quiser ajudar, pode devolver ao projeto, pelo Git, o que o seu modelo aprendeu, anonimizado e revisado por você antes, para que cada versão nova traga um modelo mais inteligente. Nada pessoal sai da sua máquina.<br><br>
  Um painel lateral (<code>F1</code> / <code>Ctrl+K</code>) abre um índice offline das formas mais conhecidas de usar o terminal. Esqueceu o que <code>ls -ld</code> faz? Cada opção é explicada separadamente, com exemplo e indicações de leitura online, sem precisar garimpar o <code>--help</code>.<br><br>
  É também o meu primeiro projeto em <a href="https://koflang.github.io">KOF</a>, uma linguagem de programação brasileira. KOF é o coração do projeto: o terminal, a IA, o treino, o instalador e os testes são todos em KOF. Quando faltar algo na linguagem, a resposta é uma nova biblioteca KOF, não outra linguagem.
</p>

###

<h3 align="left">STATUS ATUAL:</h3>

###

- **Fase 0 (spikes de FFI): concluída.** Modo raw do teclado, tamanho da janela e Bash rodando dentro de um pseudo-terminal estão provados em KOF native no Kali Linux. Veja [spikes/README.md](spikes/README.md).
- **Fase 1 (terminal passthrough): concluída.** O `kofterm` roda o Bash num pseudo-terminal, repassa o código de saída do Bash, acompanha o redimensionamento da janela e restaura o seu terminal mesmo quando é morto por `SIGTERM` ou `SIGHUP`.
- **Fase 2 (editor de linha e ghost text): próxima.**
- Hoje funciona como um terminal comum; as sugestões chegam na Fase 2.

###

<h3 align="left">LINGUAGENS E FERRAMENTAS:</h3>

###

<div align="left">
  <img src="https://raw.githubusercontent.com/KofLang/Kof4j/main/kof.png" height="40" alt="Logo do KOF" />
  <img width="12" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/linux/linux-original.svg" height="40" alt="Logo do Linux" />
  <img width="12" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/bash/bash-original.svg" height="40" alt="Logo do Bash" />
  <img width="12" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/sqlite/sqlite-original.svg" height="40" alt="Logo do SQLite" />
  <img width="12" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/git/git-original.svg" height="40" alt="Logo do Git" />
  <img width="12" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/github/github-original.svg" height="40" alt="Logo do GitHub" />
</div>

###

- **KOF 0.6.6**, target native x86_64: binários ELF pequenos (~60 KB), sem JVM em tempo de execução
- **libc via `extern` do KOF**: `forkpty`, `termios`, `ioctl`, `ppoll`, a única fronteira fora do KOF
- **SQLite** (`kof.db` do KOF) para o índice offline de comandos
- **tldr-pages** (CC BY 4.0) e páginas `man` locais como corpus de documentação e de treino
- **Kali Linux** no VirtualBox como máquina de testes
- **Claude Code** como ferramenta de pair programming na pesquisa, no planejamento e nos spikes da Fase 0 (declarado em cada commit)

###

<h3 align="left">FUNCIONALIDADES:</h3>

| Funcionalidade | Status |
| --- | --- |
| Bash dentro de um pseudo-terminal (cores, Ctrl-C, redimensionar, código de saída) | ✅ Fase 1 |
| Terminal restaurado mesmo se o KofTerm for morto (`SIGTERM`, `SIGHUP`) | ✅ Fase 1 |
| Sugestão em ghost text, **TAB** aceita a linha, **Ctrl+→** aceita uma palavra | Fase 2 |
| Sugestões com contexto (o que você digitou, comando anterior, código de saída, pastas) | Fase 4 |
| Aprende com você enquanto você digita, localmente | Fase 4 |
| Sugestões de "refatoração": repetir com `sudo`, corrigir typo, `cat f \| grep x` → `grep x f` | Fase 4 |
| Comandos perigosos (`rm -rf /`, `mkfs`, fork bomb) marcados em vermelho e nunca sugeridos | Fase 4 |
| Painel lateral / tela dividida com índice offline de comandos | Fase 3 |
| Cada opção explicada separadamente (`-ld` → `-l` + `-d`), com links de leitura | Fase 3 |
| Contribuição opcional e anonimizada do aprendizado de volta ao projeto via Git | Fase 5 |
| Modelo neural pequeno opcional, treinado e executado em KOF puro (`kof-nn`) | Fase 6 |
| Instalação com um comando a partir do GitHub | Fase 5 |

###

<h3 align="left">COMO FUNCIONA:</h3>

```mermaid
flowchart LR
    K[Teclado] -->|bytes raw| E[Editor de linha]
    E -->|linha atual + contexto| S[Motor de sugestão]
    S -->|ghost text| R[Renderizador ANSI]
    E -->|Enter| P[PTY master]
    P <--> B[bash]
    P -->|saída| R
    B -.->|marcador de prompt: cwd, código de saída| C[Rastreador de contexto]
    C --> S
    S --- M[(model.bin)]
    R --- D[(index.db)]
```

O KofTerm controla a linha que você está editando, como o fish shell. Quando você aperta Enter, a linha vai para um Bash de verdade rodando num pseudo-terminal, e a saída do Bash volta para o seu terminal. Sugestões são só texto: nada roda antes do Enter.

###

<h3 align="left">MAPA DO REPOSITÓRIO:</h3>

```text
kofterm/
├── docs/
│   ├── PLAN.md              Plano completo: arquitetura, módulos, IA, índice, fases
│   ├── JOURNAL.md           Diário de desenvolvimento datado (registro de autoria)
│   └── images/              Banner e capturas de tela
├── spikes/                  Fase 0: uma pasta por prova, cada uma com main.kf
│   ├── 01_raw_keys/         Modo raw, leitura do teclado byte a byte
│   ├── 02_winsize/          Tamanho da janela via ioctl(TIOCGWINSZ)
│   └── 03_pty_bash/         Bash dentro de um PTY com forkpty + ppoll
├── src/                     O terminal em si, todo em .kf
│   ├── main.kf              Laço de eventos: teclado, saída do Bash e sinais
│   ├── libc.kf              Todos os extern da libc e constantes do Linux, num lugar só
│   ├── tty.kf               Modo raw, restauração, tamanho da janela (futura kof-tty)
│   ├── pty.kf               Bash num pseudo-terminal, código de saída (futura kof-tty)
│   └── sig.kf               Sinais lidos como dados via signalfd (futura kof-tty)
├── AUTHORS.md               Autor e créditos
├── CHANGELOG.md             Mudanças por versão
├── CITATION.cff             Como citar o projeto
├── LICENSE                  GNU GPL v3
└── NOTICE                   Créditos e licenças de terceiros
```

###

<h3 align="left">COMO COMEÇAR:</h3>

**Requisitos:** Linux x86_64 com glibc 2.34 ou mais nova (por causa do `forkpty` na `libc.so.6`) e KOF 0.6.6.

**1. Instale o KOF.** Baixe `kof-0.6.6-linux-x86_64.tar.gz` e `SHA256SUMS` das [releases do KOF](https://github.com/KofLang/Kof4j/releases), confira o hash e extraia:

```bash
sha256sum -c SHA256SUMS --ignore-missing
```
```bash
mkdir -p ~/.local/share ~/.local/bin && tar -xzf kof-0.6.6-linux-x86_64.tar.gz -C ~/.local/share && mv ~/.local/share/kof-0.6.6-linux-x86_64 ~/.local/share/kof && ln -sf ~/.local/share/kof/bin/kof ~/.local/bin/kof
```

**2. Clone este repositório.**

```bash
git clone https://github.com/DATAdotPDF/kofterm.git && cd kofterm
```

**3. Compile e rode o KofTerm** (Fase 1, passthrough):

```bash
kof build src --target native --output build/kofterm
```
```bash
./build/kofterm/Default/Main
```

Você cai no seu Bash dentro do KofTerm (`echo $KOFTERM` mostra `1`). Digite `exit` para voltar; o KofTerm sai com o mesmo código do Bash.

**4. Opcional: rode os spikes da Fase 0** (numa janela de terminal de verdade, não por pipe):

```bash
cd spikes/02_winsize && kof run main.kf --target=native
```
```bash
cd ../01_raw_keys && kof run main.kf --target=native
```
```bash
cd ../03_pty_bash && kof run main.kf --target=native
```

O spike 01 mostra cada tecla que você aperta (`q` sai). O spike 03 abre um Bash dentro do pseudo-terminal do KofTerm; digite `exit` para voltar. Se o terminal ficar estranho, `reset` resolve.

###

<h3 align="left">ROADMAP:</h3>

| Fase | Objetivo | Status |
| --- | --- | --- |
| 0 | Spikes de FFI: modo raw, tamanho da janela, PTY | ✅ concluída (21/10/2026) |
| 1 | Terminal passthrough, restauração segura em sinais (`signalfd`) | ✅ concluída (21/10/2026) |
| 2 | Editor de linha e ghost text a partir do histórico | próxima |
| 3 | Índice offline, painel lateral, explicação por opção, links de leitura | planejada |
| 4 | Modelo n-gram com aprendizado contínuo local, contexto, gramática, regras de segurança | planejada |
| 5 | `kofterm contribute` (anonimizado, opcional), instalador, CI com checagem de "sem rede", primeira release | planejada |
| 6 | Modelo neural opcional em KOF puro (`kof-nn`) | planejada |

Bibliotecas KOF paralelas que serão extraídas no caminho: `kof-tty` (terminal e PTY), `kof-ansi` (teclas e tela), `kof-nn` (tensores e um transformer pequeno).

###

<h3 align="left">PROCESSO DE PONTA A PONTA:</h3>

###

**1. Ideia.** O VS Code com o Gemini sugere o resto da linha e o TAB aceita. Eu queria o mesmo no terminal Linux, mas local, privado e restrito a comandos Linux, com uma cola sempre a uma tecla de distância.

**2. Pesquisa.** Estudei o site da linguagem KOF, a biblioteca padrão e os targets, o corpus `training/` do [repositório central do KOF](https://github.com/KofLang/Kof4j) e o [koffuster](https://github.com/lunalully/koffuster), uma ferramenta de terminal escrita em KOF, como referência de estrutura.

**3. Decisões de escopo.** Um emulador de terminal gráfico completo estava fora do escopo de um primeiro projeto, então o KofTerm é um front-end que roda dentro de qualquer terminal existente. Target: KOF native, o mais próximo de um binário Linux comum. IA: primeiro um modelo n-gram, depois um modelo neural opcional. Documentação: tldr-pages e `man` local, com o SS64 apenas como links, porque o conteúdo dele tem copyright.

**4. A regra "só KOF".** O primeiro plano usava Python no treino e um helper em C como alternativa. Eu recusei: KOF é o coração do projeto, e o que faltar vira uma biblioteca KOF paralela. Assim o ciclo inteiro fica auditável e dentro de uma só linguagem.

**5. Máquina de testes.** O KOF 0.6.6 foi instalado numa VM Kali Linux a partir da release oficial, com o SHA-256 conferido. A VM é acessada por SSH com uma chave dedicada.

**6. Achados da Fase 0.** Os três spikes passaram depois de corrigir o que a documentação não dizia. O KOF não tem constantes no nível do arquivo (elas ficam como campos `static` numa classe). `Buffer(U8)` não pode ser parâmetro de função, então a memória é tratada como ponteiros `Long` crus vindos de `malloc`. Um `extern` chamado `poll` é desviado em silêncio para o `poll` de concorrência do próprio KOF, então o terminal usa `ppoll`. Detalhes em [spikes/README.md](spikes/README.md).

**7. Fase 1: um terminal de verdade.** O spike virou o `src/`, dividido em módulos que depois formarão a biblioteca `kof-tty`. Os sinais são bloqueados e lidos como dados por um `signalfd` no mesmo laço do `ppoll`, porque o KOF não consegue guardar um callback de sinal. Isso dá redimensionamento no `SIGWINCH` e terminal restaurado no `SIGTERM` e no `SIGHUP`. Verificado no Kali: o código de saída do Bash é repassado (`exit 7` → 7) e nenhum Bash órfão fica para trás.

**8. Aprendizado que volta.** O modelo aprende com cada usuário localmente. Quem quiser ajudar exporta um arquivo anonimizado (caminhos, hosts, usuários e números viram marcadores, e tudo que parece segredo é descartado), revisa e envia como pull request. O CI confere de novo e retreina o modelo base, então cada versão sai com um modelo mais inteligente. O KofTerm nunca toca a rede: quem envia é o Git do próprio usuário.

O registro completo e datado está em [docs/JOURNAL.md](docs/JOURNAL.md).

###

<h3 align="left">SEGURANÇA E PRIVACIDADE:</h3>

- Sem código de rede: o código-fonte nunca importa `kof.web`, `kof.net` ou `http`, e o CI vai falhar se importar
- Um `kofterm doctor` vai confirmar zero chamadas de rede com `strace`
- Sugestões nunca executam nada: só o Enter roda um comando
- Histórico e modelo treinado ficam em `~/.local/share/kofterm`, legíveis só por você
- A contribuição é opcional, mostrada inteira antes do envio, anonimizada duas vezes (na sua máquina e de novo no CI) e enviada pelo seu Git, nunca pelo KofTerm
- Os links de leitura do painel lateral são só exibidos; o KofTerm nunca os abre
- Dependências limitadas à biblioteca padrão do KOF e às bibliotecas KOF do próprio projeto, com versões fixas

###

<h3 align="left">CRÉDITOS:</h3>

- **Linguagem KOF:** criada por **Mel Santos** ([@melmonfre](https://github.com/melmonfre) · [LinkedIn](https://www.linkedin.com/in/aminadojava/)) e mantida com os contribuidores do KOF no repositório central **[KofLang/Kof4j](https://github.com/KofLang/Kof4j)**, sob GPL-3.0. Site: [koflang.github.io](https://koflang.github.io). O logo do KOF mostrado acima pertence ao projeto KOF.
- **koffuster**, de [Luna (@lunalully)](https://github.com/lunalully/koffuster): referência de estrutura de uma ferramenta de terminal em KOF.
- **tldr-pages** ([tldr-pages/tldr](https://github.com/tldr-pages/tldr)), CC BY 4.0: exemplos de comandos para o índice e o corpus de treino.
- **SS64** ([ss64.com/bash](https://ss64.com/bash/)): referência de comandos. O conteúdo não é copiado para este repositório; o KofTerm usa links.

Avisos completos de terceiros em [NOTICE](NOTICE).

###

<h3 align="left">AUTORIA:</h3>

O KofTerm foi concebido e é desenvolvido por **Pedro D. Ferreira** ([@DATAdotPDF](https://github.com/DATAdotPDF)). A autoria está registrada no histórico do Git, no [diário de desenvolvimento](docs/JOURNAL.md) datado e em [AUTHORS.md](AUTHORS.md). A assistência de IA (Claude Code) é declarada com uma linha `Co-Authored-By` em cada commit em que ela ajudou.

Para citar o KofTerm, use o [CITATION.cff](CITATION.cff).

###

<h3 align="left">LICENÇA:</h3>

GNU General Public License v3.0, a mesma licença do KOF. Veja [LICENSE](LICENSE).

## Contato

[![Portfolio](https://img.shields.io/badge/Portfolio-111827?style=for-the-badge&logo=cloudflare&logoColor=white)](https://portfolio-data-cybersecurity.data-pedutraferreira.workers.dev)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/data-pdf/)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/DATAdotPDF)
[![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:data.pedutraferreira@gmail.com)

<p align="center">
  Do storytelling audiovisual a sistemas confiáveis de dados e segurança.
</p>
