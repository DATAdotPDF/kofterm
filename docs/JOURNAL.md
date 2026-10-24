# Development journal

A dated record of how KofTerm was conceived and built. It complements the Git history as a record of authorship. Times are local (UTC−3). Where a time is given, it comes from a log or a file timestamp on the test machine.

---

## 21/10/2026: Day 1, from idea to Phase 0

### Idea and requirements (morning)
- Goal set by Pedro: a Linux terminal, written from scratch in KOF, with VS Code / Gemini style autocomplete (ghost text + TAB), context from previous lines, a split side panel with an offline command index, 100% local and with no network.
- References given: the KOF site, the SS64 Bash reference, and `lunalully/koffuster` as an example KOF terminal tool.

### Research
- Read the KOF site (language, standard library, targets, download), and the `training/` corpus and compiler tests in `KofLang/Kof4j`.
- Key facts: KOF native generates ELF directly; `extern` binds libc; the standard library has no termios, raw input or process stdin, so the terminal must use FFI.
- Confirmed the `strdup(String): Long` + `buffer.peek/poke` pattern in the compiler's own tests (`BufferPeekE2ETest`).

### Decisions (Pedro)
- Scope: a terminal front-end that runs inside any terminal, not a graphical emulator.
- Target: KOF native x86_64.
- AI: n-gram first, optional neural model later.
- Index: tldr-pages + local `man`. SS64 content is copyrighted, so only links and command names are kept, and permission will be requested from its maintainer.
- **KOF-only rule:** the first plan used Python for training and a C helper; Pedro rejected both. Everything is KOF; missing pieces become parallel KOF libraries (`kof-tty`, `kof-ansi`, `kof-nn`).
- Plan approved: [PLAN.md](PLAN.md).

### Test machine setup (afternoon)
- VirtualBox VM "Kali-Estudos" (Kali Linux, glibc 2.43), reached through a NAT forward on port 2222.
- ~14:35–14:45: SSH key login kept failing. Diagnosis showed the server accepted the key but the client key had a passphrase. Fixed with a dedicated VM-only key.
- VirtualBox Guest Additions (`virtualbox-guest-x11`) installed so the clipboard works between Windows and the VM.
- 15:16–15:17: downloaded `kof-0.6.6-linux-x86_64.tar.gz` (388 MB) from the official release; SHA-256 `96dd0d80…772296f6` checked against `SHA256SUMS`: OK. Installed to `~/.local/share/kof`.

### Phase 0: FFI spikes
- First compile: `val` constants at file level are `PARSE007`. Moved to `static` fields in a class.
- `Buffer(U8)` is accepted only inside `extern`; as a function parameter it is `SEM011`. Switched to raw memory: `malloc`/`free` returning `Long`, with `buffer.peek/poke` on addresses. Verified with a small native program: `write` printed through a raw pointer, `ioctl` read the window size.
- `kof run` compiles every `.kf` in the folder, so each spike moved to its own folder.
- 15:51: all three spikes built as native ELF (~60 KB each).
- Spike 02: read 40×120 and 24×80 correctly.
- Spike 01: `a` → 97, Up arrow → `27 91 65`, `q` quits, terminal restored.
- Spike 03 hung. Step-by-step markers found two causes:
  1. Tests ran under `timeout`, which puts the program in a background process group; `tcsetattr` then stops it with SIGTTOU. Use `timeout --foreground`.
  2. `extern poll` is silently routed to KOF's built-in concurrency `poll`, which returns `null`. Switched to `ppoll`. To be reported upstream to KofLang/Kof4j.
- Spike 03 after the fix: Bash ran in `/dev/pts/2`, `stty size` = `30 100`, Ctrl-C interrupted `sleep 30` (exit 130), `exit` returned cleanly, and the terminal was restored (`opost icanon echo`).
- Open item for Phase 1: if KofTerm is killed by a signal, `finally` does not run and the terminal stays raw. Plan: `signalfd` read in the same `ppoll` loop (signal callbacks are `FFI001` in KOF).

### Repository
- Project folder created at `D:\VSCODE_PROJECTS\kofterm`, Git initialized, README in English and Portuguese, authorship and credit files added.

- Repository published at github.com/DATAdotPDF/kofterm. Commit signing set up with Pedro's SSH key through the Windows ssh-agent; the first 4 commits were re-signed with their original dates and the history was force-pushed (approved by Pedro). All commits and the `v0.0.1` tag show "Verified".

### Phase 1: passthrough terminal (evening)
- Checked first: KOF native builds several `.kf` files in one folder together (default package), and `sigemptyset`, `sigaddset`, `sigprocmask`, `signalfd`, `kill`, `close` do not collide with KOF built-ins. A small program blocked `SIGTERM`, sent it to itself and read it from a `signalfd` (`ssi_signo=15`), and kept running.
- 16:37: `src/` built on the first try (68 KB): `libc.kf` (every extern), `tty.kf`, `pty.kf`, `sig.kf` (future `kof-tty`), `main.kf` (event loop over stdin, the PTY master and the signalfd).
- Child process clears the inherited signal mask before `exec`, otherwise Bash would start with Ctrl-C blocked. It also gets `KOFTERM=1` in its environment.
- Tests on Kali, driven over `ssh -tt`:
  - Normal session: `KOFTERM=1`, Ctrl-C → 130, `exit 7` → KofTerm exits 7, terminal restored.
  - Resize: `stty size` went from `30 100` to `50 150` on `SIGWINCH`.
  - `SIGTERM` from outside: exit 143, terminal restored, no orphan Bash.
  - `SIGHUP` (window closed): exit 129, terminal restored, no orphan Bash.
- A test mistake worth remembering: `pkill -f <path>` also matched the test's own shell command line. Use `pkill -x Main`.

### Vision update from Pedro
- Audience: people learning Bash.
- The model learns continuously from the user, locally; folder context enters as features, never as paths.
- Opt-in contribution: `kofterm contribute` exports an anonymized, aggregated file that the user reviews and sends by pull request with their own Git. CI re-validates it and retrains the base model, so each release ships a smarter model. KofTerm keeps zero network code.
- Side panel explains each option separately (`-ld` → `-l` + `-d`) and shows reading links (ss64, man7.org, GNU Bash Manual, tldr) that KofTerm never opens itself.

### Phase 2: line editor and ghost text (night)
- Design decision: KofTerm owns the line, like fish. Bash starts with `--noediting --rcfile <kofterm bashrc> -i`. The bashrc loads `~/.bashrc`, captures `$?` first in `PROMPT_COMMAND` (string or array form) and appends an invisible marker `ESC ] 7770 ; status ; $PWD BEL` to the end of `PS1`. Without readline, `\[ \]` is not needed, which matters because KOF string literals cannot produce a backslash (`"\\"` gives nothing).
- Probed first: `List<String>`, `String.startsWith/substring/length` (UTF-8 aware: `"a€b".length()` = 3), classes with mutable fields and methods, `"\u001b"` for ESC, and `getenv`, `strndup` (returns `String`), `strlen`, `open`, `mkdir`, `lseek`, `chmod` as externs.
- Testing: `kof test` compiles one file at a time, and `package` + `--module-root` works for tests but breaks the native build (`PKG004`). Choice: pure modules are self-contained with their tests in the same file (`keys`, `editor`, `history`, `prompt`); `kof test src/<file>.kf` runs them. 19 tests pass.
- `charAt` returns a character, not a `String`, so `charAt(i) == " "` is always false. Using `substring(i, i + 1)`.
- 16:50: first Phase 2 build, 117 KB. Verified on Kali over `ssh -tt`:
  - typing `e` shows `cho kofterm_ghost_ok` in grey; TAB accepts; Enter runs it;
  - `false` then `echo st=$?` → `st=1` (exit code survives the marker);
  - ↑ recalls the previous command; `read -p` and a `sudo` password prompt work in passthrough (password not typed; Ctrl-C cancels);
  - `echo ação ok` (UTF-8), Ctrl+→ accepts one word at a time, Ctrl-W, Ctrl-A, Ctrl-L keeps the draft.
- **New KOF trap:** the bashrc came out `644` instead of `600`. My own function `writeFile` was being replaced in silence by a KOF built-in of the same name. Renamed to `saveFile` (and `readLines` to `loadLines` to be safe), and added `chmod` so the folder is always `0700` and files `0600`, even if they existed before. To be reported to KofLang/Kof4j together with the `poll` case.

### Phase 3: offline index, tab and live panel (night)
- Scope split in two commits: 3a (index + full-screen tab) and 3b (live split screen). A right-hand panel was ruled out: most terminals have no column margins, so it would need a full terminal emulator inside KofTerm. Top/bottom split works everywhere.
- Index format: a plain text file, `index/pt_BR.txt`, editable by anyone (`#` command, `>` summary, `-` option, `$` example, `@` link). 53 entries written by the project in Portuguese for Bash learners. All 53 reading links were checked over HTTP; one SS64 page that does not exist (`clear`) was swapped for man7.
- `index.kf` (pure, 9 tests): parser, search by name then summary, the entry for a line (skips `sudo`, takes the last command after `|`/`&&`/`;`, tries `git commit` before `git`) and option splitting (`-ld` → `-l`, `-d`, while `find -name` stays whole). Example commands can contain a pipe, so the explanation is taken after the **last** ` | `.
- KOF's null safety showed up: an `Entry?` must be checked before use (`SEM049`); helpers `must()` and `nameOf()` keep that short.
- A lone Esc used to wait forever for the rest of a sequence; now an ESC at the end of a read is the Esc key. F1, F2, Ctrl+T, PgUp/PgDn and the cursor-position reply were added to the decoder (8 tests).
- 17:03 (3a): the tab opens on the alternate screen straight on the command being typed and shows "NA SUA LINHA" with `-l` and `-d` for `ls -ld /etc`; search "apag" finds `rm`, `>`, `>>`; Esc returns to the exact previous screen and the line runs. Screens checked by running KofTerm inside `tmux` and reading `capture-pane`.
- 3b: at each prompt KofTerm asks `ESC[6n` and draws by absolute position; if no reply in 300 ms it falls back to the Phase 2 mode. F2 sets a scroll region above a panel of up to 10 rows, tells Bash its screen is shorter, and remembers the choice in `~/.local/share/kofterm/panel`.
- Verified in tmux (100×30): panel stays fixed while `seq 1 40` scrolls above it; Bash sees `20 100`; `vim` uses exactly 20 rows and the panel is intact after quitting it (the region is reapplied at every prompt); F2 off returns `30 100`; exiting KofTerm with the panel on gives the outer shell its full screen back.
- Bug found and fixed in the same session: for a long line at the bottom, the start row was moved up before writing, overwriting the prompt. The terminal scrolls while writing, so the coordinates must move after. This also fixed the Phase 2 long-line limitation.
- 30 unit tests pass (keys 8, editor 5, history 4, prompt 4, index 9).

### Phase 4: context-aware model and local learning (night)
- Design: suggestions in priority order — on an empty line, a fix after an error (`sudo …` after a permission error, the closest known command after exit 127) or the command that usually follows the previous one; while typing, the best full line, then the next word, options from the index, subcommands and files/folders.
- Probed first: `Map` (`put`, `get` returning `V?`, `containsKey`, `keys`), `opendir`/`readdir` (`d_type` at +18, `d_name` at +19), `String.hashCode()`.
- `model.kf` (pure, 9 tests): line counts, transitions between lines, folder features per command, word n-grams, recency, dangerous-command rules, Levenshtein typo fix.
- First full build crashed at startup (exit 139). Bisected with markers to the corpus load, then isolated: KOF native's `Map<String, Int>` crashes at about 3,650 keys (works on JVM; `List` with 20,000 items is fine). Wrote `KtIntMap`/`KtTextMap` in KOF (buckets of lists + `hashCode`), tested with 20,000 keys.
- Folder features and file completion silently failed. Isolated step by step: `access` returned -1 (ENOENT) even for a literal path inside `brain.kf`, but 0 from `main.kf` in the same run. Cause: files compile in alphabetical order, and an `extern` declared in a later file (`libc.kf`) passes strings wrongly in earlier files (`brain.kf`). Renamed to `src/00_libc.kf`.
- Exit codes were always 0: Kali's `~/.bashrc` sets `PROMPT_COMMAND="PROMPT_COMMAND=echo"`, which overwrites itself on the first prompt and removed KofTerm's hook. The hook now reinstalls itself at every prompt.
- Typos (exit 127) are recorded but never learned.
- Verified in tmux in a git repo: corpus completes `sudo apt up` → `date`; after `git status` the empty line suggests the next git step; `grpe root /etc/hostname` → `grep root /etc/hostname`; `cat /etc/shadow` → `sudo cat /etc/shadow`; `/etc/hostn` → `ame`, `/us` → `r/`, `.gi` → `t/`; `ls --a` → `ll`; `git commit ` → `-m ""`; after two repetitions of a pair of commands the empty line predicts the second one; `rm -rf /` shows in red with no suggestion; events file is `0600` with features like `git`, never folder names.
- 39 unit tests pass. All KOF findings collected in `docs/KOF_FINDINGS.md`.

### Phase 5: anonymized contribution, installer and first release (night)
- `anon.kf` (pure, 8 tests): a quote-aware tokenizer; only command names from a public list (`corpus/commands.txt`, plus index and corpus words), options and shell operators pass; everything else becomes `<PATH>`, `<FILE>`, `<URL>`, `<IP>`, `<HOST>`, `<USER>`, `<NUM>`, `<STR>`, `<ARG>`, `<VAL>`, and an unknown program becomes `<CMD>`. Secret-looking lines (password, token, `export X=`, `curl -u user:pass`, `mysql -p…`, long letter+digit strings) are dropped whole. `ContribBuilder` keeps only patterns seen at least 3 times, without dates or order. The same rules validate files (`kofterm check`).
- Subcommands in `cli.kf`; arguments come from `/proc/self/cmdline` (KOF has no documented argv).
- Privacy test: a fake history of 48 events with a client name ("Acme"), an internal domain, a private IP, a GitHub token, a MySQL password, a Bearer header and a company deploy script. The preview had 17 lines like `scp <FILE> <USER>@<IP>:<PATH>` and `<PATH> <ARG>`; a search for acme, pedro, the IP, ghp_, senha, bearer, cliente returned nothing. The generated file passed `kofterm check`; a tampered copy failed on 3 lines (raw path, unknown program, invented feature).
- Contributions in `datasets/contrib/*.kofdata` are loaded at startup (weight capped at 5); the ghost stops before the first placeholder (`sc` → `scp `).
- `install.sh` (only Bash file, pins KOF's SHA-256, asks before downloading) builds and runs `kofterm install`, which copies the binary, index and corpus to `~/.local/share/kofterm` and links `~/.local/bin/kofterm`. Tested from a clean `HOME`: install, `doctor` from the installed binary, terminal with F1, `uninstall` keeping history and events, `uninstall --purge` removing everything.
- The binary only needs `libc.so.6` (GLIBC 2.34+).
- CI (`.github/workflows/ci.yml`): official KOF with pinned SHA-256, "no network code" grep over `src/`, the 47 unit tests, native build, contribution validation, smoke test.
- 47 unit tests pass.

### Release and upstream reports
- v0.5.0 published: CI green on `main` and on the signed tag (47 tests on GitHub's Ubuntu 24.04); release tarball (119 KB) and `SHA256SUMS`; tested as an end user from a clean `HOME` with no KOF installed.
- The four KOF findings were reported to the KOF central repository after checking for duplicates (issues and `known-bugs.md`), re-running each reproduction on 0.6.6 and following its bug template, in Portuguese like its recent issues: [Kof4j#931](https://github.com/KofLang/Kof4j/issues/931) (`extern` named like a builtin), [#932](https://github.com/KofLang/Kof4j/issues/932) (user function shadowed by a builtin), [#933](https://github.com/KofLang/Kof4j/issues/933) (native `Map` crash), [#934](https://github.com/KofLang/Kof4j/issues/934) (`extern` and file order). Kof4j's bot triaged the labels.

### First human test (Pedro, QTerminal on Kali)
- Clone + `./install.sh` from GitHub worked; KofTerm opened in the right prompt. An `@sS@sS` on the screen turned out to be a typo, confirmed by recording the session with `script -I/-O`: QTerminal answers the cursor-position query (`ESC[8;5R`) like tmux and KofTerm handled it.
- Feedback that changed the plan: the index has to sit **beside** the terminal without interfering with it. And a request for a human mode ("I want to do X" → command), with community contributions.

### Phase 6: KofTerm draws its own screen (night)
- Decision: instead of a graphical terminal (KOF's `kof.ui` only draws on the JS target), KofTerm became a terminal inside the terminal, like `tmux`. That keeps "works in any Linux terminal" and frees the right side of the screen.
- `vt.kf` (pure, 12 tests): an emulator written from the public xterm/ECMA-48 behavior — text, UTF-8, autowrap, scroll regions, insert/delete lines and characters, colors (16/256/RGB), alternate screen, DEC line drawing, cursor save/restore, DSR/DA replies, title; DECCKM, keypad, bracketed paste and mouse modes are mirrored to the real terminal.
- Session rewritten: Bash's output goes into the emulator, KofTerm draws only changed rows, the typed line and grey suggestion are drawn on top of the emulator's cells, and the index column (F2) sits at the right. Bash gets a narrower window (`TIOCSWINSZ`), so programs never write over it. The cursor-position query and the bottom panel are gone: the emulator knows where everything is.
- Verified in tmux (110×30): the column stays put while `seq 1 200` scrolls; Bash sees `30 73`; `vim` edits a file in the left area and returns cleanly; `top` fits 73 columns and adapts to a resize to 130×34; Ctrl-C → 130; exit returns the outer terminal intact.
- Memory, measured with `top -d 0.2` (5 redraws per second) for 1–10 minutes, per fix:
  1. First version: 8 → 35 MB in a minute, 15% CPU. A probe showed KOF 0.6.6 native reclaims only part of temporary strings.
  2. Screen built in a C buffer with `stpcpy`, CSI parameters read as numbers into a reused array, color attributes cached, rows reused on scroll: ~+5 MB/min, CPU down ~18×.
  3. Command output kept as raw bytes in a 2 KB ring (turned into a String once per command), prompt scanner without a new list per ESC: ~+1 MB/min.
  4. A probe showed that **every evaluation of a string literal allocates a new String** (2 million `" "` → +14 MB; a field → nothing). Hot-path constants moved to fields: **7.9 MB flat for 6 minutes, 0.2% CPU.** Finding #5 in `KOF_FINDINGS.md`.

### Phase 7: human mode (night)
- `recipes.kf` (pure, 7 tests) and `recipes/pt_BR.txt` (61 recipes, 152 ways of asking). Matching ignores accents, case, punctuation and filler words, tolerates one-letter typos and prefixes, and fills `{gaps}` with the leftover words. The tokenizer drops shell characters and gaps never take options (`-rf`), so a request cannot smuggle another command in; dangerous results are filtered out.
- The first integration lagged: a search per key re-normalized every recipe and rebuilt a 60-word stopword list. Fixed by preparing the recipes once at load, a single stopword string, and drawing once per batch of keys.
- Verified in tmux: `? quero instalar o htop` → `sudo apt update && sudo apt install -y htop`; `? quanto espaço sobrou no disco` → `df -h`; `? procurar arquivo chamado relatorio` → `find . -iname "*relatorio*"`; `? compactr pasta fotos` (typo) → `tar -czvf fotos.tar.gz fotos`; `? apagar pasta lixo` → `rm -ri lixo`; `? fazer um bolo de chocolate` → no recipe. TAB puts the command on the line and the column explains it (`apt install`, `-y`).
- 66 unit tests pass.

### Second human test (Pedro, 0.6.0 in QTerminal) and 0.6.1
- `? acessar root` found nothing: recipes knew "entrar" but not "acessar", there was no root recipe, and a stray `@` before the word (`@acessar`) blocked the match. Fixed with a synonym table applied to both recipes and requests, conjugated verbs matched by their first 6 letters, a leading `@` dropped, root recipes, and a score that prefers recipes matching more of the request's words.
- `? instalar o claude` worked as designed, but the package does not exist in Kali's repositories; a learner is left stuck. KofTerm now reads apt's "não é possível encontrar o pacote" and suggests `apt search claude` on the empty line.
- "How do I open the side index?" and "the commands should show up right away": on first run the index column starts on, a welcome line lists the keys, and the empty column shows what KofTerm can do with `?` examples.
- Verified in tmux with a fresh HOME: the first screen, `? acessar root` / `? @acessar root` → `sudo -i`, `? ver pasta do root` → `sudo ls -la /root`, `? acessar a pasta fotos` → `cd fotos`, `? instalo o htop`, `? encontrar arquivo relatorio`, `? deletar arquivo velho.txt` → `rm -i velho.txt`, and `apt-get install -s claude` → `apt search claude`. 68 unit tests pass.

### Third human test (Pedro, 0.6.1 in QTerminal) and 0.6.2
- The column showed `não tem ""` for `sudo` and `não tem "-i"` for `sudo -i`: the index explained the command after the prefix, never the prefix itself. `entriesForLine` now returns the main command, the prefix (`sudo`, `env`, `time`, `nohup`, `watch`) and any path on the line that has an entry; the options of the prefix are read from the prefix's own words.
- After `sudo -i` nothing worked (`?: comando não encontrado`): the root shell is a new Bash that never loaded KofTerm's rc, so there was no prompt marker and KofTerm stayed in passthrough. KofTerm's rc now defines `sudo` and `bash` functions: `sudo -i`, `sudo su`, `sudo su -` open `sudo -H bash --rcfile <bashrc-login> -i` (starts in `~`), `sudo -s` and a plain `bash` reuse the normal rc; every other use passes straight through with `command`.
- "It has to be intuitive and complete", aimed at people studying networking and security in VM labs (Cisco courses, later Codecademy and Hack The Box). Before writing, every tool and path was checked on the Kali VM: `ufw`, `last`, `htop` and `tracepath` are not installed by default, and there is no `/var/log/syslog` or `/var/log/auth.log` (the journal replaces them). The index grew from 53 to 146 entries (users, services, networking, file analysis, important paths) and the recipes from 63 to 122. Scanning tools carry a note: only on your own lab network or with written permission.
- A new recipe `qual o ip de {site}` captured `? ver meu ip` (one literal word plus a filled gap scored higher than the right recipe with an extra word). Fixed by asking for "ip do site" and adding more ways to ask for `ip a`.
- Verified in tmux with a fresh HOME: 30 requests (gateway, MAC, DNS, ports, `nmap -sn`, capture, firewall, SSH keys, failed logins, SUID, hashes, Base64…) give the expected command; the column shows `sudo` and `/etc/shadow` for `sudo cat /etc/shadow`, the four options of `ss -tuln`, and `~/.ssh/authorized_keys`. A nested `bash` keeps `?` working and `type sudo` reports a function. All 155 reading links answer. 70 unit tests pass.
- `sudo -i` itself needs Pedro's password, so it is checked by hand (roteiro 4b).

### Third human test, continued (0.6.2 as root) and 0.6.3
- Confirmed by Pedro: after `sudo -i` the prompt is root, `pwd` is `/root`, `type sudo` shows KofTerm's function, and the recipe column keeps working.
- But `? acessar .cache na pasta root` suggested `sudo -i` to someone already root, and the generic recipe gave `cd .cache root`. KofTerm did not know the shell's user. The marker is now `ESC ] 7770 ; status ; EUID ; PWD BEL`; as root, recipe commands drop `sudo`, a recipe can give its own root command (`% ...`) or hide itself (`% -`), and a new recipe enters a folder inside `/root`.
- Verified in tmux, as root through `unshare -r` (EUID 0 without a password): `cd /root/.cache`, `apt update && apt install -y nmap`, `ls -la /root`, `lsof -i :22`; as a normal user `sudo ls -la /root/.cache` and `sudo -i` stay. 72 unit tests pass.
- The `bash: alias: ls -alF : não encontrado` lines at startup came from Pedro's own `~/.bashrc` (`alias ll= ' ls -alF '`, spaces around `=`), not from KofTerm.

### Full test script and missing programs (0.6.4)
- Pedro asked for a robust test script. `docs/TESTE_HUMANO.md` now covers every feature in blocks (terminal, editing, ghost text, context, security, column, search, full-screen programs, human mode, root, networking, missing programs, learning, performance, exit, install), with ★ for the essentials. Network checks use `ls -l /proc/$PPID/fd` because Kali has no `strace`.
- Pedro's rule, restated: what KOF lacks becomes a parallel KOF project; KofTerm must work in any Linux Bash terminal; when a system tool is missing, KofTerm says how to get it and explains in the column. Implemented: the column warns while typing (PATH lookup, cached per command name), and after exit 127 the empty line holds the install command. Package names come from a new `!` index line, or from Kali's command-not-found output ("pode ser instalado com: sudo apt install ufw"), or fall back to `apt search`.
- Found while testing: Kali's command-not-found offers the joke package `gti` instead of saying "did you mean git", and `sl` was corrected to `nl` because plain Levenshtein counts a swap as two edits. The distance now counts adjacent swaps as one (restricted Damerau), ties go to the most used command, and a distance-1 typo of a known command wins over an offered package. The index-based install hint runs first only for programs in the index.
- Verified in tmux without sudo: `ufw status` → `sudo apt install ufw` with the column block; as root (via `unshare -r`) → `apt install ufw` with "como root, não pede senha"; `gti status` → `git status`; `sl` → `ls`; `cowsay oi` → `apt search cowsay`; installed tools (`dig`, `tshark`) show no warning; recipes, completion and the sudo/path column unchanged. 75 unit tests pass.

### Still to verify by hand
- Everything above in a real QTerminal window, by Pedro (script in `docs/TESTE_HUMANO.md`).
- Typing in a real window to feel the ghost text, the tab and the panel (latency, colors).

### Opening the project to contributors (0.6.5)
- Pedro's plan: make it easy for new people to join (README, CONTRIBUTING, CODE_OF_CONDUCT, `good first issue` / `help wanted`, quick and kind reviews, public credit), a project site in the palette of dotpdf.dev, a presentation video like the portfolio making-of, and a post in the Énóis community.
- Added CONTRIBUTING.md (from "write a recipe" to KOF code, with the project rules), a code of conduct written for KofTerm (inspired by the Contributor Covenant 2.1), SECURITY.md, issue forms and a PR template, and README sections "How to help" and "Contributors". Eight first issues are drafted in `docs/issues/primeiras-issues.md`, each checked against the code (one draft about plurals was dropped: recipes already match word prefixes).
- Site in `site/`: static HTML and CSS, palette and fonts read from dotpdf.dev (navy `#1d2537`, cream `#efe4cc`, gold `#e7a44a`, red `#9e1b2b`; IM Fell English, Inter, JetBrains Mono). The demo terminal reproduces screens captured in tmux. `cover.png` (1200×630) is rendered from `cover.html` with headless Edge.
- Pedro's test of 0.6.4 showed the index column frozen on "script": `script -c kofterm` had been typed inside KofTerm, nesting one KofTerm in another. KofTerm now detects `KOFTERM` (via `secure_getenv`, which returns a pointer, so a missing variable is a clean 0) and explains instead of nesting. `script` got an index entry and a recipe.
- Drafts for the presentation video (`docs/divulgacao/video-roteiro.md`) and the Énóis post (`docs/divulgacao/post-enois.md`).

### A README that gets to the point, and the Kali prompt (0.6.6)
- Pedro pointed out that the README was still long and not directive: someone landing on the repository should see right away what KofTerm is for, how to install it and how to use it, as in the clinews README, with the process and audit trail afterwards. Both READMEs were rewritten in that order (455 → 192 lines); the technical sections moved, unchanged, to `docs/COMO_FOI_FEITO.md` and `docs/HOW_IT_WAS_BUILT.md`. Two stale statements were fixed on the way: the index is a text file, not SQLite, and the neural model is phase 8, not 6. The architecture diagram now shows the emulator, the events file and the index and recipe files.
- While recording the video, a real capture showed the index column's separator missing on prompt lines. Kali's default prompt contains `㉿` (U+327F), which terminals draw two columns wide while the emulator counted one, so every prompt line overflowed by one column. The emulator now gives double-width characters two cells (the second one empty, emitting nothing), turns an orphaned half into a space when overwritten, and wraps before a wide character at the end of a line. This was also the "dotted" separator in Pedro's screenshots.
- 76 unit tests pass.

### Version 0.7 begins: secrets out of the history
- Mariana's review (security, reliability and tests before new features) set the order of 0.7. First item: the local `history` and `events` files kept every line typed, so `mysql -pPASSWORD` or `export GITHUB_TOKEN=...` stayed on disk (mode 0600, but still there).
- The contribution anonymizer already had a secret detector, deliberately strict (any `export X=` counts). It became `secretLine(raw, strict)`: strict for contributions, lenient for local history so `export PATH=...` stays. Both now also catch `user:password@` inside a URL. `privateLine()` adds Bash's convention of keeping lines that start with a space out of the history.
- On Enter, a private line still goes to Bash but is not written to `history` or `events` and does not teach the model. On start, both files are cleaned of secrets written by older versions and rewritten (still 0600).
- Tested: 9 anon tests (12 new assertions); on the VM with a temporary HOME, an old history with a fake `GITHUB_TOKEN` and old events with a fake `mysql -p` were cleaned on start, and of six typed commands only the two ordinary ones were saved.

### Version 0.7, part 2: risk by context
- Mariana's second point: danger depends on context, arguments and privileges. The old check was binary, looked only at the first command on the line and compared exact targets, so `echo ok; rm -rf /`, `cd / && rm -rf *`, `rm -rf /etc/` (trailing slash) and `sudo -u root rm -rf /` slipped through, and `curl … | sh`, `> /etc/passwd`, `wipefs`, `shred /dev/sda`, `find / -delete` were not recognized at all.
- `lineRisk(line, root, cwd)` now splits the line on `;` `&&` `||` `|` `&` (outside quotes, keeping `2>&1`), follows a `cd` inside the line, skips `sudo`/`doas` with their options, `env`, `nohup`, `time`, `nice` and `VAR=value`, and normalizes targets. Privilege (sudo or root) and the current folder change the level. Two levels, each with a plain reason: DANGER (red, never suggested) and Caution (yellow in the column, still suggestible, e.g. the `reboot` recipe). `isDangerous()` stays as the DANGER check for recipes and suggestions.
- Verified: 2 new test groups with 30 assertions (79 unit tests); in tmux, typing without Enter: `echo ok; rm -rf /` shows PERIGO, `sudo rm -rf /etc/nginx` and `curl … | sh` show Atenção with the reason, `rm -rf build` shows nothing.

### Version 0.7, part 3: PTY security and reliability tests
- Mariana's third point: test the terminal itself, not only the pure modules. Writing the tests turned up a real hole first. The prompt marker (`ESC ] 7770 ; status ; uid ; folder BEL`) had no secret, so any output could print it: a `cat` of a crafted file, a downloaded page, or a program asking for a password. KofTerm would then believe the prompt was back, take over the keyboard and put what was typed next into its editor and history. The marker now starts with a 24-character token drawn from `/dev/urandom` at each start and written only into KofTerm's own bashrc (folder 0700). A marker with a wrong or missing token is dropped without a trace, and one without an end is cut at 4 KB. 2 new prompt tests.
- `kofterm selftest`, in KOF (`src/selftest.kf`): opens KofTerm itself with `forkpty` and a temporary HOME, talks to it like a terminal, and checks 19 things. These cover the exit code; SIGTERM, a closed terminal and a killed bash, each ending KofTerm with the terminal restored (`ICANON` and `ECHO` back on) and no orphan bash; 300,000 lines, 300 KB of binary garbage and 60 resizes during output; a fake marker; no network socket; and the history keeping ordinary lines but not passwords. Expected outputs use shell arithmetic (`echo VIVO_$((40+2))` waits for `VIVO_42`), so the echo of the typed line never counts as an answer. It runs in about 30 seconds and CI runs it on every push.
- Mutation check: with the token check disabled in a throwaway copy, the selftest fails on "fake marker: nothing captured in the history". The typed "secret" really was saved before this fix.
- Lessons while writing it: files in `/proc` report size 0, so `loadLines` (which trusts `lseek`) reads nothing; the selftest reads them directly. In the first run, an unknown bash pid of -1 reached `kill(-1, 9)`, which signals every process of the user and dropped the SSH session to the VM. Nothing was lost, and the selftest now signals only pids above 1. The first version also rebuilt a 200 KB String on every read, burning CPU for minutes; the search window is now 8 KB. KOF finding #6: a `static` constant cannot be the value of `buffer.poke*` inside a class method.
- Verified on the VM: 81 unit tests; selftest 19/19 three runs in a row, temporary folder removed.

### Version 0.8.0: finding things
- Pedro chose the shape of each piece before the code: Ctrl+R and the TAB candidates as lists in the column (below the line when the window is too narrow for it), and the mouse wheel captured only at the prompt, with Shift+drag to select and F3 to turn it off.
- Why the wheel never worked: KofTerm draws on the terminal's alternate screen (so `exit` brings back the screen from before), and the alternate screen has no scrollback. The emulator now keeps the lines that leave the top of the main screen in a ring of 2,000. Once full, the line coming in swaps places with the oldest one, which returns cleared to the bottom, so the 300,000-line selftest allocates nothing new. The alternate screen (vim, htop, less) never enters the ring; shrinking the window keeps the lines that no longer fit.
- The key decoder learned mouse reports in SGR form (`ESC [ < b ; x ; y M`): 64 and 65 are the wheel, and Shift, Alt and Ctrl add 4, 8 and 16. Clicks are swallowed instead of reaching Bash. Shift+PgUp is `ESC [ 5 ; 2 ~`, which the decoder used to read as a plain PgUp.
- KofTerm asks the terminal for the mouse (`?1000h ?1006h`) only while the prompt is being edited and gives it back in the same frame that sends the line to Bash, so a click never lands in `cat` or a password prompt. The selftest checks both: the bar appears after a wheel report, and `?1000l` comes before the program runs.
- The TAB candidates come from `pathCandidates` (the folder read that `completePath` already did, now sorted byte-wise like `ls` with `LC_ALL=C`, capped at 500). `completePath` keeps the common prefix on top of it, so TAB still completes as far as it can and lists only when there is a real choice.
- Verified on the VM: 88 unit tests (Ctrl+R, F3, Shift+PgUp, wheel, a click, a wheel report cut between two reads, history search, byte order, the ring); tmux runs at 160 and 60 columns; selftest 21/21.

### After 0.8.0: English for the index and the screens
- Pedro chose the scope: the 150 index entries and every fixed text of the column, the warnings and the banner; the `?` recipes stay Portuguese for now. Portuguese stays the default, and English is a choice (`kofterm lang en`), saved in `~/.local/share/kofterm/lang`.
- `index/en.txt` is a full translation of `index/pt_BR.txt` with the same names, `!` packages and `@` links in the same order (checked with a diff of those lines). Examples use English file names (`notes.txt`, `photos`, `user@server`).
- The screens use `tr("Atenção", "Caution")`: both texts sit side by side in the code, so a new message cannot forget its translation. `Lang` and `tr` live in `model.kf` because `kof test` on one file cannot see functions from another, and the risk reasons in `model.kf` need them.
- If `index/en.txt` is missing, KofTerm falls back to the Portuguese index instead of opening with an empty column.
- Verified on the VM: all unit tests, selftest 21/21, and a tmux run in English (banner, `ls -la`, the danger reason for `sudo rm -rf /`, Caps Lock, Ctrl+R, TAB, the scroll bar, F3, the F1 tab, `kofterm lang` and `doctor`).
