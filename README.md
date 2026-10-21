<p align="center">
  <img src="docs/images/banner.svg" alt="KofTerm banner: offline AI autocomplete terminal for Linux written in KOF">
</p>

---

<h1 align="center">KOFTERM · OFFLINE AI TERMINAL FOR LINUX</h1>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-GPLv3-blue?style=flat-square" alt="License GPLv3"></a>
  <a href="https://github.com/KofLang/Kof4j"><img src="https://img.shields.io/badge/Built_with-KOF_0.6.6-f59e0b?style=flat-square" alt="Built with KOF 0.6.6"></a>
  <img src="https://img.shields.io/badge/Platform-Linux_x86__64-FCC624?style=flat-square&logo=linux&logoColor=black" alt="Linux x86_64">
  <img src="https://img.shields.io/badge/Network-none-22c55e?style=flat-square" alt="No network">
  <img src="https://img.shields.io/badge/Status-Phase_4_done-8b5cf6?style=flat-square" alt="Phase 4 done">
</p>

<p align="center">
  <a href="README.pt_BR.md">Português</a> ·
  <a href="docs/PLAN.md">Plan</a> ·
  <a href="docs/JOURNAL.md">Dev journal</a> ·
  <a href="spikes/README.md">Phase 0 results</a>
</p>

###

<h3 align="left">ABOUT:</h3>

###

<p align="left">
  KofTerm is a terminal for Linux <b>made for people learning Bash</b>. It brings the VS Code / Gemini style of autocomplete to the shell: while you type, the rest of the line appears in grey, and <b>TAB</b> accepts it.<br><br>
  The suggestion is not just a history lookup. It reads the context of the session: what you already typed, the previous command, whether it failed, the folders you visited. The more you type, the more it learns from you. Type <code>sudo apt update</code> and the next line suggests <code>sudo apt upgrade</code>. A command that fails with <i>Permission denied</i> is offered again with <code>sudo</code>. A typo like <code>gti</code> is offered as <code>git</code>.<br><br>
  Everything runs <b>locally and offline</b>. The model is trained only on Linux commands, on your own machine, and the binary never opens a network socket. If you want to help, you can send what your model learned back to the project through Git, anonymized and reviewed by you first, so every new release ships a smarter model. Nothing personal leaves your machine.<br><br>
  A side panel (<code>F1</code> / <code>Ctrl+K</code>) opens an offline index of the most common ways to use the terminal. Forgot what <code>ls -ld</code> does? Each option is explained on its own, with an example and links for further reading online, without digging through <code>--help</code>.<br><br>
  It is also my first project in <a href="https://koflang.github.io">KOF</a>, a Brazilian programming language. KOF is the heart of the project: the terminal, the AI, the training, the installer and the tests are all KOF. When the language lacks something, the answer is a new KOF library, not another language.
</p>

###

<h3 align="left">CURRENT STATUS:</h3>

###

- **Phase 0 (FFI spikes): done.** Raw keyboard mode, window size and Bash running inside a pseudo-terminal are proven in KOF native on Kali Linux. See [spikes/README.md](spikes/README.md).
- **Phase 1 (passthrough terminal): done.** `kofterm` runs Bash in a pseudo-terminal, passes Bash's exit code through, follows window resizes and restores your terminal even when killed by `SIGTERM` or `SIGHUP`.
- **Phase 2 (line editor and ghost text): done.** At the prompt, KofTerm edits the line itself and shows the rest of a matching command from your history in grey. **TAB** or **→** accepts it, **Ctrl+→** accepts one word, and ↑/↓ browse the history.
- **Phase 3 (offline command index and panel): done.** **F1** or **Ctrl+T** opens a full-screen index tab with search; **F2** splits the screen and keeps a live explanation of what you are typing at the bottom. `ls -ld` shows `-l` and `-d` explained one by one, with examples and reading links.
- **Phase 4 (the context-aware model): done.** The grey suggestion now comes from a local model that learns from every command you run: it uses what you typed, the previous command, the kind of folder you are in and how recent each command is. On an empty line it predicts your next command, offers `sudo` after "Permission denied" and fixes typos after "command not found". It also completes files, folders and options, and never suggests dangerous commands.
- **Phase 5 (contribution, installer, first release): next.**

###

<h3 align="left">LANGUAGES AND TOOLS:</h3>

###

<div align="left">
  <img src="https://raw.githubusercontent.com/KofLang/Kof4j/main/kof.png" height="40" alt="KOF logo" />
  <img width="12" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/linux/linux-original.svg" height="40" alt="Linux logo" />
  <img width="12" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/bash/bash-original.svg" height="40" alt="Bash logo" />
  <img width="12" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/sqlite/sqlite-original.svg" height="40" alt="SQLite logo" />
  <img width="12" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/git/git-original.svg" height="40" alt="Git logo" />
  <img width="12" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/github/github-original.svg" height="40" alt="GitHub logo" />
</div>

###

- **KOF 0.6.6**, native x86_64 target: small ELF binaries (~60 KB), no JVM at runtime
- **libc through KOF `extern`**: `forkpty`, `termios`, `ioctl`, `ppoll`, the only boundary outside KOF
- **SQLite** (KOF `kof.db`) for the offline command index
- **tldr-pages** (CC BY 4.0) and local `man` pages as the documentation and training corpus
- **Kali Linux** on VirtualBox as the test machine
- **Claude Code** as a pair-programming tool for research, planning and the Phase 0 spikes (disclosed in every commit)

###

<h3 align="left">FEATURES:</h3>

| Feature | Status |
| --- | --- |
| Runs Bash inside a pseudo-terminal (colors, Ctrl-C, resize, exit code) | ✅ Phase 1 |
| Terminal restored even if KofTerm is killed (`SIGTERM`, `SIGHUP`) | ✅ Phase 1 |
| Ghost-text suggestion, **TAB** / **→** accepts the line, **Ctrl+→** accepts one word | ✅ Phase 2 |
| Line editing: ←/→, Home/End, Ctrl-A/E/U/K/W, Ctrl-L, ↑/↓ history, UTF-8 (accents) | ✅ Phase 2 |
| Private history in `~/.local/share/kofterm` (folder 0700, files 0600) | ✅ Phase 2 |
| Context-aware suggestions (what you typed, previous command, exit code, kind of folder) | ✅ Phase 4 |
| Empty line predicts your next command (`sudo apt update` → `sudo apt upgrade`) | ✅ Phase 4 |
| Learns from you as you run commands, locally, from the first repetition | ✅ Phase 4 |
| Fixes after errors: `sudo` after "Permission denied", typo after "command not found" | ✅ Phase 4 |
| Completes files, folders (`/etc/hostn` → `ame`) and options (`ls --a` → `ll`) | ✅ Phase 4 |
| Dangerous commands (`rm -rf /`, `mkfs`, `dd of=/dev/sd…`, fork bomb) in red and never suggested | ✅ Phase 4 |
| Full-screen index tab with search (**F1** / **Ctrl+T**), 53 entries in Portuguese | ✅ Phase 3 |
| Split screen with a live explanation of the current line (**F2**, remembered) | ✅ Phase 3 |
| Each option explained on its own (`-ld` → `-l` + `-d`), with examples and reading links | ✅ Phase 3 |
| Opt-in, anonymized contribution of your learning back to the project via Git | Phase 5 |
| Optional tiny neural model, trained and run in pure KOF (`kof-nn`) | Phase 6 |
| One-command install from GitHub | Phase 5 |

###

<h3 align="left">HOW IT WORKS:</h3>

```mermaid
flowchart LR
    K[Keyboard] -->|raw bytes| E[Line editor]
    E -->|current line + context| S[Suggest engine]
    S -->|ghost text| R[Renderer ANSI]
    E -->|Enter| P[PTY master]
    P <--> B[bash]
    P -->|output| R
    B -.->|prompt marker: cwd, exit code| C[Context tracker]
    C --> S
    S --- M[(model.bin)]
    R --- D[(index.db)]
```

KofTerm owns the line you are editing, like the fish shell. When you press Enter, the line is sent to a real Bash running in a pseudo-terminal, and Bash's output is relayed back to your terminal. Suggestions are only text: nothing runs until you press Enter.

###

<h3 align="left">REPOSITORY MAP:</h3>

```text
kofterm/
├── docs/
│   ├── PLAN.md              Full plan: architecture, modules, AI, index, phases
│   ├── JOURNAL.md           Dated development journal (authorship record)
│   └── images/              Banner and screenshots
├── corpus/
│   └── sessions.txt         Starter sequences of commands, so suggestions work on day one
├── index/
│   └── pt_BR.txt            The offline command index, written by the project (see below)
├── spikes/                  Phase 0: one folder per proof, each with main.kf
│   ├── 01_raw_keys/         Raw mode, byte-by-byte keyboard input
│   ├── 02_winsize/          Window size via ioctl(TIOCGWINSZ)
│   └── 03_pty_bash/         Bash inside a PTY with forkpty + ppoll
├── src/                     The terminal itself, all .kf
│   ├── main.kf              Event loop: keyboard, Bash output and signals
│   ├── session.kf           At the prompt: line editing, ghost text, sending to Bash
│   ├── keys.kf              Raw bytes → keys, with tests (future kof-ansi)
│   ├── editor.kf            The line being typed and its cursor, with tests
│   ├── history.kf           History and suggestions, with tests
│   ├── prompt.kf            Finds the invisible prompt marker in Bash's output, with tests
│   ├── index.kf             Index format, search and option splitting (-ld → -l, -d), with tests
│   ├── model.kf             The learning model, safety rules, typo fix, own hash map, with tests
│   ├── brain.kf             Connects the model to the folder, files, options and your events
│   ├── tab.kf               The full-screen index tab (F1 / Ctrl+T)
│   ├── storage.kf           Private files, UTF-8 conversions, KofTerm's bashrc
│   ├── 00_libc.kf           Every libc extern and Linux constant; named to compile first (see journal)
│   ├── tty.kf               Raw mode, restore, window size (future kof-tty)
│   ├── pty.kf               Bash in a pseudo-terminal, exit status (future kof-tty)
│   └── sig.kf               Signals read as data through signalfd (future kof-tty)
├── AUTHORS.md               Author and credits
├── CHANGELOG.md             Versioned changes
├── CITATION.cff             How to cite this project
├── LICENSE                  GNU GPL v3
└── NOTICE                   Third-party credits and licenses
```

###

<h3 align="left">GETTING STARTED:</h3>

**Requirements:** Linux x86_64 with glibc 2.34 or newer (for `forkpty` in `libc.so.6`) and KOF 0.6.6.

**1. Install KOF.** Download `kof-0.6.6-linux-x86_64.tar.gz` and `SHA256SUMS` from the [KOF releases](https://github.com/KofLang/Kof4j/releases), check the hash and extract:

```bash
sha256sum -c SHA256SUMS --ignore-missing
```
```bash
mkdir -p ~/.local/share ~/.local/bin && tar -xzf kof-0.6.6-linux-x86_64.tar.gz -C ~/.local/share && mv ~/.local/share/kof-0.6.6-linux-x86_64 ~/.local/share/kof && ln -sf ~/.local/share/kof/bin/kof ~/.local/bin/kof
```

**2. Clone this repository.**

```bash
git clone https://github.com/DATAdotPDF/kofterm.git && cd kofterm
```

**3. Build and run KofTerm** (Phase 1, passthrough):

```bash
kof build src --target native --output build/kofterm
```
```bash
./build/kofterm/Default/Main
```

You get your Bash inside KofTerm (`echo $KOFTERM` prints `1`). Type `exit` to come back; KofTerm exits with the same code as Bash.

| Key | What it does |
| --- | --- |
| **TAB** or **→** | Accepts the grey suggestion |
| **Ctrl+→** | Accepts one word of the suggestion |
| **↑ / ↓** | Previous / next command |
| **F1** or **Ctrl+T** | Opens the index tab, straight on the command you are typing. Type to search, Enter opens, Esc goes back |
| **F2** | Splits the screen: a live explanation of the current line at the bottom (remembered next time) |
| **Ctrl-L** | Clears the screen and keeps what you were typing |

Run the unit tests (39 tests, one file at a time):

```bash
for f in keys editor history prompt index model; do kof test src/$f.kf --target native; done
```

**4. Optional: run the Phase 0 spikes** (in a real terminal window, not through a pipe):

```bash
cd spikes/02_winsize && kof run main.kf --target=native
```
```bash
cd ../01_raw_keys && kof run main.kf --target=native
```
```bash
cd ../03_pty_bash && kof run main.kf --target=native
```

Spike 01 prints every key you press (`q` quits). Spike 03 opens a Bash inside KofTerm's pseudo-terminal; type `exit` to come back. If a terminal is ever left in a strange state, `reset` fixes it.

###

<h3 align="left">ROADMAP:</h3>

| Phase | Goal | Status |
| --- | --- | --- |
| 0 | FFI spikes: raw mode, window size, PTY | ✅ done (21/10/2026) |
| 1 | Passthrough terminal, signal-safe restore (`signalfd`) | ✅ done (21/10/2026) |
| 2 | Line editor and ghost text from history | ✅ done (21/10/2026) |
| 3 | Offline command index, index tab, live panel, per-option explanations, reading links | ✅ done (21/10/2026) |
| 4 | n-gram model with local continuous learning, context, grammar, safety rules | ✅ done (21/10/2026) |
| 5 | `kofterm contribute` (anonymized, opt-in), installer, CI with "no network" check, first release | next |
| 6 | Optional neural model in pure KOF (`kof-nn`) | planned |

Parallel KOF libraries that will be extracted along the way: `kof-tty` (terminal and PTY), `kof-ansi` (keys and screen), `kof-nn` (tensors and a tiny transformer).

###

<h3 align="left">END-TO-END PROCESS:</h3>

###

**1. Idea.** VS Code with Gemini suggests the rest of a line and TAB accepts it. I wanted the same in the Linux terminal, but local, private and limited to Linux commands, with a cheat sheet always one keystroke away.

**2. Research.** I studied the KOF language site, its standard library and targets, the `training/` corpus of the [KOF central repository](https://github.com/KofLang/Kof4j), and [koffuster](https://github.com/lunalully/koffuster), a terminal tool written in KOF, as a reference for project layout.

**3. Scope decisions.** A full graphical terminal emulator was out of scope for a first project, so KofTerm is a terminal front-end that runs inside any existing terminal. Target: KOF native, the closest thing to a regular Linux binary. AI: an n-gram model first, an optional neural model later. Documentation: tldr-pages and local `man` pages, with SS64 kept as links only because its content is copyrighted.

**4. The KOF-only rule.** The first plan used Python for training and a C helper as a fallback. I rejected that: KOF is the heart of the project, and anything missing becomes a parallel KOF library. That keeps the whole loop auditable and inside one language.

**5. Test machine.** KOF 0.6.6 was installed on a Kali Linux VM from the official release, with the SHA-256 checked. The VM is reached over SSH with a dedicated key.

**6. Phase 0 findings.** All three spikes passed after fixing what the docs did not say. KOF has no file-level constants (they live as `static` fields in a class). `Buffer(U8)` cannot be a function parameter, so memory is handled as raw `Long` pointers from `malloc`. An `extern` named `poll` is silently routed to KOF's own concurrency `poll`, so the terminal uses `ppoll`. Details in [spikes/README.md](spikes/README.md).

**7. Phase 1: a real terminal.** The spike became `src/`, split into modules that will later form the `kof-tty` library. Signals are blocked and read as data through `signalfd` in the same `ppoll` loop, because KOF cannot keep a signal callback. That gives resize on `SIGWINCH` and a restored terminal on `SIGTERM` and `SIGHUP`. Verified on Kali: Bash's exit code passes through (`exit 7` → 7), and no orphan Bash is left behind.

**8. Phase 2: KofTerm owns the line.** Bash starts without its own line editor (`--noediting`), and KofTerm's bashrc loads yours and adds an invisible marker at the end of the prompt with the last exit code and the current folder. When the marker arrives, KofTerm edits the line, draws the grey suggestion and only sends the finished line on Enter; while a command runs, every key goes straight to it. Two more KOF traps showed up: `charAt` returns a character, not a `String`, and a function you write yourself (`writeFile`) can be silently replaced by a KOF built-in of the same name. 19 unit tests now cover the pure modules.

**9. Phase 3: the index.** 53 entries written by the project in Portuguese for people learning Bash, from `ls` to `git commit` and the shell operators (`|`, `>`, `&&`…), with every reading link checked. The tab uses the terminal's alternate screen, so Esc brings back exactly what was there. The live panel splits the screen with a scroll region and tells Bash its screen is shorter; KofTerm now asks the terminal where the cursor is at each prompt and draws by absolute position, which also fixed long lines at the bottom of the screen. A right-hand side panel would need KofTerm to emulate a whole terminal, so the split is top/bottom for now.

**10. Phase 4: the model.** A counting model written in KOF learns from every command when its exit code comes back: how often each line is used, which line usually follows which, in what kind of folder (`git`, `node`, `python`…, never the folder name) and which word usually follows two others. Typos (exit 127) never become suggestions. A starter corpus written by the project gives sensible suggestions on day one. Three new obstacles: KOF's native `Map` crashes at about 3,650 keys (the project now has its own hash map in KOF), an `extern` declared in a file compiled later passes strings wrongly to C (the declarations file is now `00_libc.kf`), and Kali's bashrc rewrites `PROMPT_COMMAND` on the first prompt (KofTerm's hook now reinstalls itself). All KOF findings are written up in [docs/KOF_FINDINGS.md](docs/KOF_FINDINGS.md) for the KOF maintainers.

**11. Learning that comes back.** The model learns from each user locally. Users who want to help can export an anonymized file (paths, hosts, users and numbers become placeholders, and anything that looks like a secret is dropped), review it, and send it as a pull request. CI checks it again and retrains the base model, so each release ships a smarter one. KofTerm itself never touches the network: the user's own Git does the sending.

The full, dated log is in [docs/JOURNAL.md](docs/JOURNAL.md).

###

<h3 align="left">KNOWN LIMITATIONS:</h3>

- **TAB** accepts the suggestion. File and folder completion is part of the suggestion: when several names match, it completes their common start, but there is no list of candidates yet.
- The split screen is top/bottom. A panel on the right would need KofTerm to emulate a full terminal.
- The live panel needs a terminal that answers the cursor-position query (all common ones do). If it does not answer in 300 ms, KofTerm keeps working without the panel.
- The index is in Portuguese only for now, with 53 entries.
- Full-width characters (CJK, some emoji) count as one column.

###

<h3 align="left">CONTRIBUTE TO THE INDEX:</h3>

The easiest way to help is to add or improve entries in [index/pt_BR.txt](index/pt_BR.txt). The format is plain text:

```text
# ls
> Lista os arquivos e pastas de um diretório.
- -l | Formato longo: permissões, dono, grupo, tamanho e data de cada item.
- -a, --all | Mostra também os itens ocultos.
$ ls -la | Tudo, inclusive ocultos, em formato longo.
@ https://ss64.com/bash/ls.html
```

`#` starts a command, `>` is the one-line summary, `-` an option, `$` an example (the explanation goes after the last ` | `), `@` a reading link. Write in your own words for people who are learning; do not copy text from other sites.

###

<h3 align="left">SECURITY AND PRIVACY:</h3>

- No network code: the source never imports `kof.web`, `kof.net` or `http`, and CI will fail if it does
- A `kofterm doctor` check will confirm zero network syscalls with `strace`
- Suggestions never execute anything: only Enter runs a command
- History, the event file the model learns from (exit code, kind of folder, command) and your settings stay in `~/.local/share/kofterm`, readable only by you
- Lines starting with a space are not saved, like in Bash; dangerous commands are not learned
- Contribution is opt-in, shown to you in full before sending, anonymized twice (on your machine and again in CI), and sent by your own Git, never by KofTerm
- Reading links in the side panel are only displayed; KofTerm never opens them
- Dependencies are limited to the KOF standard library and this project's own KOF libraries, with pinned versions

###

<h3 align="left">CREDITS:</h3>

- **KOF language:** created by **Mel Santos** ([@melmonfre](https://github.com/melmonfre) · [LinkedIn](https://www.linkedin.com/in/aminadojava/)) and maintained with the KOF contributors in the central repository **[KofLang/Kof4j](https://github.com/KofLang/Kof4j)**, licensed GPL-3.0. Site: [koflang.github.io](https://koflang.github.io). The KOF logo shown above belongs to the KOF project.
- **koffuster** by [Luna (@lunalully)](https://github.com/lunalully/koffuster): reference for structuring a KOF terminal tool.
- **tldr-pages** ([tldr-pages/tldr](https://github.com/tldr-pages/tldr)), CC BY 4.0: command examples for the index and the training corpus.
- **SS64** ([ss64.com/bash](https://ss64.com/bash/)): command reference. Its content is not copied into this repository; KofTerm links to it.

Full third-party notices in [NOTICE](NOTICE).

###

<h3 align="left">AUTHORSHIP:</h3>

KofTerm was conceived and is developed by **Pedro D. Ferreira** ([@DATAdotPDF](https://github.com/DATAdotPDF)). The project's authorship is recorded in its Git history, in the dated [development journal](docs/JOURNAL.md) and in [AUTHORS.md](AUTHORS.md). AI assistance (Claude Code) is disclosed with a `Co-Authored-By` line in each commit it helped produce.

To cite KofTerm, use [CITATION.cff](CITATION.cff).

###

<h3 align="left">LICENSE:</h3>

GNU General Public License v3.0, the same license as KOF. See [LICENSE](LICENSE).

## Connect

[![Portfolio](https://img.shields.io/badge/Portfolio-111827?style=for-the-badge&logo=cloudflare&logoColor=white)](https://portfolio-data-cybersecurity.data-pedutraferreira.workers.dev)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/data-pdf/)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/DATAdotPDF)
[![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:data.pedutraferreira@gmail.com)

<p align="center">
  From audiovisual storytelling to reliable data and security systems.
</p>
