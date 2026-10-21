# Changelog

All notable changes to KofTerm are documented here. Dates are in DD/MM/YYYY.

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
