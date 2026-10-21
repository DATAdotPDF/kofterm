# Rascunhos de issues para KofLang/Kof4j

Quatro issues separadas, no formato do template `bug_report.yml` do Kof4j. Reproduções
reconfirmadas em 21/10/2026 com KOF 0.6.6 (release oficial) no Kali Linux x86_64.

**Publicadas em 21/10/2026**, com o texto exatamente como está abaixo:

| Rascunho | Issue |
|---|---|
| Issue 1 — `extern` com nome de função nativa (`poll`) | [KofLang/Kof4j#931](https://github.com/KofLang/Kof4j/issues/931) |
| Issue 2 — função do usuário sombreada (`writeFile`) | [KofLang/Kof4j#932](https://github.com/KofLang/Kof4j/issues/932) |
| Issue 3 — `Map` no native cai em ~3.650 chaves | [KofLang/Kof4j#933](https://github.com/KofLang/Kof4j/issues/933) |
| Issue 4 — `extern` e ordem dos arquivos | [KofLang/Kof4j#934](https://github.com/KofLang/Kof4j/issues/934) |

Os labels finais foram aplicados pela triagem automática do Kof4j (`github-actions[bot]`).

---

## Issue 1

**Título:** `extern` com o nome de uma função nativa do KOF (`poll`) chama a função nativa, sem aviso

**Labels:** bug, native

### Summary

Um `extern` cujo nome coincide com uma função nativa do KOF não chama a libc: a chamada vai para a função do KOF, em silêncio. Com `poll`, um `extern` declarado como `Int` imprime `r=null`, valor que o `poll(2)` da libc nunca devolve. Num programa real (um laço com `poll` em stdin e num PTY), a chamada nunca respeitava o timeout e o laço travava. O compilador não dá erro nem aviso.

Contorno usado: `ppoll`, que não colide com nenhum nome do KOF.

### Target

Native

### Kof version

0.6.6

### Operating system

Kali Linux x86_64 (glibc 2.43)

### Minimal reproduction

```kof
extern "libc.so.6" poll(Long fds, Long nfds, Int timeout): Int

main() {
    var r = poll(0L, 0L, 10)
    println("r=" + r)
}
```

### Command used

kof run main.kf --target native

### Expected behavior

`r=0` (a libc devolve 0 depois do timeout), ou um diagnóstico de compilação dizendo que `poll` já é uma função do KOF e não pode ser usado como nome de `extern`.

### Actual behavior

`r=null`

### Kof intent and existing idiom

Chamar uma função da libc com `extern`, o idioma documentado para FFI. Não existe sintaxe de apelido, então o nome do `extern` precisa ser o próprio símbolo C.

### Kof contract source

`training/idioms/interop.md`: "The Kof function NAME is the C symbol (no alias syntax)" e "Anything unbindable raises FFI001/FFI002 at the declaration, never a silent stub"; AGENTS.md R6.

### Classification (D-KOF-FIRST Gate 4)

Real bug — valid Kof diverges from Kof's own contract

### Checklist

- [x] I searched existing issues and this is not a duplicate.
- [x] I reproduced this against the latest build.
- [x] The reproducer is valid Kof — I checked `docs/language-reference/` and `training/anti-patterns/fake-idioms.md`, and this is not syntax imported from another language (KOF-first, external-second).
- [x] I read `docs/philosophy.md` ("What Kof Is NOT"). This is a deviation from Kof's documented behavior — not a request to import another language/stack's syntax (Java/Kotlin idioms, HTML/CSS into `kof.ui`, framework layers); those are closed with a pointer to the docs, not fixed.

---

## Issue 2

**Título:** Função do usuário com o mesmo nome de uma função nativa (`writeFile`) nunca é chamada

**Labels:** bug, native

### Summary

Uma função top-level declarada pelo usuário com o nome `writeFile` nunca executa: o KOF chama a função nativa de mesmo nome no lugar dela, sem diagnóstico. No reproduzir abaixo, a mensagem da função do usuário não aparece e o arquivo é criado com o conteúdo passado, ou seja, quem rodou foi a função nativa.

Num projeto real isso só foi percebido porque o arquivo saía com permissão `644` em vez da `600` que a função do usuário aplicava. É a mesma família do §243 (classe do usuário com nome de builtin era ignorada), mas para funções.

Contorno usado: renomear a função (`saveFile`).

### Target

Native

### Kof version

0.6.6

### Operating system

Kali Linux x86_64 (glibc 2.43)

### Minimal reproduction

```kof
writeFile(String path, String content) {
    println("user writeFile called")
}

main() {
    writeFile("/tmp/kof-shadow-test.txt", "hello")
    println("done")
}
```

### Command used

kof run main.kf --target native

### Expected behavior

```
user writeFile called
done
```

e nenhum arquivo criado; ou um diagnóstico de compilação dizendo que o nome já pertence a uma função nativa.

### Actual behavior

```
done
```

e `/tmp/kof-shadow-test.txt` é criado com o conteúdo `hello`.

### Kof intent and existing idiom

Declarar uma função top-level com o nome que o programa precisa. A declaração do usuário deveria valer, como já vale para classes desde o §243.

### Kof contract source

`docs/bugs-and-gaps/known-bugs.md` §243 (a declaração do usuário vence o builtin; `UserClassShadowsBuiltinE2ETest`); AGENTS.md R6.

### Classification (D-KOF-FIRST Gate 4)

Real bug — valid Kof diverges from Kof's own contract

### Checklist

- [x] I searched existing issues and this is not a duplicate.
- [x] I reproduced this against the latest build.
- [x] The reproducer is valid Kof — I checked `docs/language-reference/` and `training/anti-patterns/fake-idioms.md`, and this is not syntax imported from another language (KOF-first, external-second).
- [x] I read `docs/philosophy.md` ("What Kof Is NOT"). This is a deviation from Kof's documented behavior — not a request to import another language/stack's syntax (Java/Kotlin idioms, HTML/CSS into `kof.ui`, framework layers); those are closed with a pointer to the docs, not fixed.

---

## Issue 3

**Título:** `Map<String, Int>` no native termina com SIGSEGV por volta de 3.650 chaves (JVM funciona)

**Labels:** bug, native

### Summary

No target native, um `Map<String, Int>` derruba o programa com SIGSEGV (exit 139) ao passar de cerca de 3.650 chaves. O mesmo programa no JVM imprime `ok 5000`. `List<String>` com 20.000 itens e 300.000 Strings temporárias funcionam no native, então o problema parece estar no crescimento do `Map`.

Contorno usado: um mapa escrito em KOF sobre `List` e `String.hashCode()`, testado com 20.000 chaves.

### Target

Native

### Kof version

0.6.6

### Operating system

Kali Linux x86_64 (glibc 2.43)

### Minimal reproduction

```kof
main() {
    var m = mapOf<String, Int>()
    var i = 0
    while (i < 5000) {
        m.put("key" + i, i)
        i = i + 1
    }
    println("ok " + m.size)
}
```

### Command used

kof run main.kf --target native

### Expected behavior

`ok 5000` (como no `--target jvm`)

### Actual behavior

Nada é impresso; o processo termina com exit 139 (SIGSEGV). Numa variante que imprime o tamanho a cada 50 inserções (chaves `"chave" + i`), a última linha antes da queda foi `put 3650 size=3651`.

### Kof intent and existing idiom

Contar ocorrências por chave com `Map<K,V>`, a coleção documentada para isso.

### Kof contract source

`training/idioms/collections.md`: "`Map<K,V>` and `Set<T>` have existed since 0.1.0 on the 3 targets (JVM HashMap/HashSet, Native own asm, JS Map/Set)".

### Classification (D-KOF-FIRST Gate 4)

Target divergence — same valid Kof, different behavior across targets

### Checklist

- [x] I searched existing issues and this is not a duplicate.
- [x] I reproduced this against the latest build.
- [x] The reproducer is valid Kof — I checked `docs/language-reference/` and `training/anti-patterns/fake-idioms.md`, and this is not syntax imported from another language (KOF-first, external-second).
- [x] I read `docs/philosophy.md` ("What Kof Is NOT"). This is a deviation from Kof's documented behavior — not a request to import another language/stack's syntax (Java/Kotlin idioms, HTML/CSS into `kof.ui`, framework layers); those are closed with a pointer to the docs, not fixed.

---

## Issue 4

**Título:** `extern` declarado num arquivo que compila depois passa `String` errado para o C nos arquivos que compilam antes (native)

**Labels:** bug, native

### Summary

Num projeto com vários arquivos, um `extern` com parâmetro `String` funciona quando chamado de um arquivo que vem depois da declaração na ordem alfabética, e falha quando chamado de um arquivo que vem antes. No reproduzir, `access("/tmp", 0)` devolve `0` a partir de `main.kf` e `-1` (errno 2, ENOENT) a partir de `a_probe.kf`, mesmo com o caminho literal. Renomear o arquivo do `extern` para `0_ffi.kf`, que passa a vir primeiro, faz as duas chamadas devolverem `0`.

Parece que a conversão `String` → `char*` só é aplicada nos arquivos compilados depois que o `extern` foi visto. Compila sem aviso.

Contorno usado: manter todos os `extern` num arquivo `00_libc.kf`.

### Target

Native

### Kof version

0.6.6

### Operating system

Kali Linux x86_64 (glibc 2.43)

### Minimal reproduction

```kof
// a_probe.kf
class Probe {
    Int check() {
        return access("/tmp", 0)
    }
}
```

```kof
// b_ffi.kf
extern "libc.so.6" access(String path, Int mode): Int
```

```kof
// main.kf
main() {
    println("from main.kf:  " + access("/tmp", 0))
    println("from a_probe:  " + Probe().check())
}
```

### Command used

kof build . --target native --output out && out/Default/Main

### Expected behavior

```
from main.kf:  0
from a_probe:  0
```

### Actual behavior

```
from main.kf:  0
from a_probe:  -1
```

Com `b_ffi.kf` renomeado para `0_ffi.kf`, a saída fica correta.

### Kof intent and existing idiom

Organizar os `extern` de um projeto num arquivo próprio, separado de quem os usa.

### Kof contract source

`training/idioms/interop.md` (Native: `String<->char*` = payload UTF-8 no offset 24). Não encontrei na documentação nenhuma condição sobre a ordem dos arquivos para que um `extern` funcione; AGENTS.md R6 (nunca silencioso).

### Classification (D-KOF-FIRST Gate 4)

Real bug — valid Kof diverges from Kof's own contract

### Checklist

- [x] I searched existing issues and this is not a duplicate.
- [x] I reproduced this against the latest build.
- [x] The reproducer is valid Kof — I checked `docs/language-reference/` and `training/anti-patterns/fake-idioms.md`, and this is not syntax imported from another language (KOF-first, external-second).
- [x] I read `docs/philosophy.md` ("What Kof Is NOT"). This is a deviation from Kof's documented behavior — not a request to import another language/stack's syntax (Java/Kotlin idioms, HTML/CSS into `kof.ui`, framework layers); those are closed with a pointer to the docs, not fixed.
