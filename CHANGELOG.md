# Changelog

All notable changes to KofTerm are documented here. Dates are in DD/MM/YYYY.

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
