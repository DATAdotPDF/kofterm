# Rascunho: etiquetas e primeiras issues do KofTerm

Rascunho para revisão antes de publicar em github.com/DATAdotPDF/kofterm. Cada issue diz o
problema, o resultado esperado e onde mexer, para quem chega pela primeira vez.

## Etiquetas

| Etiqueta | Cor | Para quê |
|---|---|---|
| `good first issue` | `7057ff` | Boa para a primeira contribuição |
| `help wanted` | `008672` | Precisamos de ajuda (qualquer nível) |
| `recipes` | `e7a44a` | Receitas do modo `?` (`recipes/`) |
| `index` | `efe4cc` | Índice de comandos (`index/`) |
| `kof` | `9e1b2b` | Código em KOF (`src/`) |
| `docs` | `a9b3c7` | Documentação |
| `testing` | `2f6f47` | Testes em distribuições e terminais |
| `bug`, `enhancement`, `question` | padrão do GitHub | |

---

## 1. Receitas de roteamento e DHCP para estudantes de redes
**Etiquetas:** `good first issue`, `recipes`

Quem estuda redes (Cisco, CompTIA) pede coisas como "renovar o IP", "ver o servidor DHCP" ou
"adicionar uma rota". O modo `?` ainda não sabe.

**Resultado esperado:** 3 receitas novas em `recipes/pt_BR.txt`, cada uma com pelo menos 3
jeitos de pedir:
- renovar o IP pelo DHCP → `sudo dhclient -r && sudo dhclient` (ou o equivalente com `nmcli`);
- adicionar uma rota → `sudo ip route add {rede} via {gateway}`;
- remover uma rota → `sudo ip route del {rede}`.

**Onde mexer:** só `recipes/pt_BR.txt` (formato no CONTRIBUTING.md). Teste com
`? renovar o ip` no KofTerm. Não precisa recompilar.

## 2. Entradas no índice: `tree`, `zip`, `unzip`, `vim`, `tmux`
**Etiquetas:** `good first issue`, `index`

Comandos que todo estudante encontra e que o índice ainda não explica.

**Resultado esperado:** uma entrada por comando em `index/pt_BR.txt`, com resumo, 2–4 opções
comuns, 1–2 exemplos e um link de manpages.debian.org. Linha `!` se o pacote tiver outro nome
(`vim` → `vim`, `unzip` → `unzip`).

**Onde mexer:** só `index/pt_BR.txt`. Escreva com as suas palavras.

## 3. Busca no histórico com Ctrl+R
**Etiquetas:** `help wanted`, `kof`

No Bash comum, Ctrl+R procura um comando antigo enquanto você digita. Dentro do KofTerm,
o editor de linha é dele, e o Ctrl+R ainda não faz nada.

**Resultado esperado:** Ctrl+R abre a busca reversa no histórico (`(busca) texto: comando`),
Ctrl+R de novo vai para o resultado anterior, Enter ou → coloca o comando na linha e Esc
cancela. Testes para a busca em `src/history.kf`.

**Onde mexer:** decodificar a tecla em `src/keys.kf` (Ctrl+R é o byte 18), a busca em
`src/history.kf` e o modo de busca em `onKey`, em `src/session.kf`.

## 4. `kofterm doctor` mostra a versão do Bash e o terminal
**Etiquetas:** `good first issue`, `kof`

Quem relata um bug precisa dizer a versão do Bash e o terminal. O `doctor` poderia mostrar.

**Resultado esperado:** duas linhas novas no `kofterm doctor`: `bash: 5.2.37` (de
`BASH_VERSION` ou `bash --version`) e `terminal: xterm-256color` (variável `TERM`).

**Onde mexer:** função `runDoctor` em `src/cli.kf`. Use `secure_getenv` (em `src/00_libc.kf`)
para variáveis que podem não existir.

## 5. Testar o KofTerm em Ubuntu, Debian, Fedora e Arch
**Etiquetas:** `help wanted`, `testing`

Até agora o KofTerm foi testado no Kali (QTerminal) e no tmux. Queremos saber como ele se
comporta em outras distribuições e terminais (GNOME Terminal, Konsole, Alacritty, kitty…).

**Resultado esperado:** um comentário nesta issue por ambiente, com os passos ★ do
[roteiro de teste](../TESTE_HUMANO.md) marcados ✅/⚠️/❌. Cada ❌ vira uma issue própria.

**Onde mexer:** nenhum código. Só usar e contar.

## 6. Índice e receitas em inglês
**Etiquetas:** `help wanted`, `index`, `recipes`

O KofTerm só fala português. Um `index/en.txt` e um `recipes/en.txt` abririam o projeto para
estudantes do mundo todo.

**Resultado esperado (primeira parte):** `index/en.txt` com as 20 entradas da seção
"Navegação e arquivos" traduzidas. A escolha do idioma (variável `LANG`) fica para outra
issue.

**Onde mexer:** arquivo novo `index/en.txt`, no mesmo formato.

## 7. Receitas de logs e serviços do dia a dia
**Etiquetas:** `good first issue`, `recipes`

Pedidos comuns que ainda não têm receita: "ver os logs do serviço X", "reiniciar a rede",
"ver por que o serviço X falhou".

**Resultado esperado:** receitas com `journalctl -u {servico} -n 50`,
`sudo systemctl restart NetworkManager` e `systemctl status {servico} --no-pager -l`.

**Onde mexer:** só `recipes/pt_BR.txt`.

## 8. Checagem automática dos links de leitura do índice
**Etiquetas:** `help wanted`, `docs`

O índice tem mais de 150 links de leitura. Hoje eles são conferidos à mão antes de cada
release.

**Resultado esperado:** um workflow do GitHub Actions (`.github/workflows/links.yml`) que roda
uma vez por semana, lê as linhas `@` de `index/pt_BR.txt` e abre uma issue se algum link
quebrar. O KofTerm continua sem código de rede: a checagem roda só no CI, nunca no programa.

**Onde mexer:** arquivo novo em `.github/workflows/`.
