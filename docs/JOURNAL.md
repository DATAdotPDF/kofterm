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

### Still to verify by hand
- `vim`, `htop` and resizing with a real window, running `kofterm` in the VM.
- Typing in a real window to feel the ghost text, the tab and the panel (latency, colors).
