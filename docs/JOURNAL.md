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

### Still to verify by hand
- `vim`, `htop` and resizing with a real window, running `build/kofterm/Default/Main` in the VM.
