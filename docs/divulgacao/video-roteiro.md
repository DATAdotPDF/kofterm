# Vídeo de apresentação do KofTerm: roteiro (rascunho para aprovação)

Mesma linguagem do making-of do portfólio: fundo azul-marinho `#1d2537` com grade sutil,
títulos grandes em caixa alta (creme, dourado e ciano), frases em itálico serifado
(*IM Fell English*), texto de terminal em JetBrains Mono, linha pontilhada de "mapa" com X
vermelhos e caixas de erro vermelhas. 16:9, 1920×1080, cerca de **2 minutos**.

As telas do KofTerm são **gravações reais** da VM Kali (tmux), sem mockup.

| # | Tempo | Cena | Na tela |
|---|---|---|---|
| 1 | 0–8 s | O problema | Terminal digitando: `> abrindo o terminal pela primeira vez` / `> resultado: um cursor piscando e nenhuma pista` |
| 2 | 8–16 s | A pergunta | Itálico: *e se o terminal explicasse cada comando enquanto você digita?* |
| 3 | 16–22 s | O nome | **KOFTERM.** em dourado, com `>_` piscando |
| 4 | 22–34 s | Para quem | // PARA QUEM ESTUDA · **LINUX · REDES · CIBERSEGURANÇA** (Cisco, VMs, Hack The Box) |
| 5 | 34–50 s | Coluna do índice | Gravação: digitar `sudo cat /etc/shadow` devagar e a coluna explicando `cat`, `sudo` e `/etc/shadow` |
| 6 | 50–62 s | Modo ? | Gravação: `? qual o gateway` → `ip r`; `? quem usa a porta 22` → `sudo lsof -i :22` |
| 7 | 62–72 s | Contexto | Gravação: `cat /etc/shadow` → "Permissão negada" → cinza `sudo cat /etc/shadow`; `gti status` → `git status` |
| 8 | 72–80 s | O que falta | Gravação: `ufw status` → coluna "⚠ não está instalado · » sudo apt install ufw" |
| 9 | 80–90 s | Construção | **FEITO EM KOF.** Linha de mapa; `// uma linguagem brasileira` · emulador de terminal, modelo, instalador e testes em KOF |
| 10 | 90–100 s | Os erros | Caixas vermelhas empilhando: `poll sequestrado` · `Map caía com 3.650 chaves` · `27 MB por minuto de vazamento` · `o root perdia o KofTerm`. Depois, itálico: *resolvido. um por um.* |
| 11 | 100–108 s | Os números | **0** conexões de rede · **7,9 MB** de memória · **75** testes · **4** bugs reportados ao KOF |
| 12 | 108–116 s | A tripulação | Selos: KOF 0.6.6 · CLAUDE CODE · KALI LINUX · TMUX · GITHUB ACTIONS · FFMPEG · *+ Mel Santos e a comunidade KOF* |
| 13 | 116–124 s | Convite | **OPEN SOURCE.** *ajudar, cooperar e somar.* · `good first issue` · github.com/DATAdotPDF/kofterm |
| 14 | 124–132 s | Assinatura | *Pedro D. Ferreira* · Data Engineer & Cybersecurity Student · linha de mapa · `datadotpdf.github.io/kofterm` |

**Áudio:** os mesmos efeitos do making-of (teclado, "whoosh" nas transições), se você
autorizar reaproveitar a pasta `sfx/`; trilha opcional.

**Como será produzido:** cenas em HTML e CSS na mesma paleta, gravações reais do KofTerm
capturadas no tmux e montagem com FFmpeg, com uma folha de revisão (`review.jpg`) igual à do
making-of antes do arquivo final.
