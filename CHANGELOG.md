# Changelog

All notable changes to KofTerm are documented here. Dates are in DD/MM/YYYY.

## [0.7.2] - 23/10/2026

Two small helps that came from Pedro's test of 0.7.1.

### Added
- Caps Lock: after "command not found", if the same name in lowercase is a known command (`EXIT`, `LS -la`, `Pwd`, `sudo CAT ...`), the grey suggestion is the lowercase command with the rest of the line unchanged, and the column explains that Linux treats uppercase and lowercase as different names
- Each KofTerm window remembers its version (in the `KOFTERM` variable). Inside a window older than the installed program, `kofterm version` and the "KofTerm is already open" message say so and ask you to type `exit` and open `kofterm` again; before, `kofterm version` showed the installed version and hid that the window was still the old one

## [0.7.1] - 23/10/2026

Networking recipes for labs, `kofterm update`, and a safer test web server, from Pedro's test of 0.7.0.

### Added
- `kofterm update` shows how to update this installation: `cd <your clone> && git pull && ./install.sh` when it was installed from source, or the release steps when it came from the ready-made package. It downloads and runs nothing (KofTerm stays offline); `kofterm install` now notes where it came from in `~/.local/share/kofterm/origem`, and installs made before that are recognized when the clone is in `~/kofterm`
- A test web server is judged by the folder it serves: `python3 -m http.server` or `php -S` serving your home folder, `~/.ssh`, `/` or a system folder shows Caution ("shares your whole home folder with the network, including ~/.ssh"), and DANGER when done as root. Serving only on `127.0.0.1`/`localhost` (`--bind`) or a project folder (`--directory`) shows nothing. Found by Pedro's test: the recipe served the home folder
- The web server recipe now serves only the folder you name (`--directory {pasta}`), and a new recipe serves only to this machine (`--bind 127.0.0.1`); `python3` index entry explains both options
- README section "Update", including closing and reopening KofTerm windows that were already open (they keep the old version until reopened)

### Fixed
- Test script step N.5 counted its own `grep` line in the history; it now uses `grep -cx` and asks for a KofTerm opened after the update
- 17 networking recipes for labs and Cisco studies: route to an IP (`ip route get`), add or remove an IP on an interface, renew the IP through DHCP (`nmcli`), restart the network, nearby Wi-Fi networks, IPv6 addresses, interface statistics, subnet calculation (`ipcalc`), MX, NS and TXT records, asking a specific DNS server (`dig @server`), testing a UDP port, listening on a port (`nc -lvnp`), a quick web server (`python3 -m http.server`) and OS detection (`nmap -O`, lab only). "pingar {site}" and "fazer ping em {site}" now reach the ping recipe
- Index entries `ipcalc` (with its package, so KofTerm says how to install it when missing) and `python3` (150 entries, 141 recipes)
- Versioning policy and the road to 1.0 in CONTRIBUTING (section "Versões") and the README

## [0.7.0] - 23/10/2026

Security, reliability and tests first, following Mariana's review.

### Security
- Secrets stay out of the history: a line that looks like a password, token or key (`mysql -pPASSWORD`, `export GITHUB_TOKEN=...`, `curl -u user:pass`, `https://user:pass@host`, `sshpass`, long key-like strings) still runs, but is not written to `history` or `events` and does not teach the model. A line starting with a space is also kept out, the same convention as Bash's `HISTCONTROL=ignorespace`
- On start, secrets that older versions already wrote to `history` and `events` are removed and the files are rewritten (still 0600)
- The secret detector now also catches a user and password inside a URL, for contributions too; local history keeps ordinary `export PATH=...` lines, while contributions still drop every `export`

- Dangerous commands are judged by context, not by a fixed list: every command on the line counts (`;`, `&&`, `||`, `|`, `&`), `sudo`/`doas` (including `sudo -u root`) and being root raise the risk, and the current folder matters (`rm -rf *` in your home is DANGER, inside a project it is not; `cd / && rm -rf *` is caught). Targets written differently are recognized (`/etc/`, `/home/*`, `$HOME`)
- Two levels with the reason shown in the column: DANGER (red, never suggested: wiping the system, home or a system folder, overwriting `/etc/passwd`, `chmod 777 /etc/shadow`, `dd`/`wipefs`/`shred`/`mkfs` on a disk, `find / -delete`, moving `/etc`, fork bomb) and Caution (yellow, may still be suggested: `sudo rm -rf` inside a system folder, `curl … | sh`, `reboot`/`shutdown`, flushing the firewall, `kill -9 -1`, `crontab -r`, `fdisk`, `git push --force`)
- The invisible prompt marker now carries a random token drawn at each start (24 hex characters from `/dev/urandom`, known only to KofTerm's own bashrc in its 0700 folder). Before, any output (a `cat` of a file, a downloaded page, a program that asks for a password) could print a fake marker and make KofTerm take over the keyboard, so what you typed next, a password for example, went into its editor and its history. A marker with a wrong or missing token is now dropped, and an unterminated one is cut at 4 KB
- New `kofterm selftest`, written in KOF: it opens KofTerm itself in a new pseudo-terminal with a temporary home folder and checks, in about 30 seconds, that the exit code is passed on (`exit 7`), that SIGTERM, a closed terminal and a killed bash all end KofTerm with the terminal restored and no orphan bash, that 300,000 lines of output, 300 KB of binary garbage and a storm of 60 resizes leave it responsive, that a fake marker cannot capture keystrokes, that no network socket is open, and that a line with a password stays out of the history. CI runs it on every push
- 2 new test groups (30 assertions) for risk and 2 for the marker token; 81 unit tests plus 19 PTY checks

### Changed
- New "100% brasileiro" identity, inspired by Brazilian TV commercials of the early 2000s: blue TV background with soft rays, chrome KOFTERM lettering with a yellow outline, the slogan "Seus problemas com o terminal acabaram!", a green-yellow-blue stripe and a round seal pinned to the terminal's corner. Applied to the README banner (now `docs/images/banner.png`, rendered from `site/banner.html`), the site and the cover image; the rest of the site stays short on a plain background

### Thanks
- Mariana ([@marianabsctba](https://github.com/marianabsctba)) for the technical review: context-aware danger checks, PTY security tests and keeping secrets out of the history

## [0.6.6] - 21/10/2026

A README that gets straight to the point, and the Kali prompt fixed.

### Changed
- README (English and Portuguese) rewritten to be short and direct, like the clinews README: what KofTerm is, a real screen, how to install right away, first steps, what it does, why it exists, safety, KOF, how to help and contributors; the process and audit trail come at the end
- The technical sections (status, features, architecture, repository map, roadmap, end-to-end process, developer notes) moved to `docs/COMO_FOI_FEITO.md` and `docs/HOW_IT_WAS_BUILT.md`, with an up-to-date architecture diagram

### Fixed
- Double-width characters such as the `㉿` in Kali's default prompt (and CJK text) now take two columns in the emulator. Before, the prompt line was one column too long on screen and erased the index column's separator, which looked like a dotted line
- 76 unit tests

## [0.6.5] - 21/10/2026

Open to contributors: guide, code of conduct, templates and a project site.

### Added
- `CONTRIBUTING.md` (ways to help from easiest to most technical, local setup, issues, pull requests, project rules, recognition), `CODE_OF_CONDUCT.md` (written for KofTerm, inspired by the Contributor Covenant 2.1), `SECURITY.md`
- Issue forms (bug, recipe, index entry, idea) and a pull request template; README sections "How to help" and "Contributors"
- Project site in `site/` (static HTML and CSS in the portfolio palette) with a cover image, published by `.github/workflows/pages.yml`
- Index entry `script` (record a terminal session) and recipe `? gravar a aula em {arquivo}` (148 entries, 124 recipes)

### Fixed
- Running `kofterm` inside KofTerm (for example `script -c kofterm` typed in it) opened a second KofTerm in the left area while the outer column froze. It now explains and exits; subcommands such as `kofterm contribute` still work inside

## [0.6.4] - 21/10/2026

"What is missing, KofTerm points to", and a full test script.

### Added
- Missing programs: while typing, the index column warns "⚠ x não está instalado" and shows "Para baixar o que falta, use: » sudo apt install <pacote>"; after "command not found" the empty line suggests that command (without `sudo` as root). Nothing is installed without Enter
- Index line `! package` for programs whose apt package has another name (57 entries: `dig` → `bind9-dnsutils`, `ss` → `iproute2`, `nc` → `netcat-traditional`…); new `htop` entry (147 entries)
- Programs outside the index: the package named by the system's own command-not-found output; if there is none, `apt search <name>`
- `docs/TESTE_HUMANO.md` rewritten as a full test script: blocks 0–Q covering every feature, ★ marks the 30-minute essentials

### Fixed
- Typo correction treats two swapped neighbor letters as one error: `sl` → `ls` (was `nl`), `gti` → `git`; a one-letter typo of a known command wins over a joke package offered by command-not-found (`gti`)
- 75 unit tests

## [0.6.3] - 21/10/2026

From the third human test of 0.6.2 (as root after `sudo -i`).

### Fixed
- Recipes know when the shell is root: the prompt marker now carries `$EUID`; as root, commands drop `sudo`, and "become root" / "repeat with sudo" are hidden. `? acessar .cache na pasta root` gave `sudo -i` to someone already root; now it gives `cd /root/.cache` (and `sudo ls -la /root/.cache` for a normal user)
- New recipe format line `% command` for the root version of a recipe (`% -` hides it for root); 123 recipes, 353 ways of asking

## [0.6.2] - 21/10/2026

Fixes from the second human test of 0.6.1, plus content for people studying networking and security.

### Added
- Index: 146 entries (was 53). New: users and permissions (`su`, `id`, `groups`, `adduser`, `usermod`, `passwd`, `who`, `w`…), system and services (`systemctl`, `journalctl`, `timedatectl`, `lsblk`, `dmesg`, `crontab`, `lsof`…), networking (`ss`, `ip a`/`ip r`/`ip link`/`ip neigh`, `traceroute`, `dig`, `nslookup`, `nmap`, `tcpdump`, `tshark`, `nc`, `ssh-keygen`, `iptables`, `nft`…), file analysis (`file`, `strings`, `sha256sum`, `base64`, `xxd`, `openssl`, `awk`, `sed`…) and important paths (`/etc/passwd`, `/etc/shadow`, `/etc/hosts`, `/etc/ssh/sshd_config`, `/var/log`, `/proc`, `~/.ssh/authorized_keys`…). Every link checked; every tool checked on Kali (with a note when it needs installing)
- Recipes: 122 (was 63), 348 ways of asking: gateway, MAC, DNS, traceroute, active connections, who uses a port, test a port, discover hosts in your lab network, capture traffic, firewall rules, SSH keys, failed logins, sudo log, users and groups, SUID audit, hashes, Base64, services, disks, kernel messages
- The index column explains the whole line: the `sudo` prefix and its options, and paths on the line, in a new "TAMBÉM NA LINHA" section

### Fixed
- KofTerm kept working only in the first shell: `sudo -i`, `sudo -s`, `sudo su` and a plain `bash` now open the inner shell with KofTerm's hook, so the grey suggestion, `?` and the column keep working as root
- The `sudo` entry now says what it does; examples no longer mention `/var/log/syslog`, which Kali does not have (use `journalctl`)
- `kofterm doctor` counts index "entries" (commands and paths)

## [0.6.1] - 21/10/2026

Fixes from the first human test of 0.6.0.

### Added
- First run shows what KofTerm can do: the index column starts on (F2 still hides it and the choice is remembered), a welcome line lists the keys, and the empty column shows the keys and `?` examples
- Recipes for root: `? acessar root` → `sudo -i`, `? ver pasta do root` → `sudo ls -la /root` (63 recipes, 164 ways of asking)
- After "Unable to locate package" / "Não é possível encontrar o pacote", the empty line suggests `apt search <name>`

### Fixed
- Human mode understands synonyms (acessar = entrar, achar/encontrar/buscar = procurar, deletar/excluir = apagar…), conjugated verbs (instalo = instalar) and ignores a stray `@` before a word
- A recipe that matches more of the request's words now wins over a generic one with a gap (`? entrar na pasta root` → `sudo -i`, not `cd root`)

## [0.6.0] - 21/10/2026

Phases 6 and 7: KofTerm draws its own screen, index column on the right, human mode.

### Added
- `vt.kf`: terminal emulator in KOF (xterm/ECMA-48 subset) with 12 unit tests
- Index **column on the right** (F2, remembered): explains the current line live; Bash and full-screen programs get a narrower window and never write over it
- Human mode: `? what you want` suggests a command from `recipes/pt_BR.txt` (61 recipes, 152 ways of asking); TAB or Enter puts it on the line, Enter again runs it; the column shows the recipe, its explanation and alternatives
- `recipes.kf` with 7 unit tests (66 in total); CI runs them

### Changed
- KofTerm uses the outer terminal's alternate screen, like `tmux`; the previous screen comes back on exit
- The bottom panel and the cursor-position query (Phase 3) were replaced by the emulator
- `kofterm install`/`uninstall` handle `recipes/`

### Performance
- With `top` redrawing 5 times a second and the column on: 7.9 MB steady for 6 minutes, 0.2% CPU (the first version grew 27 MB per minute)

## [0.5.0] - 21/10/2026

Phase 5: anonymized contribution, installer and first release.

### Added
- `kofterm contribute [--preview]`: exports aggregated, anonymized patterns (seen at least 3 times) for an opt-in pull request; never sends anything
- `kofterm check FILE...`: validates `.kofdata` files with the same rules (used by CI)
- `kofterm install`, `uninstall [--purge]`, `doctor`, `version`, `help`
- `install.sh`: bootstrap that gets KOF 0.6.6 if missing (asks first, SHA-256 pinned), builds and installs
- Community contributions in `datasets/contrib/*.kofdata` loaded at startup
- `corpus/commands.txt`: public list of command names used by the anonymizer and the typo fixer
- `anon.kf` with 8 unit tests (47 in total)
- GitHub Actions CI: unit tests, native build, "no network code" check, contribution validation, smoke test
- Release tarball with a ready-made binary (needs only glibc 2.34+)

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
