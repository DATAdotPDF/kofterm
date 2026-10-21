# Roteiro de teste humano — KofTerm 0.6.1

Este roteiro é para uma **pessoa de verdade, numa janela de terminal de verdade**, usar o
KofTerm como um cliente usaria e dizer o que funcionou, o que estranhou e o que faltou.
A versão 0.6 traz duas novidades grandes, pedidas no primeiro teste humano (a 0.6.1 corrige o que o segundo teste achou):

- **o índice numa coluna à direita** (F2), que nunca cobre o terminal;
- **o modo humanizado**: `? quero instalar o htop` vira o comando.

Tempo estimado: 40 minutos. Não precisa fazer tudo de uma vez.

**Como anotar:** em cada passo, marque ✅ (funcionou como descrito), ⚠️ (funcionou, mas algo
estranhou) ou ❌ (não funcionou). Nos ⚠️ e ❌, escreva em uma frase o que aconteceu. Print da
tela ajuda muito. Impressões gerais ("achei lento", "não entendi para que serve") também valem.

**Gravando para análise:** abra o KofTerm sempre assim durante o teste. Se algo estranho
acontecer, os dois arquivos mostram exatamente o que entrou e saiu:

```bash
script -q -I /tmp/kt-in.log -O /tmp/kt-out.log -c kofterm
```

---

## 0. Atualizar (uma vez)

Você já tem o KofTerm instalado e o repositório em `~/kofterm`. Fora do KofTerm:

```bash
cd ~/kofterm && git pull && ./install.sh
```

| # | Verificar | Resultado |
|---|---|---|
| 0.1 | O `install.sh` termina com "KofTerm 0.6.1 instalado" | |
| 0.2 | `kofterm version` mostra `KofTerm 0.6.1` | |
| 0.3 | `kofterm doctor` mostra 53 comandos no índice e nenhum erro | |

## 1. Primeira impressão

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| 1.1 | Abrir com o comando do `script` acima | Aparece o seu prompt do Kali, igual ao normal | |
| 1.2 | `echo $KOFTERM` | Mostra `1` | |
| 1.3 | `ls`, `cd /etc`, `pwd`, `cd ~` | Tudo funciona como num terminal comum, com cores | |
| 1.4 | Digitar, apagar com Backspace, mover com ← → | A edição responde na hora | |

## 2. A coluna do índice (F2) — a principal novidade

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| 2.1 | Só abrir o KofTerm | No topo, uma linha cinza com as teclas; à direita, a coluna do índice já ligada, com "O QUE DÁ PARA FAZER" (se não aparecer, aperte **F2**) | |
| 2.2 | Digite devagar `ls -ld /etc` | A coluna muda a cada letra e explica `-l` e `-d` em "NA SUA LINHA" | |
| 2.3 | Digite `tar -czvf` | A coluna explica cada opção do `tar` | |
| 2.4 | Rode `seq 1 100` | Os números rolam só na esquerda; a coluna fica parada | |
| 2.5 | Rode `stty size` | O segundo número é menor que a largura da janela (é a área do Bash) | |
| 2.6 | Aperte **F2** de novo | A coluna some e o terminal volta a ocupar a largura toda | |
| 2.7 | Ligue de novo (F2), saia (`exit`) e abra o KofTerm outra vez | A coluna já abre ligada | |

## 3. Programas de tela cheia com a coluna ligada

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| 3.1 | `vim /tmp/teste.txt`, escreva algo, salve e saia (`:wq`) | O vim usa só a esquerda; ao sair, o prompt e a coluna estão lá | |
| 3.2 | `top`, olhe por uns segundos, saia com `q` | Cabe na esquerda e volta ao prompt sem lixo | |
| 3.3 | Com o `top` aberto, **redimensione a janela** | O `top` se ajusta e a coluna acompanha | |
| 3.4 | `less /etc/passwd`, role, saia com `q` | Funciona normalmente | |
| 3.5 | `nano /tmp/teste.txt` e saia com Ctrl-X | Funciona normalmente | |
| 3.6 | `sleep 30` e **Ctrl-C** | O sleep para na hora | |
| 3.7 | `sudo ls /root` e a sua senha | A senha não aparece e o comando roda | |

## 4. O modo humanizado (`?`) — a outra novidade

Digite `?` e, depois, o que você quer fazer, **com as suas palavras**. Não aperte Enter ainda:
olhe o texto em cinza e a coluna da direita.

| # | Digite | Deve aparecer em cinza | Resultado |
|---|---|---|---|
| 4.1 | `? quero instalar o htop` | `sudo apt update && sudo apt install -y htop` | |
| 4.2 | `? quanto espaço sobrou no disco` | `df -h` | |
| 4.3 | `? procurar arquivo chamado relatorio` | `find . -iname "*relatorio*"` | |
| 4.4 | `? compactr pasta fotos` (com erro de digitação) | `tar -czvf fotos.tar.gz fotos` | |
| 4.5 | `? apagar pasta lixo` | `rm -ri lixo` (pergunta antes de apagar) | |
| 4.6 | `? fazer um bolo de chocolate` | "nenhuma receita ainda" — ele não inventa | |
| 4.7 | Volte ao 4.1 e aperte **TAB** | O comando vira a linha; **nada roda**. A coluna passa a explicar o comando | |
| 4.8 | Aperte **Enter** | Agora sim o comando roda (pode cancelar a senha do sudo com Ctrl-C) | |
| 4.9 | `? acessar root` | `sudo -i` (o que falhou no teste anterior) | |
| 4.10 | Rode `sudo apt install -y claude` (pacote que não existe) e olhe a linha vazia seguinte | Sugere `apt search claude` | |
| 4.11 | Invente 5 pedidos seus, do jeito que você falaria | Anote quais acertaram e quais não. **Esses são os mais valiosos** | |

## 5. A sugestão em cinza e o contexto

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| 5.1 | Digite `sudo apt up` e pare | Aparece `date` em cinza; TAB completa | |
| 5.2 | Digite `cat /etc/hostn` | Aparece `ame`; TAB completa | |
| 5.3 | Rode `echo meu_teste_1` duas vezes; depois digite `echo meu` | Sugere `_teste_1` | |
| 5.4 | Rode `cat /etc/shadow` ("Permissão negada") e olhe a linha nova | Sugere `sudo cat /etc/shadow` | |
| 5.5 | Rode `grpe root /etc/passwd` | Na linha vazia seguinte sugere `grep root /etc/passwd` | |
| 5.6 | Digite (**sem Enter**) `rm -rf /` | A linha fica vermelha, nada é sugerido e a coluna avisa. Apague com Ctrl-U | |
| 5.7 | Digite `ls` e aperte **TAB** | Anote: o TAB fez o que você esperava? | |

## 6. Busca no índice (F1)

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| 6.1 | Digite `ls -ld /etc` e aperte **F1** (ou Ctrl+T) | Abre a busca em tela cheia, no `ls` | |
| 6.2 | Esc, digite `apagar` | Aparecem `rm`, `>` e `>>` | |
| 6.3 | Esc de novo | Volta para a tela de antes, com a linha intacta | |

## 7. Sair

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| 7.1 | `exit` | A tela de **antes** de abrir o KofTerm volta (como no `vim`) | |
| 7.2 | Feche a janela com o KofTerm aberto, abra outra e rode `stty -a \| head -3` | Nada estranho | |

## 8. Impressões gerais (texto livre)

- A coluna à direita ajudou ou atrapalhou? Largura boa?
- O modo `?` entendeu o seu jeito de pedir?
- Algo ficou lento em algum momento?
- O que você sentiu falta?

---

**Se algo quebrar o terminal:** digite `reset` e Enter (mesmo sem ver as letras). Se o KofTerm
travar, feche a janela; nada no sistema é alterado.

**Como devolver:** cole a tabela preenchida (ou só os ⚠️ e ❌) na conversa, com prints quando
puder, e avise se usou o `script` para eu ler os logs.
