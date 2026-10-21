# Fase 0: spikes de FFI — ✅ concluída (21/10/2026)

Objetivo: provar que o KOF native consegue fazer tudo o que um terminal precisa, só com
`extern` para a libc. **Os 3 passaram** no KOF 0.6.6, Kali (glibc 2.43, x86_64).

Cada spike fica em sua própria pasta porque `kof run`/`kof build` compila **todos** os `.kf`
da pasta (três `main()` juntos não compilam).

```bash
cd spikes/02_winsize && kof run main.kf --target=native
```

| Spike | Prova | Resultado |
|---|---|---|
| 01 | modo raw (`termios`) e leitura byte a byte | `a`→`97`, seta↑→`27 91 65`, `q` sai; terminal restaurado |
| 02 | `ioctl(TIOCGWINSZ)` | `40x120` e `24x80` lidos corretamente |
| 03 | `forkpty` + `execvp(bash)` + `ppoll` | bash em `/dev/pts/N`, `stty size` propagado, Ctrl-C → 130, `exit` limpo, terminal restaurado |

Ainda falta testar à mão, na janela da VM: `vim`, `htop` e redimensionar com o spike 03 rodando.

```bash
~/projects/kofterm/build/03_pty_bash/Default/Main
```

## O que a Fase 0 ensinou sobre o KOF 0.6.6

1. **Sem constantes no topo do arquivo.** `val X = 1` fora de função é `PARSE007`.
   Use `class C { static Int X = 1 }` e `C.X`.
2. **`Buffer(U8)` só existe dentro de `extern`.** Não pode ser tipo de parâmetro de função
   comum (`SEM011`). Padrão adotado: memória crua com `malloc`/`free` (`Long`) e
   `buffer.peek8/32/64(addr)` / `buffer.poke8/32/64(addr, v)`. Ponteiros viram `Long`, então
   tudo pode ser encapsulado em funções e, depois, na biblioteca `kof-tty`.
3. **`extern` com nome de builtin do KOF é desviado em silêncio.** `poll` vai para o
   `poll(handle)` de concorrência do KOF e retorna `null`, sem erro de compilação.
   Use `ppoll`. Verifique qualquer `extern` novo contra os nomes da stdlib
   (`poll`, `done`, `cancel`, `await`, `spawn`, `sleep`, `now`…). **Reportar ao KofLang/Kof4j.**
4. **`char**` (argv) sem `String[]`:** `strdup(String): Long` dá o endereço de cada string,
   e o vetor é montado com `poke64` num bloco de `malloc`.
5. **SIGTTOU:** `tcsetattr` em processo de grupo de fundo pausa o processo. Em testes,
   use `timeout --foreground`, nunca `timeout` puro.
6. **Morte por sinal não roda `finally`.** Matar o kofterm deixa o terminal em modo raw.
   A Fase 1 precisa restaurar o termios em `SIGTERM`/`SIGHUP`, e callback de sinal é
   `FFI001`. Caminho: `signalfd` (lido no mesmo `ppoll`), sem callback.
7. Binários native ficam com ~60 KB.
