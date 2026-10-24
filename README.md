<p align="center">
  <img src="docs/images/banner.png" width="100%" alt="KOFTERM: your problems with the terminal are over! A Linux terminal that explains each command, 100% offline, written in KOF. Free and open source.">
</p>

<h1 align="center">KOFTERM</h1>

<p align="center"><b>The Linux terminal that teaches you while you use it.</b><br>
Explains each command as you type, suggests the rest of the line and understands plain-language requests.<br>
Open source, 100% offline and written in <a href="https://koflang.github.io">KOF</a>, a Brazilian programming language.</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-GPLv3-blue?style=flat-square" alt="GPLv3 license"></a>
  <a href="https://github.com/KofLang/Kof4j"><img src="https://img.shields.io/badge/Built_with-KOF_0.6.6-f59e0b?style=flat-square" alt="Built with KOF 0.6.6"></a>
  <img src="https://img.shields.io/badge/Platform-Linux_x86__64-FCC624?style=flat-square&logo=linux&logoColor=black" alt="Linux x86_64">
  <img src="https://img.shields.io/badge/Network-none-22c55e?style=flat-square" alt="No network">
  <a href="https://github.com/DATAdotPDF/kofterm/releases"><img src="https://img.shields.io/badge/Release-v0.9.0-8b5cf6?style=flat-square" alt="Release v0.9.0"></a>
  <a href="https://github.com/DATAdotPDF/kofterm/actions/workflows/ci.yml"><img src="https://github.com/DATAdotPDF/kofterm/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <a href="https://github.com/DATAdotPDF/kofterm/labels/good%20first%20issue"><img src="https://img.shields.io/github/issues/DATAdotPDF/kofterm/good%20first%20issue?style=flat-square&label=good%20first%20issue&color=7057ff" alt="good first issue"></a>
</p>

<p align="center">
  <a href="https://datadotpdf.github.io/kofterm/"><b>Website</b></a> ·
  <a href="README.pt_BR.md">Português</a> ·
  <a href="CONTRIBUTING.md">How to contribute</a> ·
  <a href="docs/HOW_IT_WAS_BUILT.md">How it was built</a> ·
  <a href="docs/JOURNAL.md">Journal</a>
</p>

<p align="center">
  <b>KofTerm is and will always be free.</b> No feature is behind a payment.<br>
  But if it helped you and you feel like buying me a coffee (or a Monster) so I can spend<br>
  more nights studying and building cool things for the community, that makes me very happy &lt;3
</p>
<p align="center">
  <a href="https://www.buymeacoffee.com/dotpdf"><img src="https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20coffee&emoji=&slug=dotpdf&button_colour=5F7FFF&font_colour=ffffff&font_family=Lato&outline_colour=000000&coffee_colour=FFDD00" alt="Buy Me a Coffee: dotpdf" height="40"></a><br>
  <sub>or Pix (Brazil, Itaú), random key: <code>a6a35680-c2cd-4e0e-ab3d-8c601cc159c4</code></sub>
</p>

---

```text
                                                                          │ Índice · F2 fecha · F1 busca
┌──(aluno㉿kali)-[~]                                                      │
└─$ sudo cat /etc/shadow                                                  │ cat
                                                                          │ Mostra o conteúdo de arquivos (ou
                                                                          │ junta vários).
                                                                          │
                                                                          │ TAMBÉM NA LINHA
                                                                          │ sudo
                                                                          │   "Super-user do": roda UM comando
                                                                          │   como administrador (root). Pede a
                                                                          │   SUA senha, não a do root, e só
                                                                          │   funciona se você estiver no grupo
                                                                          │   sudo. Tudo fica registrado no
                                                                          │   journal.
                                                                          │ /etc/shadow
                                                                          │   Os hashes das senhas e as regras
                                                                          │   de validade. Só o root lê: sem
                                                                          │   sudo dá "Permissão negada".
```
<p align="center"><sub>A real KofTerm screen on Kali: your usual Bash on the left, the index column explaining the line on the right (F2 shows or hides it). The interface starts in Portuguese; `kofterm lang en` switches the index and the screens to English.</sub></p>

## Install

You need Linux x86_64 (a VM is fine). The program only depends on the system `libc`.

**Ready-made release, no KOF needed:** download `kofterm-0.9.0-linux-x86_64.tar.gz` and `SHA256SUMS` from the [releases page](https://github.com/DATAdotPDF/kofterm/releases).

```bash
sha256sum -c SHA256SUMS --ignore-missing && tar -xzf kofterm-0.9.0-linux-x86_64.tar.gz && ./kofterm-0.9.0-linux-x86_64/kofterm install
```

**From source:** the installer builds with KOF 0.6.6. If KOF is missing, it asks before downloading it and checks its SHA-256.

```bash
git clone https://github.com/DATAdotPDF/kofterm.git && cd kofterm && ./install.sh
```

Then just open it:

```bash
kofterm
```

### Update

Run `kofterm update`: it shows the right command for your case, without downloading or running anything. In short, you install the new version over the old one. Your history and what KofTerm learned from you live in `~/.local/share/kofterm` and stay there.

**If you installed from source**, inside the folder you cloned:

```bash
cd ~/kofterm && git pull && ./install.sh
```

**If you installed the ready-made release**, download the new `.tar.gz` and `SHA256SUMS` from the [releases page](https://github.com/DATAdotPDF/kofterm/releases) and run the same install command with the new version number.

Then close and reopen any KofTerm windows that were open: each one keeps running the old version until it is reopened. To check: `kofterm version`. What changed in each version is in the [CHANGELOG](CHANGELOG.md). KofTerm never updates itself, because it doesn't use the internet.

## First steps

| Key | What it does |
| --- | --- |
| **TAB** or **→** | Accepts the grey suggestion (**Ctrl+→** accepts one word) |
| **F2** | Shows or hides the index column |
| **F1** or **Ctrl+T** | Full-screen index search |
| **?** + your request | `? instalar o htop`, `? quem usa a porta 22`. **TAB** puts the command on the line; Enter runs it |
| **↑ / ↓** | Previous commands |
| **Ctrl+R** | Searches the history: type part of a command, the column lists every match, **↑/↓** picks, Enter puts it on the line (without running it), Esc goes back |
| **TAB** with no grey suggestion | When a name could be several files, the column lists them: **TAB** goes to the next, Enter picks |
| **Mouse wheel** or **Shift+PgUp/PgDn** | Scrolls back through old output (last 2,000 lines); any key returns. To select text with the mouse, hold **Shift**. **F3** turns the wheel off |
| **Ctrl-L** | Clears the screen and keeps what you were typing |

Try this: type `ls -la` slowly and watch the column; run `cat /etc/shadow` and look at the next line; ask `? qual meu ip`. To try everything calmly, follow the [test script](docs/TESTE_HUMANO.md) (Portuguese).

**In English:** run `kofterm lang en` and open a new KofTerm window. The index, every screen and the `?` recipes switch to English (`? install htop`). `kofterm lang pt` switches back.

Other commands: `kofterm doctor` checks the installation, `kofterm uninstall` removes the program (your history stays; `--purge` deletes everything).

## What it does

| | |
| --- | --- |
| **Index column** | As you type, the right-hand column explains the command, each option used (`-ld` becomes `-l` + `-d`), `sudo` and the paths on the line (`/etc/shadow`). 148 commands and paths, written for beginners. **F1** opens the search. |
| **Ask your way** | `? qual o gateway` suggests `ip r`; `? quanto espaço sobrou` suggests `df -h`. 142 recipes reviewed by people, tolerant to accents, synonyms and typos. It never makes up a command. |
| **Grey suggestion** | The rest of the line shows in grey, like in VS Code, and **TAB** accepts it. It learns from what you run, on your machine only. |
| **Reads the context** | "Permission denied" suggests the same command with `sudo`; `gti status` becomes `git status`; a missing program becomes `sudo apt install` with the right package. |
| **Works as root** | After `sudo -i` everything keeps working, and suggestions drop `sudo`. |
| **Risk by context** | Looks at every command on the line, `sudo` (or being root) and the current folder. **DANGER** (`rm -rf /`, `> /etc/passwd`, `dd` to a disk) turns red and is never suggested; **Caution** (`sudo rm -rf /etc/nginx`, `curl … \| sh`, `reboot`) shows in yellow, always with the reason. |

## Why KofTerm exists

Someone starting with Linux opens the terminal and finds a blinking cursor. Learning what `ls -ld` does means digging through `--help`; finding the command to "see the gateway" means leaving the terminal to search; "Permission denied" or "command not found" don't say what to do next.

KofTerm was born from studying networking at Cisco and having to learn Bash on a Kali VM. It sits **next to your prompt** like a patient teacher: you keep your usual Bash, and it explains, suggests and corrects as you type. Nothing runs without your Enter.

**It's for you if** you are studying Linux, networking or cybersecurity (Cisco courses, VM labs, Codecademy, Hack The Box) and want to learn the terminal by using the terminal.

## Safe by rule

KofTerm sees what you type, so it follows rules that don't change:

- **100% offline.** The program opens no network connections, and CI rejects network code. Check it: inside KofTerm, `ls -l /proc/$PPID/fd | grep -c socket` prints `0`.
- **Nothing runs by itself.** Suggestions and recipes only fill the line.
- **Your data stays with you,** in `~/.local/share/kofterm` (folder 0700). `sudo` passwords don't go through the editor; lines with a password, token or key (and lines starting with a space) still run but are never saved to the history.
- **Ethical study.** Scanning and capture tools come with a warning: only on your own lab network or with written permission.
- **It installs nothing.** When a tool is missing, it explains how to install it; the decision is yours.

Details and how to report a vulnerability: [SECURITY.md](SECURITY.md).

## Made in KOF

The terminal, the screen emulator, the learning model, the installer and the 76 tests are written in [KOF](https://koflang.github.io), a Brazilian language created by Mel Santos. Whatever the language lacks becomes a parallel KOF library, never another language; the only boundary is the system libc. Along the way, four compiler bugs were found and [reported to KOF](docs/KOF_FINDINGS.md). Memory stays at 7.9 MB.

How it was all built, phase by phase: [docs/HOW_IT_WAS_BUILT.md](docs/HOW_IT_WAS_BUILT.md).

## How to help

KofTerm is open source and built to **help, cooperate and add up**. You **don't need to know KOF**: the most valuable contributions are plain-language text.

| I want to... | Start with |
| --- | --- |
| Teach the `?` mode a new request | [New recipe](CONTRIBUTING.md#receita-nova-o-caminho-mais-rápido-para-o-seu-primeiro-pr) in `recipes/pt_BR.txt` |
| Explain a command better | [Index entry](CONTRIBUTING.md#entrada-no-índice) in `index/pt_BR.txt` |
| Test it and report back | [Test script](docs/TESTE_HUMANO.md) and an [issue](https://github.com/DATAdotPDF/kofterm/issues/new/choose) |
| Write KOF code | [`good first issue`](https://github.com/DATAdotPDF/kofterm/labels/good%20first%20issue) and [`help wanted`](https://github.com/DATAdotPDF/kofterm/labels/help%20wanted) issues |
| Make the model smarter | `kofterm contribute --preview` shows what your model learned, anonymized; see [datasets/contrib](datasets/contrib/README.md) |

Full guide: [CONTRIBUTING.md](CONTRIBUTING.md) · [Code of Conduct](CODE_OF_CONDUCT.md)

## What comes next

| Version | What goes in |
| --- | --- |
| **0.7.x** | Fixes from testing 0.7.0 and more networking recipes |
| **0.8.0**, finding things (done) | History search with Ctrl+R, a candidate list when completing files, and the mouse wheel scrolling old output |
| **0.9.0**, for everyone (English done) | English index, screens and recipes (done, `kofterm lang en`); emoji above U+FFFF and a clear warning when the terminal is too narrow come in 0.9.x |
| **1.0.0**, stable | Tested by other people on several distributions and terminals, no limitation that gets in the way, stable file formats |
| **Later** | A small neural model in pure KOF (`kof-nn`) that understands looser requests, always pointing to real recipes |

How versions are numbered and the 1.0 criteria: [CONTRIBUTING, section Versões](CONTRIBUTING.md#7-versões) (in Portuguese). See also the [CHANGELOG](CHANGELOG.md) and the [issues](https://github.com/DATAdotPDF/kofterm/issues).

**Known limitations:** while the wheel is on, selecting text with the mouse needs Shift (or F3 to turn the wheel off); old output keeps the last 2,000 lines; the column needs at least 40 columns left for Bash; emoji above U+FFFF show as `�`.

## Contributors

People who helped build KofTerm, beyond code: tests, recipes, explanations and ideas. Every accepted contribution is listed here and in the [CHANGELOG](CHANGELOG.md).

- **Pedro D. Ferreira** ([@DATAdotPDF](https://github.com/DATAdotPDF)): author and first human tester.
- **Mariana** ([@marianabsctba](https://github.com/marianabsctba)): technical review. Pointed out context-aware danger checks, PTY security tests and keeping secrets out of the history, which now guide the next security release.
- **You?** See [how to help](CONTRIBUTING.md). 💙

## How it was built (process and audit trail)

KofTerm is developed in the open, with every decision on record:

- [docs/HOW_IT_WAS_BUILT.md](docs/HOW_IT_WAS_BUILT.md): phases, architecture, repository map and the end-to-end process.
- [docs/JOURNAL.md](docs/JOURNAL.md): the dated journal, including the human tests and what each one changed.
- [docs/KOF_FINDINGS.md](docs/KOF_FINDINGS.md): findings about the KOF compiler, reported upstream.
- [CHANGELOG.md](CHANGELOG.md): what changed in each version.
- Signed commits and tags; AI assistance (Claude Code) is declared in every commit.

## Credits

- **KOF language:** created by **Mel Santos** ([@melmonfre](https://github.com/melmonfre) · [LinkedIn](https://www.linkedin.com/in/aminadojava/)) and maintained with the KOF contributors in the central repository **[KofLang/Kof4j](https://github.com/KofLang/Kof4j)**, licensed GPL-3.0. Site: [koflang.github.io](https://koflang.github.io).
- **koffuster** by [Luna (@lunalully)](https://github.com/lunalully/koffuster): reference for structuring a KOF terminal tool.
- **tldr-pages** ([tldr-pages/tldr](https://github.com/tldr-pages/tldr)), CC BY 4.0: command examples for the index and the training corpus.
- **SS64** ([ss64.com/bash](https://ss64.com/bash/)): command reference. Its content is not copied into this repository; KofTerm links to it.

Full third-party notices in [NOTICE](NOTICE).

## Authorship

KofTerm was conceived and is developed by **Pedro D. Ferreira** ([@DATAdotPDF](https://github.com/DATAdotPDF)). The project's authorship is recorded in its Git history, in the dated [development journal](docs/JOURNAL.md) and in [AUTHORS.md](AUTHORS.md). AI assistance (Claude Code) is disclosed with a `Co-Authored-By` line in each commit it helped produce.

To cite KofTerm, use [CITATION.cff](CITATION.cff).

## License

GNU General Public License v3.0, the same license as KOF. See [LICENSE](LICENSE).

## Contact

[![Portfolio](https://img.shields.io/badge/Portfolio-111827?style=for-the-badge&logo=cloudflare&logoColor=white)](https://dotpdf.dev)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/data-pdf/)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/DATAdotPDF)
[![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:data.pedutraferreira@gmail.com)

<p align="center">
  From audiovisual storytelling to reliable data and security systems.
</p>
