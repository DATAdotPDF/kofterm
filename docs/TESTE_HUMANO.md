# Roteiro de teste humano — KofTerm 0.5.0

Até aqui, todo teste do KofTerm foi automático (scripts dentro do `tmux`). Este roteiro é para
uma **pessoa de verdade, numa janela de terminal de verdade**, usar o KofTerm como um cliente
usaria e dizer o que funcionou, o que estranhou e o que faltou.

Tempo estimado: 30 a 40 minutos. Não precisa fazer tudo de uma vez.

**Como anotar:** em cada passo, marque ✅ (funcionou como descrito), ⚠️ (funcionou, mas algo
estranhou) ou ❌ (não funcionou). Nos ⚠️ e ❌, escreva em uma frase o que aconteceu. Print da
tela ajuda muito. Impressões gerais ("achei lento", "não entendi para que serve") também valem.

---

## 0. Preparar (uma vez)

Na janela de terminal da VM (não pelo SSH):

```bash
rm -rf ~/.local/share/kofterm ~/projects/kofterm
```

Isso apaga a cópia de desenvolvimento, o KofTerm instalado e **todo o histórico e aprendizado
dele**, para você começar do zero, como um cliente novo. Se você já usou o KofTerm na VM, o
que você digitou nele também vai embora; se quiser guardar, copie antes
`~/.local/share/kofterm/history`. O KOF, instalado em `~/.local/share/kof`, continua.

```bash
cd ~ && git clone https://github.com/DATAdotPDF/kofterm.git && cd kofterm && ./install.sh
```

| # | Verificar | Resultado |
|---|---|---|
| 0.1 | O `install.sh` termina com "KofTerm 0.5.0 instalado" | |
| 0.2 | `kofterm version` mostra `KofTerm 0.5.0` (se disser "comando não encontrado", feche e abra o terminal) | |
| 0.3 | `kofterm doctor` mostra 53 comandos no índice e nenhum erro | |

## 1. Primeira impressão

```bash
kofterm
```

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| 1.1 | Só abrir | Aparece o seu prompt do Kali, igual ao normal | |
| 1.2 | `echo $KOFTERM` | Mostra `1` (você está dentro do KofTerm) | |
| 1.3 | `ls`, `cd /etc`, `pwd`, `cd ~` | Tudo funciona como num terminal comum, com cores | |
| 1.4 | Digitar algo errado e apagar com Backspace, mover com ← → | A edição responde na hora, sem atraso perceptível | |

## 2. A sugestão em cinza (o coração do projeto)

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| 2.1 | Digite `sudo apt up` e **pare** | Aparece `date` em cinza depois do que você digitou | |
| 2.2 | Aperte **TAB** | A sugestão vira texto normal: `sudo apt update` | |
| 2.3 | Apague a linha (Ctrl-U), digite `git c` e aperte **Ctrl+→** duas vezes | A sugestão é aceita uma palavra por vez | |
| 2.4 | Digite `cat /etc/hostn` | Aparece `ame` em cinza; TAB completa o nome do arquivo | |
| 2.5 | Digite `ls /us` | Aparece `r/`; pastas ganham `/` no fim | |
| 2.6 | Digite `ls --a` | Aparece `ll` (de `--all`, tirado do índice) | |
| 2.7 | Rode `echo meu_teste_1` duas ou três vezes; depois digite só `echo meu` | O KofTerm já sugere `_teste_1` (aprendeu com você) | |

## 3. Contexto e correções

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| 3.1 | Rode `cat /etc/shadow` (vai dar "Permissão negada") e olhe a linha nova, vazia | Aparece em cinza `sudo cat /etc/shadow`. Não precisa rodar | |
| 3.2 | Rode `grpe root /etc/passwd` (erro de digitação proposital) | Na linha vazia seguinte aparece `grep root /etc/passwd` | |
| 3.3 | Repita duas vezes a sequência: `echo primeiro` e depois `echo segundo`. Depois rode só `echo primeiro` | Na linha vazia aparece `echo segundo` (ele entendeu a ordem) | |
| 3.4 | Entre numa pasta com git (`cd ~/kofterm`), rode `git status` | Na linha vazia aparece o próximo passo típico do git | |
| 3.5 | Digite (**sem apertar Enter!**) `rm -rf /` | A linha fica **vermelha** e nada é sugerido. Apague com Ctrl-U | |

## 4. O índice (F1) e o painel (F2)

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| 4.1 | Digite `ls -ld /etc` e aperte **F1** (ou Ctrl+T) | Abre uma tela inteira sobre o `ls`, com "NA SUA LINHA" explicando `-l` e `-d` | |
| 4.2 | Role com ↓ até o fim | Aparecem exemplos e links de leitura | |
| 4.3 | Aperte **Esc** | Volta para a lista do índice | |
| 4.4 | Digite `apagar` na busca | Aparecem `rm`, `>` e `>>` | |
| 4.5 | Aperte **Esc** de novo | Volta exatamente para onde você estava, com `ls -ld /etc` ainda na linha | |
| 4.6 | Aperte **F2** | A tela se divide: embaixo, uma explicação do comando que você está digitando | |
| 4.7 | Com o painel ligado, apague e digite devagar `tar -czvf` | O painel muda a cada letra e explica cada opção | |
| 4.8 | Com o painel ligado, rode `seq 1 60` | Os números rolam só na parte de cima; o painel fica parado | |
| 4.9 | Aperte **F2** para desligar | O painel some e a tela volta inteira | |

## 5. Programas de tela cheia (nunca testados por humano)

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| 5.1 | `vim /tmp/teste.txt`, digite algo, salve e saia (`:wq`) | O vim funciona normalmente e o prompt volta inteiro | |
| 5.2 | `htop` (ou `top`), olhe por uns segundos, saia com `q` | Desenha certo e volta ao prompt sem lixo na tela | |
| 5.3 | `less /etc/passwd`, role, saia com `q` | Funciona normalmente | |
| 5.4 | Com o `htop` aberto, **redimensione a janela** | O htop se ajusta ao novo tamanho | |
| 5.5 | Ligue o painel (F2) e repita o 5.1 | O vim usa só a parte de cima; ao sair, o painel continua lá | |
| 5.6 | `sleep 30` e aperte **Ctrl-C** | O sleep para na hora | |
| 5.7 | `sudo ls /root` e digite a sua senha | A senha não aparece na tela e o comando roda | |

## 6. Sair e voltar

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| 6.1 | `exit` | Volta para o seu terminal normal, sem a tela "bagunçada" | |
| 6.2 | `kofterm` de novo e digite `echo meu` | Ele lembra o que aprendeu (sugere `_teste_1`) | |
| 6.3 | Se você deixou o F2 ligado na última vez | O painel já abre ligado | |
| 6.4 | Feche a janela do terminal com o KofTerm aberto, abra outra e rode `stty -a \| head -3` | Nada estranho (o terminal novo está normal) | |

## 7. Privacidade

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| 7.1 | Fora do KofTerm: `kofterm contribute --preview` | Mostra só padrões genéricos (ou diz que ainda não há padrões repetidos 3 vezes). Nenhum nome de pasta, arquivo seu ou senha | |
| 7.2 | `ls -la ~/.local/share/kofterm` | Pasta `drwx------`, arquivos `-rw-------` | |

## 8. Impressões gerais (texto livre)

- O que você mais gostou?
- O que atrapalhou ou irritou no uso normal?
- Alguma sugestão em cinza apareceu quando você **não** queria?
- O índice explicou de um jeito que um iniciante entende?
- O que você sentiu falta?

---

**Se algo quebrar o terminal:** digite `reset` e Enter (mesmo sem ver as letras). Se o KofTerm
travar, feche a janela; nada no sistema é alterado.

**Como devolver:** cole a tabela preenchida (ou só os ⚠️ e ❌) na conversa, com prints quando
puder. Cada ❌ vira uma correção; cada ⚠️ vira uma discussão.
