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
  <a href="https://github.com/DATAdotPDF/kofterm/releases"><img src="https://img.shields.io/badge/Release-v0.6.5-8b5cf6?style=flat-square" alt="Release v0.6.5"></a>
  <a href="https://github.com/DATAdotPDF/kofterm/actions/workflows/ci.yml"><img src="https://github.com/DATAdotPDF/kofterm/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
</p>

<p align="center">
  <a href="README.pt_BR.md">Português</a> ·
  <a href="docs/PLAN.md">Plan</a> ·
  <a href="docs/JOURNAL.md">Dev journal</a> ·
  <a href="https://datadotpdf.github.io/kofterm/">Website</a> ·
  <a href="CONTRIBUTING.md">How to contribute</a> ·
  <a href="spikes/README.md">Phase 0 results</a>
</p>

###

<h3 align="left">ABOUT:</h3>

###

<p align="left">
  KofTerm is a terminal for Linux <b>made for people learning Bash</b>. It brings the VS Code / Gemini style of autocomplete to the shell: while you type, the rest of the line appears in grey, and <b>TAB</b> accepts it.<br><br>
  The suggestion is not just a history lookup. It reads the context of the session: what you already typed, the previous command, whether it failed, the folders you visited. The more you type, the more it learns from you. Type <code>sudo apt update</code> and the next line suggests <code>sudo apt upgrade</code>. A command that fails with <i>Permission denied</i> is offered again with <code>sudo</code>. A typo like <code>gti</code> is offered as <code>git</code>.<br><br>
  Everything runs <b>locally and offline</b>. The model is trained only on Linux commands, on your own machine, and the binary never opens a network socket. If you want to help, you can send what your model learned back to the project through Git, anonymized and reviewed by you first, so every new release ships a smarter model. Nothing personal leaves your machine.<br><br>
  An index column on the right of the screen (<code>F2</code>) explains, live, the command you are typing, without ever covering your terminal; a full-screen index search is one key away (<code>F1</code>). And you can ask in plain Portuguese: <code>? instalar o htop</code> suggests <code>sudo apt update &amp;&amp; sudo apt install -y htop</code>. Forgot what <code>ls -ld</code> does? Each option is explained on its own, with an example and links for further reading online, without digging through <code>--help</code>.<br><br>
  It is also my first project in <a href="https://koflang.github.io">KOF</a>, a Brazilian programming language. KOF is the heart of the project: the terminal, the AI, the training, the installer and the tests are all KOF. When the language lacks something, the answer is a new KOF library, not another language.
</p>

###

<h3 align="left">HOW TO HELP:</h3>

###

<p align="left">
  KofTerm is <b>open source</b> and built to <b>add up</b>: every recipe, explanation or test helps someone else learn. <b>You don't need to know KOF</b> to start: the most valuable contributions are plain-language text.
</p>

| I want to... | Start with |
| --- | --- |
| Teach the `?` mode a new request | [New recipe](CONTRIBUTING.md#receita-nova-o-caminho-mais-rápido-para-o-seu-primeiro-pr) in `recipes/pt_BR.txt` |
| Explain a command better | [Index entry](CONTRIBUTING.md#entrada-no-índice) in `index/pt_BR.txt` |
| Test it and report back | [Test script](docs/TESTE_HUMANO.md) and an [issue](https://github.com/DATAdotPDF/kofterm/issues/new/choose) |
| Write KOF code | [`good first issue`](https://github.com/DATAdotPDF/kofterm/labels/good%20first%20issue) and [`help wanted`](https://github.com/DATAdotPDF/kofterm/labels/help%20wanted) issues |

Full guide: [CONTRIBUTING.md](CONTRIBUTING.md) · [Code of Conduct](CODE_OF_CONDUCT.md) · [Security](SECURITY.md)

###

<h3 align="left">CURRENT STATUS:</h3>

###

- **Phase 0 (FFI spikes): done.** Raw keyboard mode, window size and Bash running inside a pseudo-terminal are proven in KOF native on Kali Linux. See [spikes/README.md](spikes/README.md).
- **Phase 1 (passthrough terminal): done.** `kofterm` runs Bash in a pseudo-terminal, passes Bash's exit code through, follows window resizes and restores your terminal even when killed by `SIGTERM` or `SIGHUP`.
- **Phase 2 (line editor and ghost text): done.** At the prompt, KofTerm edits the line itself and shows the rest of a matching command from your history in grey. **TAB** or **→** accepts it, **Ctrl+→** accepts one word, and ↑/↓ browse the history.
- **Phase 3 (offline command index and panel): done.** **F1** or **Ctrl+T** opens a full-screen index tab with search; **F2** splits the screen and keeps a live explanation of what you are typing at the bottom. `ls -ld` shows `-l` and `-d` explained one by one, with examples and reading links.
- **Phase 4 (the context-aware model): done.** The grey suggestion now comes from a local model that learns from every command you run: it uses what you typed, the previous command, the kind of folder you are in and how recent each command is. On an empty line it predicts your next command, offers `sudo` after "Permission denied" and fixes typos after "command not found". It also completes files, folders and options, and never suggests dangerous commands.
- **Phase 5 (contribution, installer, first release): done.** `kofterm contribute` exports what your model learned, anonymized on your machine, for you to review and send by pull request; CI validates every contribution and the next release learns from it. One-command install from the release or from the source. **First release: v0.5.0.**
- **Phase 6 (KofTerm draws its own screen): done.** A terminal emulator written in KOF (`vt.kf`) interprets everything Bash and programs write, so the index lives in a **column on the right** that programs never touch: Bash, `vim`, `top` and `less` see only the left area. Works inside any Linux terminal.
- **Phase 7 (human mode): done.** Type `?` and what you want to do, in your own words. KofTerm finds the closest of 124 recipes (357 ways of asking) written by people, fills in the gaps and shows the command in grey; TAB puts it on the line, nothing runs by itself, and the side column explains each part.
- **Next:** your feedback as the first human tester, more recipes and index entries, an English index, candidate list for file completion, optional neural model in pure KOF (`kof-nn`).

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
| Full-screen index tab with search (**F1** / **Ctrl+T**), 148 entries in Portuguese (commands, networking, users, services and important paths) | ✅ Phase 3 |
| Index **column on the right** with a live explanation of the current line (**F2**, remembered) | ✅ Phase 6 |
| Own terminal emulator: Bash and full-screen programs never write over the index | ✅ Phase 6 |
| Human mode: `? what you want` → a real command from 124 reviewed recipes | ✅ Phase 7 |
| Each option explained on its own (`-ld` → `-l` + `-d`), with examples and reading links | ✅ Phase 3 |
| Opt-in, anonymized contribution of your learning back to the project via Git | ✅ Phase 5 |
| Optional tiny neural model, trained and run in pure KOF (`kof-nn`) | Phase 6 |
| One-command install from the release or the source; `doctor` and `uninstall` | ✅ Phase 5 |

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
├── .github/workflows/ci.yml Tests, native build, "no network" check, contribution validation
├── corpus/
│   ├── sessions.txt         Starter sequences of commands, so suggestions work on day one
│   └── commands.txt         Public list of command names (the anonymizer keeps only these)
├── datasets/contrib/        Anonymized contributions from the community (.kofdata)
├── recipes/
│   └── pt_BR.txt            Human-mode recipes: ways to ask → command (see below)
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
│   ├── vt.kf                Terminal emulator (xterm subset), with tests (future kof-ansi)
│   ├── recipes.kf           Human mode: matches what you ask to a recipe, with tests
│   ├── index.kf             Index format, search and option splitting (-ld → -l, -d), with tests
│   ├── model.kf             The learning model, safety rules, typo fix, own hash map, with tests
│   ├── brain.kf             Connects the model to the folder, files, options and your events
│   ├── anon.kf              Anonymizer and validator for contributions, with tests
│   ├── cli.kf               Subcommands: contribute, check, install, uninstall, doctor
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
├── NOTICE                   Third-party credits and licenses
└── install.sh               Bootstrap: gets KOF if missing (SHA-256 pinned), builds, runs kofterm install
```

###

<h3 align="left">GETTING STARTED:</h3>

**Requirements:** Linux x86_64 with glibc 2.34 or newer (Ubuntu 22.04+, Debian 12+, Fedora 35+, Kali). The binary depends only on the system's `libc`.

**Option A: ready-made release (no KOF needed).** Download `kofterm-0.6.5-linux-x86_64.tar.gz` and `SHA256SUMS` from the [releases page](https://github.com/DATAdotPDF/kofterm/releases), then:

```bash
sha256sum -c SHA256SUMS --ignore-missing
```
```bash
tar -xzf kofterm-0.6.5-linux-x86_64.tar.gz && ./kofterm-0.6.5-linux-x86_64/kofterm install
```

**Option B: from the source.** `install.sh` compiles KofTerm with KOF 0.6.6. If KOF is missing, it asks before downloading the official release (about 370 MB) and checks its SHA-256, which is pinned in the script.

```bash
git clone https://github.com/DATAdotPDF/kofterm.git && cd kofterm && ./install.sh
```

Both install to `~/.local/share/kofterm` and create the `kofterm` command in `~/.local/bin`. Then open it:

```bash
kofterm
```

You get your Bash inside KofTerm (`echo $KOFTERM` prints `1`). Type `exit` to come back; KofTerm exits with the same code as Bash.

| Command | What it does |
| --- | --- |
| `kofterm` | Opens the terminal |
| `kofterm contribute --preview` | Shows what would be shared with the project. Nothing is written |
| `kofterm contribute` | Writes `kofterm-contrib.kofdata` in the current folder, for you to review and send |
| `kofterm check FILE...` | Validates `.kofdata` files (used by CI) |
| `kofterm doctor` | Checks the installation and shows where your data is |
| `kofterm uninstall` | Removes the program and keeps your history; `--purge` removes everything |

To open KofTerm automatically in every new terminal, add this to the end of `~/.bashrc` (the `KOFTERM` check stops KofTerm from opening inside itself):

```bash
[ -z "$KOFTERM" ] && command -v kofterm >/dev/null && exec kofterm
```

| Key | What it does |
| --- | --- |
| **TAB** or **→** | Accepts the grey suggestion |
| **Ctrl+→** | Accepts one word of the suggestion |
| **↑ / ↓** | Previous / next command |
| **F2** | Shows or hides the index column on the right, explaining the current line live (remembered next time) |
| **F1** or **Ctrl+T** | Opens the full-screen index search, straight on the command you are typing. Type to search, Enter opens, Esc goes back |
| **?** + what you want | Human mode: `? quanto espaço sobrou` suggests `df -h`. **TAB** or **Enter** puts the command on the line; Enter again runs it |
| **Ctrl-L** | Clears the screen and keeps what you were typing |

**For developers.** Build and run from the repository without installing, and run the unit tests (75 tests, one file at a time):

```bash
kof build src --target native --output build/kofterm && ./build/kofterm/Default/Main
```
```bash
for f in keys editor history prompt index model anon vt recipes; do kof test src/$f.kf --target native; done
```

Optional, the Phase 0 spikes (in a real terminal window, not through a pipe):

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
| 5 | `kofterm contribute` (anonymized, opt-in), installer, CI with "no network" check, first release | ✅ done (21/10/2026), v0.5.0 |
| 6 | Own terminal emulator, index column on the right | ✅ done (21/10/2026) |
| 7 | Human mode with recipes | ✅ done (21/10/2026), v0.6.0 |
| 8 | Optional neural model in pure KOF (`kof-nn`) that understands looser requests, always pointing to real recipes | planned |

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

**11. Phase 5: learning that comes back, and the first release.** `kofterm contribute` turns your event file into aggregated, anonymized patterns: only command names from a public list, options and shell operators pass as they are; paths, files, hosts, IPs, users, numbers and quoted text become placeholders; an unknown program name becomes `<CMD>`; and any line that looks like a secret is dropped whole. Only patterns seen at least 3 times are kept, with no dates or session order. Tested against a fake history full of client names, an internal domain, a private IP, a GitHub token, a MySQL password and a Bearer header: none of it survived. The same rules validate every `.kofdata` in CI, and KofTerm loads `datasets/contrib/` at startup, so each release learns from the community. The installer is a short Bash bootstrap; everything else (`install`, `uninstall`, `doctor`) is KofTerm itself, in KOF.

**12. Phase 6: KofTerm draws its own screen.** The first human test made one thing clear: an index that pushes the terminal around gets in the way. So KofTerm now works like `tmux`: a terminal emulator written in KOF from the public xterm/ECMA-48 behavior (text, UTF-8, colors up to RGB, scroll regions, alternate screen, line drawing) keeps the screen in memory, and KofTerm draws it with the index in a column on the right. Bash and every program get a narrower window and never touch the column. The first version leaked memory with `top` running (8 → 35 MB in a minute) because KOF 0.6.6's native collector reclaims only part of temporary strings; drawing now goes straight into a C buffer with `stpcpy`, the parser reads numbers instead of building strings, and rows are reused on scroll: CPU fell about 18 times and the growth to a slow trickle.

**13. Phase 7: human mode.** `? instalar o htop` searches 63 recipes written by people (164 ways of asking), tolerant to accents and one-letter typos, and fills the gaps with the words of the request. It is retrieval, not generation: KofTerm never invents a command, words from the request never carry shell characters into it, dangerous results are dropped, and the command only runs after the person reads it and presses Enter again.

**14. Root and network studies (0.6.2).** The third human test found that the index did not say what `sudo` does, and that KofTerm stopped working after `sudo -i`, because the root shell did not load its hook. Now the column explains every part of the line, including the `sudo` prefix and file paths such as `/etc/shadow`, and `sudo -i`, `sudo -s`, `sudo su` and a plain `bash` open the inner shell with KofTerm's hook. The index grew to 148 entries and the recipes to 122, aimed at people studying Linux, networking and security in their own labs: routes, DNS, ports, packet capture, firewall, SSH keys, users, logs, hashes and the important paths of the system, all checked against a Kali VM.

**15. What is missing, KofTerm points to (0.6.3 and 0.6.4).** As root, recipes drop `sudo` and stop offering `sudo -i`. When a program is not installed, the column says so while you type and shows "to download what is missing, use » `sudo apt install x`"; after "command not found" the empty line already holds that command. The package comes from the index or from what the system itself said, and a one-letter typo of a known command (`gti`, `sl`) is still fixed instead of installing a joke package. KofTerm never installs anything by itself: what is missing inside KOF becomes a parallel KOF project, and system tools are installed by the person, with KofTerm explaining how.

The full, dated log is in [docs/JOURNAL.md](docs/JOURNAL.md); KOF findings are in [docs/KOF_FINDINGS.md](docs/KOF_FINDINGS.md).

<h3 align="left">CONTRIBUTE YOUR LEARNING:</h3>

```bash
kofterm contribute --preview
```

Shows exactly what would be shared, for example:

```text
L 4 git push origin main
T 4 git status => git add .
L 4 scp <FILE> <USER>@<IP>:<PATH>
```

If you agree, `kofterm contribute` writes `kofterm-contrib.kofdata`. Copy it to `datasets/contrib/<a-nickname>.kofdata` in your fork and open a pull request. Details in [datasets/contrib/README.md](datasets/contrib/README.md).

###

<h3 align="left">KNOWN LIMITATIONS:</h3>

- **TAB** accepts the suggestion. File and folder completion is part of the suggestion: when several names match, it completes their common start, but there is no list of candidates yet.
- KofTerm uses the alternate screen of your terminal, like `tmux`: the mouse wheel does not scroll back through old output inside KofTerm yet, and when you exit, your previous screen comes back.
- The index column needs at least 40 columns left for Bash; on a narrow window F2 beeps and keeps it hidden.
- Full-width characters (CJK, some emoji) count as one column; emoji above U+FFFF show as `�`.
- Performance is measured, not assumed: with `top` redrawing 5 times a second and the index column on, KofTerm stayed at 7.9 MB for 6 minutes and used 0.2% CPU. Getting there meant working around how KOF 0.6.6 native handles temporary strings (see [docs/JOURNAL.md](docs/JOURNAL.md)).
- The index is in Portuguese only for now, with 148 entries.
- Full-width characters (CJK, some emoji) count as one column.

###

<h3 align="left">CONTRIBUTE RECIPES:</h3>

Teach KofTerm a new "I want to do X" in [recipes/pt_BR.txt](recipes/pt_BR.txt):

```text
# compactar pasta
? compactar pasta {pasta}
? zipar pasta {pasta}
$ tar -czvf {pasta}.tar.gz {pasta}
> Junta e compacta {pasta} em {pasta}.tar.gz.
```

`#` names the recipe, each `?` is one way people ask (in their own words), `{name}` is a gap filled with the words of the request, `$` is the command and `>` the explanation for learners. An optional `%` line is the command for someone who is already root (`% -` hides the recipe for root); without it, root gets the command without `sudo`. Commands that delete must ask first (`rm -i`). Words from the request never bring shell characters (`;`, `|`, `$`…) into the command.

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

`#` starts a command, `>` is the one-line summary, `-` an option, `$` an example (the explanation goes after the last ` | `), `@` a reading link, and `!` the apt package that provides the program when its name is different (`dig` comes from `bind9-dnsutils`). Write in your own words for people who are learning; do not copy text from other sites.

###

<h3 align="left">SECURITY AND PRIVACY:</h3>

- No network code: the source never imports `kof.web`, `kof.net` or `http` nor declares socket functions, and CI fails if it does
- `kofterm doctor` shows how to confirm it yourself with `strace -f -e trace=network kofterm`
- The installer pins KOF's SHA-256; the release ships `SHA256SUMS`; every commit and tag is signed
- Suggestions never execute anything: only Enter runs a command
- History, the event file the model learns from (exit code, kind of folder, command) and your settings stay in `~/.local/share/kofterm`, readable only by you
- Lines starting with a space are not saved, like in Bash; dangerous commands are not learned
- Contribution is opt-in, shown to you in full before sending, anonymized twice (on your machine and again in CI), and sent by your own Git, never by KofTerm
- Reading links in the side panel are only displayed; KofTerm never opens them
- Dependencies are limited to the KOF standard library and this project's own KOF libraries, with pinned versions

###

<h3 align="left">CONTRIBUTORS:</h3>

###

People who helped build KofTerm, beyond code: tests, recipes, explanations and ideas. Every accepted contribution is listed here and in the [CHANGELOG](CHANGELOG.md).

- **Pedro D. Ferreira** ([@DATAdotPDF](https://github.com/DATAdotPDF)): author and first human tester.
- **You?** See [how to help](CONTRIBUTING.md). 💙

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

[![Portfolio](https://img.shields.io/badge/Portfolio-111827?style=for-the-badge&logo=cloudflare&logoColor=white)](https://dotpdf.dev)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/data-pdf/)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/DATAdotPDF)
[![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:data.pedutraferreira@gmail.com)

<p align="center">
  From audiovisual storytelling to reliable data and security systems.
</p>
