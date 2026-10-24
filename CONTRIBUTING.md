# Como contribuir com o KofTerm

Que bom que você chegou! O KofTerm existe para **ajudar quem está aprendendo Linux, redes e
cibersegurança**, e ele melhora com cada pessoa que contribui: uma receita nova, uma explicação
mais clara, um teste numa distribuição diferente ou um ajuste no código em KOF.

**Você não precisa saber KOF para ajudar.** Metade das contribuições mais valiosas é texto:
receitas do modo `?` e entradas do índice, escritas em português simples.

> **English:** KofTerm is a Linux terminal front-end written in KOF that helps people learn
> Bash, networking and security. Contributions in English are welcome (`kofterm lang en` already shows
> the index and the screens in English). Open an issue or a pull request in English or Portuguese; we will answer in the
> same language.

---

## Sumário

1. [Antes de começar](#1-antes-de-começar)
2. [Jeitos de contribuir (do mais fácil ao mais técnico)](#2-jeitos-de-contribuir)
3. [Rodar o projeto na sua máquina](#3-rodar-o-projeto-na-sua-máquina)
4. [Abrir uma issue](#4-abrir-uma-issue)
5. [Enviar um pull request](#5-enviar-um-pull-request)
6. [Regras do projeto](#6-regras-do-projeto)
7. [Versões](#7-versões)
8. [Reconhecimento](#8-reconhecimento)

---

## 1. Antes de começar

- Leia o [Código de Conduta](CODE_OF_CONDUCT.md). Aqui todo mundo é bem-vindo, do primeiro
  `ls` ao veterano de kernel.
- Procure as issues marcadas com
  [`good first issue`](https://github.com/DATAdotPDF/kofterm/labels/good%20first%20issue)
  (boas para começar) e
  [`help wanted`](https://github.com/DATAdotPDF/kofterm/labels/help%20wanted) (onde
  precisamos de ajuda). Comente "quero fazer" na issue para ninguém fazer o mesmo trabalho em
  dobro.
- Dúvida? Abra uma issue com a etiqueta `question`. Não existe pergunta boba.

## 2. Jeitos de contribuir

| Nível | O que fazer | Onde | Precisa saber |
|---|---|---|---|
| 🟢 Fácil | **Receita nova** para o modo `?` ("quero fazer X" → comando) | [`recipes/pt_BR.txt`](recipes/pt_BR.txt) | O comando e um português claro |
| 🟢 Fácil | **Entrada nova ou melhor** no índice (o que o comando faz, opções, exemplos) | [`index/pt_BR.txt`](index/pt_BR.txt) | O comando |
| 🟢 Fácil | **Testar** numa distribuição ou terminal diferente e contar o que aconteceu | Issue com o modelo "Bug" | Usar o terminal |
| 🟢 Fácil | **Seguir o roteiro** de teste humano e devolver as linhas ⚠️ e ❌ | [`docs/TESTE_HUMANO.md`](docs/TESTE_HUMANO.md) | Usar o terminal |
| 🟡 Médio | **Contribuir com o seu aprendizado** anonimizado (o modelo fica mais esperto) | `kofterm contribute` → `datasets/contrib/` | Nada; veja [datasets/contrib](datasets/contrib/README.md) |
| 🟡 Médio | **Melhorar o inglês** do índice e das receitas. Quem muda uma entrada em `index/pt_BR.txt` ou uma receita em `recipes/pt_BR.txt` muda a mesma em `index/en.txt` ou `recipes/en.txt` (mesmos nomes e comandos, na mesma ordem) | [`index/en.txt`](index/en.txt), [`recipes/en.txt`](recipes/en.txt) | Inglês |
| 🔴 Técnico | **Código em KOF**: editor, modelo, emulador de terminal, painel | [`src/`](src) | KOF (parecido com Kotlin/Java) |
| 🔴 Técnico | **Biblioteca KOF paralela** para algo que falta na linguagem | Repositório próprio | KOF |

### Receita nova (o caminho mais rápido para o seu primeiro PR)

Uma receita transforma um pedido em português num comando real. Formato:

```text
# nome da receita
? um jeito de pedir
? outro jeito de pedir, com {lacuna}
$ comando {lacuna}
% comando quando a pessoa já é root (opcional; "% -" esconde a receita para o root)
> Explicação curta, para quem está aprendendo.
```

Regras de ouro:

- Comandos que **funcionam no Debian, Ubuntu e Kali**.
- Comando que apaga algo **pergunta antes** (`rm -i`, `cp -i`).
- Ferramenta de varredura (`nmap`, `arp-scan`…) diz na explicação: **só na sua rede de
  laboratório ou com autorização**.
- Pelo menos **3 jeitos de pedir**, do jeito que uma pessoa falaria ("qual o gateway",
  "ver as rotas", "qual o roteador da rede").

### Entrada no índice

```text
# nome-do-comando
> O que ele faz, numa frase para quem está começando.
- -x | O que a opção -x faz.
$ comando -x arquivo | O que este exemplo faz.
@ https://manpages.debian.org/nome-do-comando
! pacote-apt (só se o pacote tiver outro nome; ex.: dig vem de bind9-dnsutils)
```

Escreva **com as suas palavras**: não copie texto de outros sites (direitos autorais). Links só
de fontes abertas, como manpages.debian.org, man7.org, ss64.com e a documentação oficial.

## 3. Rodar o projeto na sua máquina

Precisa de **Linux x86_64** (uma VM serve; o projeto é testado no Kali).

```bash
git clone https://github.com/<seu-usuario>/kofterm
cd kofterm
./install.sh            # baixa o KOF 0.6.6 se faltar (pergunta antes) e instala o KofTerm
```

Durante o desenvolvimento, compile e rode direto do repositório, sem instalar:

```bash
kof build src --target native --output build/kofterm && ./build/kofterm/Default/Main
```

Rode os testes unitários (um arquivo por vez; todos precisam passar):

```bash
for f in keys editor history prompt index model anon vt recipes; do kof test src/$f.kf --target native; done
```

Para testar sem mexer nos seus dados, use uma pasta pessoal temporária:

```bash
HOME=/tmp/kt-teste ./build/kofterm/Default/Main
```

Mudou receitas ou o índice? Não precisa recompilar: o KofTerm lê os arquivos de texto ao abrir.

## 4. Abrir uma issue

Use os modelos em **Issues → New issue**:

- **🐞 Bug**: o que você fez, o que esperava, o que aconteceu, a versão (`kofterm version`),
  a distribuição e o terminal. Print ajuda muito.
- **🧭 Receita** ou **📖 Entrada no índice**: o pedido ou o comando que faltou.
- **💡 Ideia**: o problema que ela resolve para quem está aprendendo.

**Achou uma falha de segurança?** Não abra issue pública: veja [SECURITY.md](SECURITY.md).

## 5. Enviar um pull request

1. Faça um **fork** e crie um branch: `git checkout -b receita/ver-gateway`.
2. Faça a mudança. Uma ideia por PR: PRs pequenos são revisados mais rápido.
3. Rode os testes (seção 3). Mudou receitas? Teste o pedido no KofTerm (`? seu pedido`).
4. Commit com mensagem clara, no estilo do projeto:
   `feat: ...`, `fix: ...`, `docs: ...`, `recipes: ...`, `index: ...`.
5. Abra o PR e preencha o modelo. Marque a issue que ele resolve (`Closes #12`).

**O que acontece depois:** a gente responde em **até 3 dias**, com paciência e sugestões
concretas. O CI roda sozinho (testes, build nativo, checagem de "sem código de rede"). Se
algo precisar mudar, explicamos o porquê. PR aprovado entra no próximo release, com o seu nome
no CHANGELOG.

Commits assinados são bem-vindos, mas **não são obrigatórios** para quem contribui.

## 6. Regras do projeto

Estas regras são o que torna o KofTerm confiável para quem está aprendendo. Um PR que quebre
alguma delas não entra, mas a gente ajuda você a encontrar outro caminho.

1. **KOF é o coração.** Todo o código do programa é KOF. O que faltar na linguagem vira uma
   **biblioteca KOF paralela** (repositório próprio), nunca Python, C ou outra linguagem. A
   única fronteira é a libc do sistema, via `extern`.
2. **100% offline.** O KofTerm não abre conexões de rede. O CI recusa código de rede em `src/`.
3. **Nada roda sozinho.** Sugestões só preenchem a linha; quem roda é a pessoa, com Enter.
4. **Comandos perigosos nunca são sugeridos** (`rm -rf /`, `mkfs`, `dd` em disco…).
5. **Funciona em qualquer terminal Linux com Bash.** Quando falta uma ferramenta do sistema, o
   KofTerm explica como instalar; ele não instala nada por conta própria.
6. **Privacidade.** Os dados ficam em `~/.local/share/kofterm` (pasta 0700). Contribuições de
   aprendizado são anonimizadas e revisadas pela própria pessoa antes de sair da máquina.
7. **Escrito para quem está aprendendo.** Frases curtas, sem jargão desnecessário.

## 7. Versões

O KofTerm usa números no formato **MAJOR.MINOR.PATCH** ([Versionamento Semântico](https://semver.org/lang/pt-BR/)).
Enquanto começar com **0.**, o projeto está em desenvolvimento e o comportamento ainda pode mudar
entre versões.

| Sobe o... | Quando | Exemplos |
| --- | --- | --- |
| **PATCH** (0.7.**1**) | Correção de bug, conteúdo novo (entradas no índice, receitas), texto, documentação, desempenho. Nenhuma tecla, subcomando ou formato de arquivo novo | Uma correção vinda de teste; mais receitas de redes |
| **MINOR** (0.**8**.0) | Algo novo que a pessoa usa ou percebe (tecla, subcomando, painel, idioma), ou mudança no formato dos arquivos (histórico, eventos, receitas, índice), sempre com migração automática | Ctrl+R, lista de candidatos, rodinha do mouse, inglês |
| **MAJOR** (**1**.0.0) | Promessa de estabilidade: a partir dela, quebrar compatibilidade só numa 2.0 | Veja os critérios abaixo |

**Caminho até a 1.0** (o mesmo de "Próximos passos" no README):

- **0.7.x:** correções do teste da 0.7.0 e receitas de redes.
- **0.8.0, achar coisas (feita):** busca no histórico com Ctrl+R, lista de candidatos ao completar arquivos e a rodinha do mouse rolando a saída antiga.
- **0.9.0, para todo mundo (inglês feito):** índice, telas e receitas em inglês (`kofterm lang en`). Na 0.9.x: emoji com a largura certa e aviso claro quando o terminal for estreito demais (feito). É a candidata à 1.0.
- **1.0.0**, quando tudo isto for verdade:
  1. o [roteiro de teste](docs/TESTE_HUMANO.md) rodado por pelo menos 2 ou 3 pessoas além do autor, em mais de uma distribuição (Kali, Ubuntu, Debian) e de um terminal (QTerminal, GNOME Terminal, xterm, tmux);
  2. nenhuma limitação conhecida que atrapalhe o uso no dia a dia;
  3. formatos de histórico, eventos, receitas e índice documentados e estáveis;
  4. atualizar de uma versão para outra sem perder nada, testado;
  5. os bugs do KOF que o projeto contorna ([#931](https://github.com/KofLang/Kof4j/issues/931) a [#934](https://github.com/KofLang/Kof4j/issues/934)) corrigidos no compilador, ou os contornos testados e documentados como definitivos.
- **Depois da 1.0:** o modelo neural em KOF puro (`kof-nn`), numa 1.x. Se mudar muito a experiência, vira a 2.0.

Toda versão sai com tag assinada, entrada no [CHANGELOG](CHANGELOG.md), CI verde (testes
unitários e `kofterm selftest`) e o pacote `kofterm-X.Y.Z-linux-x86_64.tar.gz` com `SHA256SUMS`.

## 8. Reconhecimento

Toda contribuição aceita aparece:

- na seção **Contribuidores** do [README](README.pt_BR.md#contribuidores);
- nas notas do [CHANGELOG](CHANGELOG.md) e da release em que entrou.

Obrigado por somar. Cada receita sua ajuda alguém a dar o próximo passo no terminal. 💙
