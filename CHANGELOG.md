# Changelog

All notable changes to KofTerm are documented here. Dates are in DD/MM/YYYY.

## [0.4.0] - 21/10/2026

Phase 4: context-aware model and local learning.

### Added
- `model.kf`: local model that learns from every command (line counts, line-to-line transitions, kind of folder, word n-grams, recency), with 9 unit tests
- Empty-line prediction of the next command; `sudo` after "Permission denied"; typo fix after exit 127
- Completion of files, folders, options from the index and subcommands
- Dangerous commands shown in red with a warning in the panel, never suggested or learned
- `corpus/sessions.txt`: starter command sequences written by the project
- Event file `~/.local/share/kofterm/events` (0600): exit code, folder features, command
- `docs/KOF_FINDINGS.md`: four KOF 0.6.6 problems with minimal reproductions

### Fixed
- Exit code was always 0 under bashrc files that rewrite `PROMPT_COMMAND` (Kali): the hook reinstalls itself
- Typos (exit 127) are no longer learned

### Changed
- `src/libc.kf` renamed to `src/00_libc.kf` so its `extern`s compile before every other file
- KOF's native `Map` replaced by a hash map written in KOF (`KtIntMap`), which survives tens of thousands of keys

## [0.3.0] - 21/10/2026

Phase 3: offline command index, index tab and live panel.

### Added
- `index/pt_BR.txt`: 53 entries written by the project for Bash learners (files, search, permissions, packages, processes, network, Git, shell operators), with checked reading links
- Index tab (**F1** / **Ctrl+T**) on the alternate screen: search by name or summary, details with options, examples and links, "Na sua linha" explaining each option of the current line (`-ld` → `-l` + `-d`)
- Live panel (**F2**): split screen with the explanation of the line being typed; Bash gets a shorter screen and a scroll region protects the panel; the choice is remembered
- Cursor position asked to the terminal at each prompt (`ESC[6n`) with a 300 ms fallback to the previous mode
- Keys: Esc, F1, F2, Ctrl+T, PgUp/PgDn
- `index.kf` with 9 unit tests; 30 unit tests in total

### Fixed
- Long lines that wrap at the bottom of the screen are drawn in the right place

## [0.2.0] - 21/10/2026

Phase 2: line editor and ghost text.

### Added
- KofTerm edits the line at the prompt: Bash runs with `--noediting` and KofTerm's own bashrc, which loads `~/.bashrc` and adds an invisible prompt marker with the exit code and current folder
- Ghost-text suggestion from history in grey; **TAB** or **→** accepts, **Ctrl+→** accepts one word
- Line editing: ←/→, Home/End, Ctrl-A/E/B/F, Ctrl-U/K/W, Alt-B/F, Delete, Backspace, Ctrl-L (keeps the draft), ↑/↓ history, UTF-8 input
- Persistent history in `~/.local/share/kofterm/history`; lines starting with a space are not saved
- Pure modules with 19 unit tests: `keys.kf`, `editor.kf`, `history.kf`, `prompt.kf`

### Fixed
- Data folder forced to `0700` and files to `0600` with `chmod`, including folders created before

### Known limitations
- Bash's own TAB completion is off at the prompt (file completion planned for Phase 4)
- Lines wrapping past the bottom of the screen may redraw in the wrong place

## [0.1.0] - 21/10/2026

Phase 1: passthrough terminal.

### Added
- `src/`: KofTerm runs Bash in a pseudo-terminal (`libc.kf`, `tty.kf`, `pty.kf`, `sig.kf`, `main.kf`)
- Signals read as data through `signalfd`: resize on `SIGWINCH`; terminal restored and Bash closed on `SIGTERM`/`SIGHUP`; external `SIGINT`/`SIGQUIT` forwarded to Bash
- KofTerm exits with Bash's exit code (128 + N when Bash dies from signal N)
- `KOFTERM=1` in Bash's environment
- Plan updated with Pedro's vision: audience of Bash learners, continuous local learning, opt-in anonymized contribution through Git, per-option explanations and reading links

### Verified
- On Kali Linux with KOF 0.6.6: normal session, Ctrl-C, `exit 7` → 7, resize 30×100 → 50×150, `SIGTERM` → 143, `SIGHUP` → 129, terminal restored and no orphan Bash in every case

## [0.0.1] - 21/10/2026

Phase 0: FFI spikes.

### Added
- Project plan: architecture, modules, AI strategy, offline index, phases ([docs/PLAN.md](docs/PLAN.md))
- Spike 01: raw keyboard mode with `termios`, byte-by-byte input
- Spike 02: terminal size with `ioctl(TIOCGWINSZ)`
- Spike 03: Bash inside a pseudo-terminal with `forkpty`, `execvp` and `ppoll`
- Phase 0 findings about KOF 0.6.6 ([spikes/README.md](spikes/README.md))
- README (English and Portuguese), authorship and credit files

### Verified
- All three spikes compile to native ELF (~60 KB) and pass on Kali Linux, glibc 2.43, KOF 0.6.6
