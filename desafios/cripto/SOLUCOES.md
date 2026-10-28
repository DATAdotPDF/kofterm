# Soluções do desafio de criptografia

**Spoiler:** aqui estão todas as respostas. Tente os desafios do [README](README.md) antes.

Todos os comandos rodam dentro de `desafios/cripto/arquivos`, num Linux com `openssl`, `python3` e
as coreutils. As saídas abaixo são as reais.

## 1. Clássico: César

Testar os 25 deslocamentos com `tr`. O recorte `${A:k}${A:0:k}` é o alfabeto andado `k` casas, e o
`tr` o troca de volta pelo alfabeto normal:

```bash
A=ABCDEFGHIJKLMNOPQRSTUVWXYZ; for k in $(seq 1 25); do echo "$k: $(tr "${A:k}${A:0:k}" "$A" < 1_classico.txt)"; done
```

Só uma linha faz sentido:

```text
17: A CIFRA DE CESAR SO TEM VINTE E CINCO CHAVES POSSIVEIS ENTAO TESTAR TODAS E RAPIDO A PALAVRA SECRETA E FAROL
```

O deslocamento é **17**. No JCrypTool, com a chave por caractere, isso é **R** se a versão contar
A=0, ou **S** se contar A=1: teste as duas.

**Resposta: FAROL**

## 2. Simétrico: AES

```bash
openssl enc -d -aes-128-ecb -K 2B7E151628AED2A6ABF7158809CF4F3C -in 2_simetrico.bin
```

```text
AES COM A CHAVE CERTA VOLTA AO TEXTO ORIGINAL. A PALAVRA SECRETA E ORQUIDEA.
```

O `.hex` é o mesmo conteúdo: `xxd -r -p 2_simetrico.hex > c.bin` refaz o binário.

**Resposta: ORQUIDEA**

**O problema do ECB:** blocos iguais na entrada viram blocos iguais na saída.

```bash
printf 'A%.0s' {1..48} | openssl enc -aes-128-ecb -K 2B7E151628AED2A6ABF7158809CF4F3C | xxd
```

```text
00000000: 6c2a 3fd9 3aa7 b417 c543 8d26 a461 9519  l*?.:....C.&.a..
00000010: 6c2a 3fd9 3aa7 b417 c543 8d26 a461 9519  l*?.:....C.&.a..
00000020: 6c2a 3fd9 3aa7 b417 c543 8d26 a461 9519  l*?.:....C.&.a..
00000030: a254 be88 e037 ddd9 d79f b641 1c3f 9df8  .T...7.....A.?..
```

As três primeiras linhas são iguais: quem olha o texto cifrado sabe que a entrada se repete, sem
saber a chave. A última é o bloco de preenchimento PKCS#5. No modo CBC, cada bloco é misturado
com o anterior (e o primeiro com um IV aleatório), e o padrão some.

## 3. Assimétrico: RSA

```bash
factor 10057
```

```text
10057: 89 113
```

`φ = (89−1)·(113−1) = 88·112 = 9856`. O `d` é o inverso de 17 módulo 9856:

```bash
python3 -c "d = pow(17, -1, 9856); print(d, [pow(c, d, 10057) for c in (2229, 2851, 5546)])"
```

```text
7537 [1618, 913, 1519]
```

Com 4 dígitos cada: `1618 0913 1519` → `16 18 | 09 13 | 15 19` → `P R | I M | O S`.

Conferência: `17 · 7537 = 128129 = 13 · 9856 + 1`.

**Resposta: PRIMOS**

## 4. Hash

**Qual relatório mudou:**

```bash
sha256sum -c 4_SHA256SUMS
```

```text
4_relatorio_1.txt: OK
4_relatorio_2.txt: FAILED
4_relatorio_3.txt: OK
sha256sum: WARNING: 1 computed checksum did NOT match
```

O relatório 2 diz hoje `porta 23 aberta no host 10.0.0.5`. Quando a lista foi feita, dizia
`porta 22`: um único caractere mudou o hash inteiro.

**O PIN:** testar os 10.000 valores no Python leva menos de um segundo.

```bash
python3 -c "import hashlib; h = open('4_pin.sha256').read().split()[0]; print([p for p in (f'{i:04d}' for i in range(10000)) if hashlib.sha256(p.encode()).hexdigest() == h])"
```

```text
['7391']
```

Também dá só com o shell, mais devagar (um `sha256sum` por tentativa):

```bash
for p in $(seq -w 0 9999); do [ "$(printf %s "$p" | sha256sum | cut -d' ' -f1)" = "$(cut -d' ' -f1 4_pin.sha256)" ] && echo "$p" && break; done
```

**Respostas: o relatório 2 (porta 22 virou 23) e o PIN 7391**

## 5. MAC: HMAC-SHA256

```bash
for f in 5_mensagem_*.txt; do openssl dgst -sha256 -hmac 'lab-cripto-2026' "$f"; done
```

```text
HMAC-SHA2-256(5_mensagem_1.txt)= 78aa90fc1de87be0562a453b2dda04fe20f5b76b0538cfb532c390a96c0399c2
HMAC-SHA2-256(5_mensagem_2.txt)= 56c10e42d64c49ff436901ec202dc014ce7e64451343ffcf9818cadf0ccd0c64
HMAC-SHA2-256(5_mensagem_3.txt)= 7081f1b947467bf36fb8078e5637a4bddacf4ebcba9895db726efd6113f38057
```

Em `5_tags.txt`, a etiqueta da mensagem 2 é `dbb8bd9a…`, diferente da calculada. As outras duas
batem. A mensagem 2 diz `TRANSFERIR 9000 REAIS PARA A CONTA 6666`: o atacante trocou o texto, mas
sem a chave não conseguiu calcular a etiqueta certa.

**Resposta: 9000**

## 6. Números aleatórios: LCG

De `x2 = (a·x1 + c) mod m` sai `c = (x2 − a·x1) mod m`:

```bash
python3 -c "a, m = 214013, 2**32; x1, x2, x3 = 2503058659, 1594293274, 2992018037; c = (x2 - a*x1) % m; print(c, (a*x2 + c) % m == x3, (a*x3 + c) % m)"
```

```text
2531011 True 2674457444
```

O `c` é 2531011 (o mesmo do `rand()` do compilador C da Microsoft), o terceiro token confere, e o
quarto é 2674457444. Quem pediu três redefinições de senha consegue prever a de outra pessoa.

**Resposta: 2674457444**

## 7. Assinatura digital

```bash
openssl dgst -sha256 -verify 7_chave_publica.pem -signature 7_aviso.sig 7_aviso_A.txt
```

```text
Verified OK
```

```bash
openssl dgst -sha256 -verify 7_chave_publica.pem -signature 7_aviso.sig 7_aviso_B.txt
```

```text
Verification failure
```

(seguido de duas linhas de erro do OpenSSL com `bad signature`). O aviso A é o autêntico: a aula
não foi cancelada.

**Resposta: AURORA**

**HMAC × assinatura:** no HMAC, quem confere tem a mesma chave de quem calculou, então também
consegue falsificar. Na assinatura, conferir só pede a chave pública, e assinar exige a privada.
Por isso só a assinatura prova quem escreveu.

## Como os arquivos foram feitos

- César com deslocamento 17; AES-128-ECB com PKCS#5 (`openssl enc`) e a chave de exemplo da norma
  FIPS-197; RSA de livro com `p = 89`, `q = 113`, `e = 17`.
- O relatório 2 e a mensagem 2 foram trocados depois de calculadas a lista de hashes e as etiquetas.
- O LCG começou da semente 20261024, com `a = 214013`, `c = 2531011` e `m = 2³²`.
- A assinatura usa uma chave RSA de 2048 bits gerada com `openssl genpkey`. A chave privada foi
  apagada depois de assinar o aviso A.
