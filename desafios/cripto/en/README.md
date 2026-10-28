# Challenge: cryptography in practice

[Versão em português](../README.md)

Seven short challenges, one for each group in JCrypTool's **Crypto Explorer**: classical,
symmetric, asymmetric, hash, MAC, random numbers and signature. Each one hides an answer that only
appears when the algorithm is used the right way.

Each challenge can be solved in two ways, and the best is to do both and compare:

- **In JCrypTool**, the graphical program from the CrypTool project (it comes with the CSE-LABVM
  of the Cisco Networking Academy cybersecurity course).
- **In the terminal**, on any Linux with `openssl`, `python3` and the coreutils (Kali has them all).
  Inside [KofTerm](../../../README.md), the right-hand column explains each command as you type.

Everything is offline: no challenge needs the internet.

## Getting started

```bash
git clone https://github.com/DATAdotPDF/kofterm.git
```
```bash
cd kofterm/desafios/cripto/en/files && ls
```

The files start with the challenge number (`1_classical.txt`, `2_symmetric.bin`…). In JCrypTool,
open each one with **File > Open**.

## Checking an answer

Answers are one word in CAPITALS or a number. To check one without seeing the solution, compute the
SHA-256 of your answer and compare it with the table at the end of this page:

```bash
printf '%s' 'YOURANSWER' | sha256sum
```

If the first characters match, you got it. Checking this way is already using a hash (challenge 4):
you can test the answer without the page giving it away.

---

## 1. Classical: Caesar

**The idea:** each letter moves a fixed number of places in the alphabet. With 26 letters, only
25 shifts change the text.

**You get:** `1_classical.txt`, a sentence encrypted with a shift nobody told you.

**Mission:** find the shift and read the sentence. The answer is the secret word at the end.

- **JCrypTool:** open the file, **Classic > Caesar**, operation **Decrypt**, alphabet
  **Latin (A-Z)**. Try keys until the text makes sense. If the spaces disappear, turn off the
  option that filters characters outside the alphabet.
- **Terminal:** `tr` swaps one alphabet for another. With `A=ABCDEFGHIJKLMNOPQRSTUVWXYZ`, the slice
  `${A:3}${A:0:3}` is the alphabet moved 3 places. A `for` from 1 to 25 tries them all.

**Think about it:** how many tries does a computer need to break Caesar? What if the key were a word
(Vigenère)?

## 2. Symmetric: AES

**The idea:** the same key encrypts and decrypts. AES works on 16-byte blocks.

**You get:** `2_symmetric.bin` (the ciphertext; `2_symmetric.hex` is the same content in
hexadecimal) and the key, which leaked in this story:

| Setting | Value |
|---|---|
| Algorithm | AES, 128-bit key |
| Key (hex) | `000102030405060708090A0B0C0D0E0F` |
| Mode | ECB (Electronic Codebook) |
| Padding | PKCS#5 |

**Mission:** decrypt the file. The answer is the secret word in the text.

- **JCrypTool:** open `2_symmetric.bin`, **Symmetric > AES**, operation **Decrypt**,
  **Custom key**, size 128, the key above, ECB mode and PKCS#5.
- **Terminal:** `openssl enc` with `-d` (decrypt), `-aes-128-ecb`, `-K` (the key in hex) and `-in`.

**Think about it:** encrypt 48 letters `A` in ECB with this key and look at the result with `xxd`.
What repeats? Why is that a problem for an image or a database? What does CBC mode change?

## 3. Asymmetric: RSA

**The idea:** the public key (`n`, `e`) encrypts; only whoever knows the private key `d` decrypts.
The security comes from how hard it is to factor `n` when it is huge. Here it is small on purpose.

**You get:** `3_asymmetric.txt`, with `n`, `e` and three encrypted numbers `c`. Each decrypted
number has 4 digits: two letters, with `A=01`, `B=02` … `Z=26` (e.g. `0102` = AB).

**Mission:** factor `n` into `p × q`, compute `φ = (p−1)(q−1)` and `d` (the inverse of `e`
modulo `φ`), decrypt each `c` with `m = c^d mod n` and turn the numbers into letters. The answer is
the word.

- **JCrypTool:** in the **Visuals** perspective, the **RSA Cryptosystem** takes `p`, `q` and `e`,
  computes `d` and decrypts numbers (names may differ a little between versions).
- **Terminal:** `factor` factors `n`; in Python, `pow(e, -1, phi)` gives `d` and `pow(c, d, n)`
  decrypts.

**Think about it:** encrypting two letters at a time with the same key always gives the same number.
What attack does that allow? That is why real RSA uses random padding (OAEP).

## 4. Hash: integrity and weak passwords

**The idea:** a hash is the fingerprint of some data. Change one byte and the whole hash changes. But
a hash has no secret: anyone can compute it.

**You get:** three reports (`4_report_*.txt`), the list `4_SHA256SUMS` made when they were
written, and `4_pin.sha256`, the SHA-256 hash of a 4-digit PIN.

**Mission:**
1. Find which report was changed after the list was made, and what changed in it.
2. Find the PIN. There are only 10,000 possibilities.

- **JCrypTool:** **Hash > SHA-256** on each report and compare with the list. The PIN needs brute
  force, which is easier in the terminal.
- **Terminal:** `sha256sum -c` checks the whole list. For the PIN, generate `0000` to `9999` and
  compare the hash of each one.

This challenge checks itself: `sha256sum -c` says which one failed, and the right PIN hashes to the
value in the file.

**Think about it:** why do password systems use salt and slow algorithms (bcrypt, Argon2) instead
of plain SHA-256?

## 5. MAC: HMAC-SHA256

**The idea:** a MAC is a hash that depends on a secret key. Without the key, nobody can compute the
right tag for a changed message.

**You get:** three transfer orders (`5_message_*.txt`) and `5_tags.txt`, with the HMAC-SHA256 tag
the bank computed for each one. The key shared by the bank and the branch is `crypto-lab-2026`
(in hex: `63727970746f2d6c61622d32303236`).

**Mission:** one of the orders was swapped on the way. Find which one. The answer is the amount, in
dollars, of the fake order.

- **JCrypTool:** open each message and use **MACs > HMac SHA256** with the key. If it asks for the
  key in hex, use the hex version above.
- **Terminal:** `openssl dgst -sha256 -hmac 'KEY' file` and compare with `5_tags.txt`.

The tags cover the whole file, including the line break at the end.

**Think about it:** if the bank used plain SHA-256, with no key, what would stop the attacker from
changing the message and recomputing the hash too?

## 6. Random numbers: a predictable generator

**The idea:** keys, tokens and passwords need unpredictable numbers. A linear congruential generator
(LCG) does `x(next) = (a·x + c) mod m`: it looks random, but anyone who sees a few values can
predict the next ones.

**You get:** `6_random.txt`, with `a`, `m` and three consecutive password-reset tokens a system
sent. `c` is the system's secret.

**Mission:** find `c` from two tokens, check it with the third, and predict the **fourth token**.
The answer is that number.

- **Terminal:** from `x2 = (a·x1 + c) mod m` you get `c = (x2 − a·x1) mod m`. Python does the math.
- **JCrypTool:** use the **Random** group to generate numbers with a cryptographic generator and
  compare with `openssl rand -hex 16` and `head -c 16 /dev/urandom | xxd -p`. Can any of them be
  predicted this way?

**Think about it:** why are C's `rand()` and Python's `random` no good for tokens? What should you
use instead (`/dev/urandom`, Python's `secrets`)?

## 7. Digital signature: RSA with SHA-256

**The idea:** whoever has the private key signs; anyone with the public key checks. A valid signature
proves who wrote it and that nothing changed.

**You get:** the lab's public key (`7_public_key.pem`), two notices that say different things
(`7_notice_A.txt` and `7_notice_B.txt`) and a single signature (`7_notice.sig`).

**Mission:** find which notice the lab really signed. The answer is its secret word.

- **Terminal:** `openssl dgst -sha256 -verify 7_public_key.pem -signature 7_notice.sig` followed by
  the notice. The right one answers `Verified OK`.
- **JCrypTool:** importing a PEM key into the keystore takes work, so go the other way: create a key
  pair in the keystore, sign a text under **Signature**, change one letter and verify again. The
  check must fail.

The private key that signed the notice is not in the repository: nobody can sign the fake notice.

**Think about it:** what is the difference between the signature and the HMAC in challenge 5? Who
can check each one, and who can forge it?

---

## Answer check table

The first 16 characters of the SHA-256 of each answer (`printf '%s' 'ANSWER' | sha256sum`):

| Challenge | Start of the answer's SHA-256 |
|---|---|
| 1. Classical | `049097c5e8f55474` |
| 2. Symmetric | `0debc05369e59b38` |
| 3. Asymmetric | `a7305ad2384bba55` |
| 4. Hash | checks itself (`sha256sum -c` and the PIN hash) |
| 5. MAC | `04d901cdcc744547` |
| 6. Random | `a9d34edb91fff421` |
| 7. Signature | `6efb1c6ec4447e4c` |

## Solutions

The full solutions, with every command and its output, are in [SOLUTIONS.md](SOLUTIONS.md). Try
first.

The JCrypTool steps follow the CSE-LABVM version; menus and names may differ a little in other
versions. Found a mistake or have an idea for a challenge? Open an
[issue](https://github.com/DATAdotPDF/kofterm/issues).
