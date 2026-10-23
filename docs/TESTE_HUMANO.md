# Roteiro de teste humano — KofTerm 0.7.0

Roteiro completo para uma **pessoa de verdade, numa janela de terminal de verdade**, conferir
cada funcionalidade do KofTerm como um aluno usaria. Cada passo diz o que fazer e o que deve
acontecer; você anota o resultado.

**Tempo:** cerca de 90 minutos no total, em blocos independentes. Se tiver pouco tempo, faça só
os passos marcados com ★ (o essencial, cerca de 30 minutos).

**Como anotar:** ✅ funcionou como descrito · ⚠️ funcionou, mas algo estranhou · ❌ não funcionou ·
➖ não se aplica / pulei. Nos ⚠️ e ❌, uma frase sobre o que aconteceu e, se puder, um print.
Impressões ("achei lento", "não entendi") também valem.

**Como devolver:** cole na conversa só as linhas ⚠️ e ❌ (com o número do passo), os prints e as
respostas do bloco Q. Se usou a gravação abaixo, avise: eu leio os logs.

---

## 0. Preparação

Fora do KofTerm (num terminal comum):

```bash
cd ~/kofterm && git pull && ./install.sh
```

Durante o teste, abra o KofTerm sempre gravando. Se algo estranho acontecer, os dois arquivos
mostram exatamente o que entrou e saiu:

```bash
script -q -I /tmp/kt-in.log -O /tmp/kt-out.log -c kofterm
```

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| 0.1 ★ | O `install.sh` termina | Mensagem "KofTerm 0.7.0 instalado" | |
| 0.2 ★ | `kofterm version` | `KofTerm 0.7.0` | |
| 0.3 | `kofterm doctor` | `indice: 148 entradas`, pasta de dados `(pasta 0700, arquivos 0600)`, `bash: true` | |
| 0.4 | `kofterm help` | Lista os subcomandos e as teclas | |
| 0.5 | `kofterm --qualquer-coisa` | Mostra a ajuda; nada quebra | |

## A. Terminal comum (o KofTerm não pode atrapalhar)

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| A.1 ★ | Abrir com o comando do `script` | Linha cinza de boas-vindas no topo, seu prompt do Kali e a coluna do índice à direita | |
| A.2 ★ | `echo $KOFTERM` | `1` | |
| A.3 ★ | `ls --color`, `cd /etc`, `pwd`, `cd -`, `cd ~` | Tudo igual a um terminal comum, com cores | |
| A.4 | `echo "acentuação: ç ã é ü → ✓"` | Os caracteres aparecem certos | |
| A.5 | `seq 1 300` | Rola só na área da esquerda, sem lixo na coluna | |
| A.6 | `cat /etc/passwd \| grep bash \| wc -l` | Pipes funcionam; mostra um número | |
| A.7 | `false; echo $?` e depois `true; echo $?` | `1` e `0` | |
| A.8 | `sleep 3 &` e, depois, `jobs` | O job aparece; ao terminar, o bash avisa | |
| A.9 | `read -p "nome: " n; echo "oi $n"` (digite algo) | O `read` recebe o que você digitou | |
| A.10 | `stty size` | O segundo número é menor que a largura da janela (é a área do Bash) | |

## B. Edição da linha

Digite o texto **sem apertar Enter**, faça a ação e confira a linha.

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| B.1 ★ | `echo abc`, ← ← e digite `X` | `echo aXbc` | |
| B.2 | Home e End | Cursor vai ao início e ao fim | |
| B.3 | Ctrl+← e Ctrl+→ | Pula palavra por palavra | |
| B.4 | Ctrl-W | Apaga a palavra antes do cursor | |
| B.5 | Ctrl-U | Apaga até o início da linha | |
| B.6 | Coloque o cursor no meio e aperte Ctrl-K | Apaga até o fim | |
| B.7 | Delete no meio da linha | Apaga o caractere sob o cursor | |
| B.8 ★ | Rode `echo um`, `echo dois`; depois ↑ ↑ ↓ | Mostra `echo dois`, `echo um`, `echo dois` | |
| B.9 | Digite `echo rascunho`, ↑ e depois ↓ | O rascunho volta | |
| B.10 | Digite `echo rascunho` e aperte Ctrl-L | A tela limpa e `echo rascunho` continua na linha | |
| B.11 ★ | Digite `echo cancelado` e aperte Ctrl-C | A linha fica na tela com `^C` e vem um prompt novo | |
| B.12 | Linha vazia + Ctrl-D | O KofTerm fecha como o `exit` (abra de novo depois) | |
| B.13 | Digite uma linha maior que a largura da área | Quebra na linha de baixo e a edição continua certa | |
| B.14 | Cole um texto com o botão do meio ou Ctrl+Shift+V | O texto entra na linha | |

## C. Sugestão em cinza (ghost text)

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| C.1 ★ | Digite `sudo apt up` e pare | `date` em cinza; TAB completa | |
| C.2 ★ | Digite `cat /etc/hostn` | `ame` em cinza (completa caminho); TAB completa | |
| C.3 | Digite `ls /us` e TAB, depois `sh` e TAB | Caminho vai completando: `/usr/`, `/usr/share/` | |
| C.4 | Rode `echo meu_teste_1` duas vezes; depois digite `echo meu` | Sugere `_teste_1` (aprendeu com você) | |
| C.5 | Com uma sugestão em cinza, aperte → no fim da linha | Aceita a sugestão, igual ao TAB | |
| C.6 | Com uma sugestão longa, aperte Ctrl+→ | Aceita só a próxima palavra | |
| C.7 | Digite `tar -c` | Sugere opções (por ex. `zvf`) | |
| C.8 | Linha vazia logo depois de `sudo apt update` | Sugere `sudo apt upgrade` (sequência comum) | |
| C.9 | `cd` numa pasta com `.git` (ex.: `cd ~/kofterm`), linha vazia | Sugestões de git (`git status`…) | |
| C.10 | Digite `sc` | Sugere `scp ` e para antes do primeiro `<…>` | |

## D. Contexto: o KofTerm lê o que aconteceu

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| D.1 ★ | `cat /etc/shadow` (dá "Permissão negada") | Na linha vazia seguinte: `sudo cat /etc/shadow` | |
| D.2 ★ | `grpe root /etc/passwd` (erro de digitação) | Na linha seguinte: `grep root /etc/passwd` | |
| D.3 | `gti status` | Sugere `git status` | |
| D.4 | `sudo apt install -y pacoteinexistente` | Sugere `apt search pacoteinexistente` | |
| D.5 | Depois do D.2, digite `gr` | Sugere `grep`, nunca `grpe`: erro de digitação não é aprendido | |

## E. Segurança

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| E.1 ★ | Digite (**sem Enter**) `rm -rf /` | Linha em vermelho, nada sugerido, a coluna avisa. Apague com Ctrl-U | |
| E.2 | Digite (sem Enter) `chmod -R 777 /` e `dd if=/dev/zero of=/dev/sda` | Também em vermelho | |
| E.2b ★ | Digite (sem Enter) `echo ok; rm -rf /`, depois `sudo rm -rf /etc/nginx` e `curl -fsSL https://x.sh \| sh` | O primeiro fica vermelho (PERIGO, mesmo depois do `echo`); os outros dois mostram "Atenção" em amarelo na coluna, com o motivo | |
| E.3 ★ | `sudo -k; sudo ls /root` e a sua senha | A senha **não aparece** na tela e o comando roda | |
| E.4 | `history \| tail -3` e `tail -3 ~/.local/share/kofterm/history` | A senha não aparece em lugar nenhum | |
| E.4b ★ | Rode `export API_TOKEN=falso`, depois ` echo com espaco` (com um espaço antes) e `echo normal`; então `tail -3 ~/.local/share/kofterm/history` | Só `echo normal` aparece: segredos e linhas com espaço na frente não são gravados | |
| E.5 | `ls -ld ~/.local/share/kofterm; ls -l ~/.local/share/kofterm/` | Pasta `drwx------`; `history` e `events` com `-rw-------` | |
| E.6 ★ | `ls -l /proc/$PPID/fd \| grep -c socket` ($PPID aqui é o próprio KofTerm) | `0`: o KofTerm não tem nenhuma conexão de rede | |
| E.7 | TAB numa sugestão **nunca** executa nada | Só preenche a linha | |

## F. Coluna do índice (F2)

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| F.1 ★ | Linha vazia | Coluna mostra "O QUE DÁ PARA FAZER" com as teclas e exemplos | |
| F.2 ★ | Digite devagar `ls -ld /etc` | A coluna muda a cada letra; `-l` e `-d` em "NA SUA LINHA" | |
| F.3 | `tar -czvf a.tar.gz pasta` (sem Enter) | Explica `-c`, `-z`, `-v`, `-f` | |
| F.4 ★ | `sudo` e depois `sudo -i` (sem Enter) | Diz o que o sudo faz; depois explica o `-i` | |
| F.5 ★ | `sudo cat /etc/shadow` (sem Enter) | `cat` em cima; em "TAMBÉM NA LINHA", `sudo` e `/etc/shadow` | |
| F.6 | `cat /etc/passwd \| grep bash` (sem Enter) | Explica o comando depois do último `\|` (`grep`) | |
| F.7 | `ip a`, `ip r`, `ip link`, `ip neigh` (um de cada vez) | Cada subcomando tem a sua explicação | |
| F.8 | `ss -tuln` | Explica as quatro opções | |
| F.9 | `cat ~/.ssh/authorized_keys` e `ls /usr/share/wordlists` | Os caminhos aparecem explicados | |
| F.10 | Um comando que não está no índice, ex.: `cowsay oi` | A coluna diz que ainda não conhece e sugere F1 | |
| F.11 ★ | F2 | A coluna some, o terminal ocupa a largura toda (`stty size` mostra a largura cheia) | |
| F.12 | F2 de novo, `exit`, abra o KofTerm outra vez | A coluna volta ligada (a escolha é lembrada) | |
| F.13 | Diminua a janela até ficar estreita | Com pouco espaço, a coluna se esconde sozinha; ao aumentar, volta | |

## G. Busca no índice (F1 / Ctrl+T)

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| G.1 ★ | Digite `ls -ld /etc` e aperte F1 | Abre a busca em tela cheia, já no `ls` | |
| G.2 | Apague e digite `apagar` | Aparecem `rm`, `>`, `>>`… | |
| G.3 | Busque `porta`, `dns`, `senha`, `usuário` | Resultados que fazem sentido (anote os que não) | |
| G.4 | Enter num resultado | Abre o detalhe com opções, exemplos e links | |
| G.5 ★ | Esc até sair | Volta a tela de antes, com a linha intacta | |
| G.6 | Ctrl+T faz o mesmo que F1 | | |

## H. Programas de tela cheia e janela

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| H.1 ★ | `vim /tmp/t.txt`, escreva, `:wq` | O vim usa só a esquerda; ao sair, prompt e coluna intactos | |
| H.2 | `nano /tmp/t.txt`, Ctrl-X | Funciona normalmente | |
| H.3 ★ | `top`, espere 10 s, `q` | Cabe na esquerda; volta sem lixo | |
| H.4 | Com o `top` aberto, redimensione a janela | O `top` se ajusta e a coluna acompanha | |
| H.5 | `less /etc/services`, role com PgDn e `/ssh`, saia com `q` | Funciona normalmente | |
| H.6 | `man ss`, role e saia | Funciona normalmente | |
| H.7 | `sleep 30` e Ctrl-C | Para na hora | |
| H.8 | `ping 10.0.2.2` e Ctrl-C depois de 3 respostas | Para e mostra o resumo | |
| H.9 | `ssh localhost` (se o SSH estiver ligado) e `exit` | A senha/pergunta passa pelo KofTerm normalmente | |

## I. Modo humanizado (`?`)

Digite `?` e o pedido. **Não aperte Enter**: olhe o cinza e a coluna.

| # | Digite | Deve aparecer em cinza | Resultado |
|---|---|---|---|
| I.1 ★ | `? quero instalar o htop` | `sudo apt update && sudo apt install -y htop` | |
| I.2 ★ | `? quanto espaço sobrou no disco` | `df -h` | |
| I.3 | `? procurar arquivo chamado relatorio` | `find . -iname "*relatorio*"` | |
| I.4 | `? compactr pasta fotos` (erro de digitação) | `tar -czvf fotos.tar.gz fotos` | |
| I.5 | `? ACHAR arquivo RELATÓRIO` (maiúsculas e acento) | `find . -iname "*relatorio*"` | |
| I.6 | `? deletar arquivo velho.txt` (sinônimo) | `rm -i velho.txt` (pergunta antes) | |
| I.7 | `? instalo o nmap` (verbo conjugado) | Receita de instalar | |
| I.8 | `? instalar` (sem dizer o quê) | `… install -y <pacote>` e a coluna pede para trocar o `<…>` | |
| I.9 | `? fazer um bolo de chocolate` | "nenhuma receita ainda": ele não inventa | |
| I.10 | `? instalar htop; rm -rf /` | Só a receita de instalar `htop`: nada de `;` nem `rm` no comando | |
| I.11 ★ | Volte ao I.1 e aperte TAB | O comando vira a linha e **nada roda**; a coluna explica o comando | |
| I.12 | Enter | Agora sim roda (pode cancelar a senha com Ctrl-C) | |
| I.13 | Olhe "OUTRAS RECEITAS" na coluna em `? ver portas` | Alternativas que fazem sentido | |
| I.14 ★ | 5 pedidos inventados por você, do seu jeito | Anote o que digitou e o que apareceu. **Os mais valiosos** | |

## J. Root e shells dentro do shell

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| J.1 ★ | Como usuário: `? acessar root` | `sudo -i` | |
| J.2 | Como usuário: `? acessar .cache na pasta root` | `sudo ls -la /root/.cache` | |
| J.3 ★ | Rode `sudo -i` | Prompt de root (`#`), pasta `/root`, KofTerm funcionando | |
| J.4 ★ | Como root: `? acessar .cache na pasta root` | `cd /root/.cache` | |
| J.5 ★ | Como root: `? instalar nmap` | `apt update && apt install -y nmap` (sem sudo) | |
| J.6 | Como root: `? quem usa a porta 22` | `lsof -i :22` (sem sudo) | |
| J.7 | Como root: `type sudo` | "sudo é uma função" | |
| J.8 | Como root: digite `ls -la` e confira a coluna e o cinza | Tudo funciona como no seu usuário | |
| J.9 ★ | `exit` | Volta ao seu usuário; `? acessar root` volta a dar `sudo -i` | |
| J.10 | `sudo -s` e depois `exit` | Shell de root na pasta atual, com o KofTerm funcionando | |
| J.11 | `bash`, um `?` qualquer, `exit` | Funciona no bash de dentro | |
| J.12 | `sudo su -` e `exit` | Igual ao `sudo -i` | |

## K. Redes e estudos de segurança

Sua VM está na rede NAT `10.0.2.0/24` (veja com `ip -br a`). Use só a sua rede de laboratório.

| # | Digite | Deve aparecer em cinza | Resultado |
|---|---|---|---|
| K.1 ★ | `? qual o gateway` | `ip r` | |
| K.2 | `? qual meu mac` | `ip link` | |
| K.3 ★ | `? ver meu ip` | `ip a` | |
| K.4 | `? qual dns estou usando` | `cat /etc/resolv.conf` | |
| K.5 ★ | `? descobrir ip do site kali.org` | `dig +short kali.org` (rode: deve mostrar IPs) | |
| K.6 | `? caminho até google.com` | `traceroute -n google.com` | |
| K.7 | `? conexões ativas` | `sudo ss -tunp` | |
| K.8 ★ | `? quem usa a porta 22` | `sudo lsof -i :22` | |
| K.9 | `? testar a porta 22 de 10.0.2.15` | `nc -zv 10.0.2.15 22` | |
| K.10 ★ | `? escanear a rede 10.0.2.0/24` | `nmap -sn 10.0.2.0/24` (rode: lista quem responde) | |
| K.11 | `? ver aparelhos da rede local` | `sudo arp-scan --localnet` | |
| K.12 | `? capturar tráfego` | `sudo tcpdump -i any -n` (rode, gere um ping em outra aba, Ctrl-C) | |
| K.13 | `? capturar ping` / `? capturar consultas dns` | `… icmp` / `… port 53` | |
| K.14 | `? ver regras do firewall` | `sudo nft list ruleset` | |
| K.15 | `? criar chave ssh` | `ssh-keygen -t ed25519` | |
| K.16 | `? ligar o ssh` | `sudo systemctl enable --now ssh` | |
| K.17 | `? tentativas de login falhas` | `sudo journalctl -u ssh \| grep -i failed` | |
| K.18 | `? quem usou sudo` | `sudo journalctl _COMM=sudo` (rode: aparecem os seus sudo de hoje) | |
| K.19 | `? listar usuários` / `? usuários humanos` | `cut -d: -f1 /etc/passwd` / `awk …` | |
| K.20 | `? arquivos suid` | `find / -perm -4000 -type f 2>/dev/null` | |
| K.21 | `? hash do arquivo /etc/hosts` | `sha256sum /etc/hosts` | |
| K.22 | `? codificar ola em base64` e `? decodificar b2xh` | `echo -n "ola" \| base64` / `echo "b2xh" \| base64 -d` | |
| K.23 | `? certificado do site kali.org` | `openssl s_client -connect kali.org:443` | |
| K.24 | `? serviços rodando` / `? ver discos` / `? mensagens do kernel` | `systemctl list-units …` / `lsblk -f` / `sudo dmesg -T …` | |
| K.25 ★ | Pedidos tirados do seu curso da Cisco (comandos que o curso pede) | Anote os que não acertaram: viram receitas novas | |

## K2. Programas que faltam

Quando um programa não está instalado, o KofTerm mostra como baixar o que falta e explica na
coluna. Nada é instalado sem você apertar Enter.

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| K2.1 ★ | Digite (sem Enter) `ufw status` | Coluna: "⚠ ufw não está instalado" e "Para baixar o que falta, use: » sudo apt install ufw" | |
| K2.2 ★ | Rode `ufw status`. O próprio Kali pode perguntar "Você deseja instalá-lo? (N/s)": responda **N** | Na linha vazia aparece `sudo apt install ufw` em cinza e a coluna explica | |
| K2.3 | TAB na linha do K2.2 | O comando vira a linha; **nada roda** até o Enter | |
| K2.4 | Rode `cowsay oi` (programa fora do índice; o Kali não diz o pacote) | Cinza `apt search cowsay`: procura o nome do pacote | |
| K2.5 | Digite (sem Enter) `cowsay oi` de novo | A coluna avisa que não está instalado | |
| K2.6 | Digite `dig kali.org` (já instalado) | **Nenhum** aviso de "não instalado" | |
| K2.7 | Como root (`sudo -i`): rode `ufw status` (N) | Cinza `apt install ufw` (sem sudo) | |
| K2.8 | Rode o `sudo apt install ufw` do K2.3 e digite `ufw status` de novo | O aviso some | |
| K2.9 | Rode `sl` | Sugere `ls` (letras trocadas) | |

## L. Aprendizado e contribuição

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| L.1 | Rode `ip -br a` três vezes; depois digite `ip -b` | Sugere `r a` (aprendeu) | |
| L.2 | `kofterm contribute --preview` | Mostra o que seria enviado: comandos genéricos, **sem** seus nomes de pastas, IPs, usuário ou máquina. Anote qualquer dado pessoal que aparecer | |
| L.3 | Confira o fim do L.2 | Diz que nada foi gravado | |

## M. Desempenho

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| M.1 | Digite rápido uma linha longa e um `?` longo | Sem atraso perceptível entre tecla e tela | |
| M.2 | `grep VmRSS /proc/$PPID/status` | Anote o valor (esperado: perto de 8 MB) | |
| M.3 | Deixe o `top` rodando 3 minutos, saia e repita o M.2 | Quase o mesmo valor (sem vazamento) | |
| M.4 | `yes \| head -200000` | Termina em poucos segundos e o KofTerm continua respondendo | |

## N. Saída e recuperação

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| N.1 ★ | `exit` | A tela de **antes** de abrir o KofTerm volta (como no vim) | |
| N.2 | Feche a janela com o KofTerm aberto; abra outra e rode `stty -a \| head -3` | Nada estranho; `pgrep -a kofterm` não mostra processos esquecidos | |
| N.3 | No terminal de fora: `kofterm < /dev/null` | Mensagem "a entrada padrão não é um terminal", sem travar | |
| N.4 ★ | No terminal de fora: `kofterm selftest` | Cerca de 30 s de linhas `ok`, termina com "19 ok, 0 falharam"; nenhuma pasta `/tmp/kofterm-selftest-*` fica para trás | |
| N.5 | Dentro do KofTerm: `printf '\033]7770;0;1000;/tmp\007'; read -r x`, digite `teste123` e Enter; depois `grep -c teste123 ~/.local/share/kofterm/history` | O `read` termina normalmente e o grep mostra `0` (um marcador falso não captura o que você digita) | |

## P. Instalação (opcional, no fim)

| # | Fazer | Deve acontecer | Resultado |
|---|---|---|---|
| P.1 | `kofterm uninstall` | Remove o programa; `history` e `events` continuam em `~/.local/share/kofterm` | |
| P.2 | `cd ~/kofterm && ./install.sh` | Instala de novo; o que você ensinou continua (C.4 ainda sugere) | |

## Q. Impressões gerais (texto livre)

1. A coluna à direita ajudou ou atrapalhou? A largura está boa?
2. As explicações do índice são claras para quem está começando? Alguma ficou difícil?
3. O modo `?` entendeu o seu jeito de pedir? Que pedidos você esperava que funcionassem?
4. Que comandos ou caminhos do seu curso (Cisco, redes, Linux) faltam no índice?
5. Algo ficou lento, piscou ou deixou lixo na tela?
6. Você usaria o KofTerm no dia a dia de estudo? O que falta para isso?

---

**Se algo quebrar o terminal:** digite `reset` e Enter (mesmo sem ver as letras). Se o KofTerm
travar, feche a janela; nada no sistema é alterado.
