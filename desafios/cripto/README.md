# Desafio: criptografia na prática

[English version](en/README.md)

Sete desafios curtos, um para cada grupo do **Crypto Explorer** do JCrypTool: clássico, simétrico,
assimétrico, hash, MAC, números aleatórios e assinatura. Cada um esconde uma resposta que só aparece
quando o algoritmo é usado do jeito certo.

Cada desafio pode ser resolvido de duas formas, e o melhor é fazer as duas e comparar:

- **No JCrypTool**, o programa gráfico do projeto CrypTool (já vem na CSE-LABVM do curso de
  cibersegurança da Cisco Networking Academy).
- **No terminal**, em qualquer Linux com `openssl`, `python3` e as coreutils (no Kali já vem tudo).
  Dentro do [KofTerm](../../README.pt_BR.md), a coluna da direita explica cada comando enquanto você digita.

Tudo é offline: nenhum desafio precisa de internet.

## Como começar

```bash
git clone https://github.com/DATAdotPDF/kofterm.git
```
```bash
cd kofterm/desafios/cripto/arquivos && ls
```

Os arquivos começam com o número do desafio (`1_classico.txt`, `2_simetrico.bin`…). No JCrypTool,
abra cada um com **Arquivo > Abrir**.

## Como conferir uma resposta

As respostas são uma palavra em MAIÚSCULAS, sem acento, ou um número. Para conferir sem ver a
solução, calcule o SHA-256 da sua resposta e compare com a tabela no fim desta página:

```bash
printf '%s' 'SUARESPOSTA' | sha256sum
```

Se os primeiros caracteres baterem, acertou. Repare que conferir assim já é usar um hash (desafio 4):
dá para checar a resposta sem que a página a revele.

---

## 1. Clássico: César

**A ideia:** cada letra anda um número fixo de casas no alfabeto. Com 26 letras, só existem 25
deslocamentos que mudam o texto.

**Você recebe:** `1_classico.txt`, uma frase cifrada com um deslocamento que ninguém contou.

**Missão:** descubra o deslocamento e leia a frase. A resposta é a palavra secreta do fim.

- **JCrypTool:** abra o arquivo, **Clássico > César**, operação **Descriptografar**, alfabeto
  **Latim (A-Z)**. Tente chaves até o texto fazer sentido. Se os espaços sumirem, desligue a opção
  que filtra caracteres fora do alfabeto.
- **Terminal:** o `tr` troca um alfabeto por outro. Com `A=ABCDEFGHIJKLMNOPQRSTUVWXYZ`, o recorte
  `${A:3}${A:0:3}` é o alfabeto andado 3 casas. Um `for` de 1 a 25 testa todas.

**Para pensar:** quantas tentativas um computador precisa para quebrar César? E se a chave fosse
uma palavra (Vigenère)?

## 2. Simétrico: AES

**A ideia:** a mesma chave cifra e decifra. O AES trabalha em blocos de 16 bytes.

**Você recebe:** `2_simetrico.bin` (o texto cifrado; `2_simetrico.hex` é o mesmo conteúdo em
hexadecimal) e a chave, que nesta história vazou:

| Configuração | Valor |
|---|---|
| Algoritmo | AES, chave de 128 bits |
| Chave (hex) | `2B7E151628AED2A6ABF7158809CF4F3C` |
| Modo | ECB (Electronic Codebook) |
| Preenchimento | PKCS#5 |

**Missão:** decifre o arquivo. A resposta é a palavra secreta do texto.

- **JCrypTool:** abra `2_simetrico.bin`, **Simétrico > AES**, operação **Descriptografar**,
  **Chave personalizada**, tamanho 128, a chave acima, modo ECB e PKCS#5.
- **Terminal:** `openssl enc` com `-d` (decifrar), `-aes-128-ecb`, `-K` (a chave em hexa) e `-in`.

**Para pensar:** cifre 48 letras `A` em ECB com essa chave e olhe o resultado com `xxd`. O que se
repete? Por que isso é um problema para uma imagem ou um banco de dados? O que o modo CBC muda?

## 3. Assimétrico: RSA

**A ideia:** a chave pública (`n`, `e`) cifra; só quem conhece a chave privada `d` decifra. A
segurança vem de ser difícil fatorar `n` quando ele é enorme. Aqui ele é pequeno de propósito.

**Você recebe:** `3_assimetrico.txt`, com `n`, `e` e três números cifrados `c`. Cada número
decifrado tem 4 dígitos: duas letras, com `A=01`, `B=02` … `Z=26` (ex.: `0102` = AB).

**Missão:** fatore `n` em `p × q`, calcule `φ = (p−1)(q−1)` e `d` (o inverso de `e` módulo `φ`),
decifre cada `c` com `m = c^d mod n` e transforme os números em letras. A resposta é a palavra.

- **JCrypTool:** na perspectiva de **Visualizações**, o **RSA Cryptosystem** aceita `p`, `q` e `e`,
  calcula `d` e decifra números (os nomes podem variar um pouco entre versões).
- **Terminal:** `factor` fatora o `n`; no Python, `pow(e, -1, phi)` dá o `d` e `pow(c, d, n)` decifra.

**Para pensar:** cifrar duas letras por vez com a mesma chave sempre dá o mesmo número. Que ataque
isso permite? É por isso que o RSA real usa preenchimento aleatório (OAEP).

## 4. Hash: integridade e senhas fracas

**A ideia:** um hash é a impressão digital de um dado. Mude um byte e o hash muda inteiro. Mas
um hash não tem segredo: qualquer um calcula.

**Você recebe:** três relatórios (`4_relatorio_*.txt`), a lista `4_SHA256SUMS` feita quando eles
foram escritos, e `4_pin.sha256`, o hash SHA-256 de um PIN de 4 dígitos.

**Missão:**
1. Descubra qual relatório foi alterado depois que a lista foi feita, e o que mudou nele.
2. Descubra o PIN. São só 10.000 possibilidades.

- **JCrypTool:** **Hash > SHA-256** em cada relatório e compare com a lista. O PIN pede força bruta,
  que é mais prática no terminal.
- **Terminal:** `sha256sum -c` confere a lista inteira. Para o PIN, gere `0000` a `9999` e compare
  o hash de cada um.

Este desafio se confere sozinho: o `sha256sum -c` diz qual falhou, e o hash do PIN certo é igual
ao do arquivo.

**Para pensar:** por que sistemas de senha usam sal e algoritmos lentos (bcrypt, Argon2) em vez de
um SHA-256 puro?

## 5. MAC: HMAC-SHA256

**A ideia:** um MAC é um hash que depende de uma chave secreta. Quem não tem a chave não consegue
calcular a etiqueta certa para uma mensagem alterada.

**Você recebe:** três ordens de transferência (`5_mensagem_*.txt`) e `5_tags.txt`, com a etiqueta
HMAC-SHA256 que o banco calculou para cada uma. A chave combinada entre o banco e a agência é
`lab-cripto-2026` (em hexa: `6c61622d63726970746f2d32303236`).

**Missão:** uma das ordens foi trocada no caminho. Descubra qual. A resposta é o valor, em reais,
da ordem falsa.

- **JCrypTool:** abra cada mensagem e use **MACs > HMac SHA256** com a chave. Se ele pedir a chave
  em hexa, use a versão em hexa acima.
- **Terminal:** `openssl dgst -sha256 -hmac 'CHAVE' arquivo` e compare com `5_tags.txt`.

As etiquetas valem para o arquivo inteiro, incluindo a quebra de linha do fim.

**Para pensar:** se o banco usasse só SHA-256, sem chave, o que impediria o atacante de trocar a
mensagem e recalcular o hash junto?

## 6. Números aleatórios: um gerador previsível

**A ideia:** chaves, tokens e senhas precisam de números imprevisíveis. Um gerador congruencial
linear (LCG) faz `x(seguinte) = (a·x + c) mod m`: parece aleatório, mas quem vê alguns valores
consegue prever os próximos.

**Você recebe:** `6_random.txt`, com `a`, `m` e três tokens de redefinição de senha seguidos que
um sistema enviou. O `c` é segredo do sistema.

**Missão:** descubra o `c` com dois tokens, confira com o terceiro e preveja o **quarto token**.
A resposta é esse número.

- **Terminal:** de `x2 = (a·x1 + c) mod m` sai `c = (x2 − a·x1) mod m`. O Python faz a conta.
- **JCrypTool:** use o grupo **Random** para gerar números com um gerador criptográfico e compare
  com `openssl rand -hex 16` e `head -c 16 /dev/urandom | xxd -p`. Algum deles dá para prever assim?

**Para pensar:** por que `rand()` do C ou `random` do Python não servem para gerar tokens? O que usar
no lugar (`/dev/urandom`, `secrets` do Python)?

## 7. Assinatura digital: RSA com SHA-256

**A ideia:** quem tem a chave privada assina; qualquer um com a chave pública confere. Uma
assinatura válida prova quem escreveu e que nada mudou.

**Você recebe:** a chave pública do laboratório (`7_chave_publica.pem`), dois avisos que dizem
coisas diferentes (`7_aviso_A.txt` e `7_aviso_B.txt`) e uma única assinatura (`7_aviso.sig`).

**Missão:** descubra qual aviso o laboratório realmente assinou. A resposta é a palavra secreta
dele.

- **Terminal:** `openssl dgst -sha256 -verify 7_chave_publica.pem -signature 7_aviso.sig` seguido
  do aviso. O certo responde `Verified OK`.
- **JCrypTool:** importar uma chave PEM no keystore dá trabalho, então faça o caminho inverso: crie
  um par de chaves no keystore, assine um texto em **Assinatura**, mude uma letra e confira de novo.
  A verificação tem que falhar.

A chave privada que assinou o aviso não está no repositório: ninguém consegue assinar o aviso falso.

**Para pensar:** qual a diferença entre a assinatura e o HMAC do desafio 5? Quem consegue conferir
cada um, e quem consegue falsificar?

---

## Tabela para conferir

Os primeiros 16 caracteres do SHA-256 de cada resposta (`printf '%s' 'RESPOSTA' | sha256sum`):

| Desafio | Começo do SHA-256 da resposta |
|---|---|
| 1. Clássico | `328c6c638e5a0221` |
| 2. Simétrico | `aaceffe5e3280701` |
| 3. Assimétrico | `b6065a3c643b33c1` |
| 4. Hash | confere sozinho (`sha256sum -c` e o hash do PIN) |
| 5. MAC | `c4fe6b6dbe94790f` |
| 6. Random | `dcb70c08854fbdf0` |
| 7. Assinatura | `1e28b2651a6d1b24` |

## Soluções

As soluções completas, com os comandos e a saída de cada um, estão em [SOLUCOES.md](SOLUCOES.md).
Tente antes de abrir.

Os passos no JCrypTool seguem a versão da CSE-LABVM; menus e nomes podem mudar um pouco em outras
versões. Achou um erro ou tem uma ideia de desafio? Abra uma
[issue](https://github.com/DATAdotPDF/kofterm/issues).
