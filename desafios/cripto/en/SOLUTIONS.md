# Cryptography challenge solutions

**Spoiler:** every answer is here. Try the challenges in the [README](README.md) first.

All commands run inside `desafios/cripto/en/files`, on a Linux with `openssl`, `python3` and the
coreutils. The outputs below are the real ones.

## 1. Classical: Caesar

Try the 25 shifts with `tr`. The slice `${A:k}${A:0:k}` is the alphabet moved `k` places, and `tr`
swaps it back to the normal alphabet:

```bash
A=ABCDEFGHIJKLMNOPQRSTUVWXYZ; for k in $(seq 1 25); do echo "$k: $(tr "${A:k}${A:0:k}" "$A" < 1_classical.txt)"; done
```

Only one line makes sense:

```text
11: THE CAESAR CIPHER HAS ONLY TWENTY FIVE USEFUL KEYS SO TRYING THEM ALL IS QUICK THE SECRET WORD IS LIGHTHOUSE
```

The shift is **11**. In JCrypTool, with the key given as a character, that is **L** if the version
counts A=0, or **M** if it counts A=1: try both.

**Answer: LIGHTHOUSE**

## 2. Symmetric: AES

```bash
openssl enc -d -aes-128-ecb -K 000102030405060708090A0B0C0D0E0F -in 2_symmetric.bin
```

```text
WITH THE RIGHT KEY AES GIVES BACK THE ORIGINAL TEXT. THE SECRET WORD IS ORCHID.
```

The `.hex` file is the same content: `xxd -r -p 2_symmetric.hex > c.bin` rebuilds the binary.

**Answer: ORCHID**

**The trouble with ECB:** equal blocks in the input become equal blocks in the output.

```bash
printf 'A%.0s' {1..48} | openssl enc -aes-128-ecb -K 000102030405060708090A0B0C0D0E0F | xxd
```

```text
00000000: dd4b 1a0b 47da a706 7d0b 59d9 5d58 a6ae  .K..G...}.Y.]X..
00000010: dd4b 1a0b 47da a706 7d0b 59d9 5d58 a6ae  .K..G...}.Y.]X..
00000020: dd4b 1a0b 47da a706 7d0b 59d9 5d58 a6ae  .K..G...}.Y.]X..
00000030: 954f 64f2 e4e8 6e9e ee82 d202 1668 4899  .Od...n......hH.
```

The first three lines are the same: anyone looking at the ciphertext knows the input repeats,
without knowing the key. The last line is the PKCS#5 padding block. In CBC mode, each block is
mixed with the previous one (and the first with a random IV), and the pattern disappears.

## 3. Asymmetric: RSA

```bash
factor 10403
```

```text
10403: 101 103
```

`φ = (101−1)·(103−1) = 100·102 = 10200`. `d` is the inverse of 7 modulo 10200:

```bash
python3 -c "d = pow(7, -1, 10200); print(d, [pow(c, d, 10403) for c in (1845, 1537, 5157)])"
```

```text
8743 [1618, 913, 519]
```

With 4 digits each: `1618 0913 0519` → `16 18 | 09 13 | 05 19` → `P R | I M | E S`.

Check: `7 · 8743 = 61201 = 6 · 10200 + 1`.

**Answer: PRIMES**

## 4. Hash

**Which report changed:**

```bash
sha256sum -c 4_SHA256SUMS
```

```text
4_report_1.txt: OK
4_report_2.txt: OK
4_report_3.txt: FAILED
sha256sum: WARNING: 1 computed checksum did NOT match
```

Report 3 now says `port 3389 open on host 10.0.0.1`. When the list was made, it said
`host 10.0.0.7`: a single character changed the whole hash.

**The PIN:** trying all 10,000 values in Python takes under a second.

```bash
python3 -c "import hashlib; h = open('4_pin.sha256').read().split()[0]; print([p for p in (f'{i:04d}' for i in range(10000)) if hashlib.sha256(p.encode()).hexdigest() == h])"
```

```text
['4826']
```

It also works with the shell alone, more slowly (one `sha256sum` per try):

```bash
for p in $(seq -w 0 9999); do [ "$(printf %s "$p" | sha256sum | cut -d' ' -f1)" = "$(cut -d' ' -f1 4_pin.sha256)" ] && echo "$p" && break; done
```

**Answers: report 3 (host 10.0.0.7 became 10.0.0.1) and PIN 4826**

## 5. MAC: HMAC-SHA256

```bash
for f in 5_message_*.txt; do openssl dgst -sha256 -hmac 'crypto-lab-2026' "$f"; done
```

```text
HMAC-SHA2-256(5_message_1.txt)= 3ba8ec9b102e1657aeb2e554c12207cf12e9d1a90a28610683d46929fae7bb32
HMAC-SHA2-256(5_message_2.txt)= 2c1d5014b9f48747da070389b8c579f07b5c465aad7bc0accf26b21ee89517ae
HMAC-SHA2-256(5_message_3.txt)= 0b32fe520bcd9ef7684cc08357b6d10144e64e6f8133ebb9850aeaeaf038c526
```

In `5_tags.txt`, the tag of message 3 is `40c49cd7…`, different from the computed one. The other
two match. Message 3 says `TRANSFER 7500 DOLLARS TO ACCOUNT 6666`: the attacker changed the text,
but without the key could not compute the right tag.

**Answer: 7500**

## 6. Random numbers: LCG

From `x2 = (a·x1 + c) mod m` you get `c = (x2 − a·x1) mod m`:

```bash
python3 -c "a, m = 214013, 2**32; x1, x2, x3 = 2717328948, 855833639, 646776398; c = (x2 - a*x1) % m; print(c, (a*x2 + c) % m == x3, (a*x3 + c) % m)"
```

```text
2531011 True 353780697
```

`c` is 2531011 (the same as `rand()` in Microsoft's C compiler), the third token checks out, and
the fourth is 353780697. Someone who asked for three password resets can predict someone else's.

**Answer: 353780697**

## 7. Digital signature

```bash
openssl dgst -sha256 -verify 7_public_key.pem -signature 7_notice.sig 7_notice_A.txt
```

```text
Verification failure
```

(followed by two OpenSSL error lines with `bad signature`).

```bash
openssl dgst -sha256 -verify 7_public_key.pem -signature 7_notice.sig 7_notice_B.txt
```

```text
Verified OK
```

Notice B is the real one: the class was not cancelled.

**Answer: DAWN**

**HMAC vs. signature:** with HMAC, whoever checks has the same key as whoever computed the tag, so
they can also forge it. With a signature, checking only needs the public key, and signing needs the
private one. That is why only the signature proves who wrote it.

## How the files were made

- Caesar with shift 11; AES-128-ECB with PKCS#5 (`openssl enc`) and the sequential test key
  `000102…0F`; textbook RSA with `p = 101`, `q = 103`, `e = 7`.
- Report 3 and message 3 were swapped after the hash list and the tags were computed.
- The LCG started from seed 19700101, with `a = 214013`, `c = 2531011` and `m = 2³²`.
- The signature uses a 2048-bit RSA key made with `openssl genpkey`. The private key was deleted
  right after signing notice B.
