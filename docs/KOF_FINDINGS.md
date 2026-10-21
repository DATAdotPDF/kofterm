# Achados no KOF 0.6.6 (target native x86_64)

Problemas encontrados durante o desenvolvimento do KofTerm, com reprodução mínima e o contorno
usado no projeto. Escrito para virar issue(s) no repositório central do KOF,
[KofLang/Kof4j](https://github.com/KofLang/Kof4j), com todo o respeito ao trabalho da Mel Santos
e dos contribuidores.

Ambiente: KOF 0.6.6 (release oficial, SHA-256 conferido), Kali Linux x86_64, glibc 2.43,
`kof build --target native`.

---

## 1. `extern` com o nome de um builtin é desviado em silêncio

```kof
extern "libc.so.6" poll(Long fds, Long nfds, Int timeout): Int

main() {
    var r = poll(0L, 0L, 200)
    println("r=" + r)   // imprime "r=null"; r == 0 e r > 0 são falsos
}
```

A chamada vai para o `poll(handle)` de concorrência do KOF, não para a libc. Compila sem aviso.
**Contorno:** `ppoll`. **Sugestão:** erro de compilação (ou aviso) quando um `extern` tem o mesmo
nome de um builtin.

## 2. Função do usuário com o nome de um builtin também é trocada em silêncio

Uma função própria `writeFile(String path, String content)` nunca era executada: o KOF chamava
a função nativa de mesmo nome. Só foi percebido porque o arquivo saía com permissão `644` em vez
de `600`. **Contorno:** renomear para `saveFile` (e `readLines` para `loadLines`, por precaução).
**Sugestão:** a declaração do usuário deveria ter prioridade, ou o compilador deveria recusar.

## 3. `Map<String, V>` derruba o programa por volta de 3.650 chaves

```kof
main() {
    var m = mapOf<String, Int>()
    var i = 0
    while (i < 5000) {
        m.put("chave" + i, i)
        i = i + 1
    }
    println("ok " + m.size)   // native: SIGSEGV (exit 139) perto de 3.650; JVM: "ok 5000"
}
```

`List<String>` com 20.000 itens e 300.000 Strings temporárias funcionam; o problema é só o `Map`.
**Contorno:** um mapa escrito em KOF (`KtIntMap`/`KtTextMap` em `src/model.kf`), com baldes de
`List` e `String.hashCode()`, testado com 20.000 chaves.

## 4. `extern` declarado num arquivo compilado depois passa `String` errado

Projeto com `brain.kf` e `libc.kf` (os arquivos são compilados em ordem alfabética):

```kof
// libc.kf
extern "libc.so.6" access(String path, Int mode): Int

// brain.kf
class Brain {
    Int check() {
        return access("/tmp", 0)   // -1, errno 2 (ENOENT), até com caminho literal
    }
}

// main.kf
main() {
    println(access("/tmp", 0))    // 0, correto
    println(Brain().check())      // -1
}
```

Renomear `libc.kf` para `00_libc.kf` (compila antes) faz `brain.kf` funcionar. **Contorno:**
`src/00_libc.kf`. **Sugestão:** resolver os `extern` antes de gerar código de qualquer arquivo.

---

## Outras observações (não são bugs, mas valem para a documentação)

- `charAt(i)` devolve um caractere, não `String`: `s.charAt(0) == " "` é sempre falso. Usar
  `s.substring(i, i + 1)`.
- Um literal `"\\"` não produz barra invertida.
- `assert(cond, msg)` exige `msg` literal (`PARSE087`).
- Não há constante no nível do arquivo (`val X = 1` fora de função é `PARSE007`); usar
  `static` numa classe.
- `Buffer(U8)` só é aceito dentro de `extern`, não como parâmetro de função comum.
- `kof test` compila um arquivo por vez; com `package` + `--module-root` os testes funcionam,
  mas o `kof build --target native` do mesmo projeto falha com `PKG004`.
- `Map.get` devolve `V?`; o `KtIntMap` do projeto devolve 0 para chave ausente.
