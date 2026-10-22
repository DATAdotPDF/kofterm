# Post na comunidade Énóis: campos do formulário "Enviar projeto"

Texto pronto para colar, campo por campo. Os limites de caracteres do formulário estão
indicados entre parênteses.

## Título do projeto (até 200)

```
KofTerm: o terminal Linux que te ensina enquanto você usa, feito em KOF
```

## Resumo curto (até 300, aparece no card)

```
Terminal para quem estuda Linux, redes e cibersegurança: explica cada comando enquanto você digita, sugere o resto da linha e entende pedidos em português ("? qual o gateway" → ip r). Open source, 100% offline e escrito em KOF, uma linguagem brasileira.
```

## Descrição do projeto (até 4.000)

```
Quando comecei a estudar redes na Cisco, precisei aprender Bash numa VM Kali, e o terminal só me devolvia um cursor piscando. O KofTerm nasceu para ser o professor paciente que eu queria ao lado do prompt.

O QUE ELE FAZ
• Coluna do índice: enquanto você digita, a lateral explica o comando, cada opção usada, o sudo e até caminhos como /etc/shadow. São 148 comandos e caminhos escritos em português para quem está começando.
• Modo humanizado: digite "? quanto espaço sobrou" e ele sugere df -h. São 124 receitas revisadas, com tolerância a acentos, sinônimos e erros de digitação. Ele nunca inventa comando.
• Sugestão em cinza, como no VS Code: TAB aceita. O modelo aprende com o que você digita, localmente.
• Lê o contexto: "Permissão negada" vira o mesmo comando com sudo; gti vira git; programa que falta vira "sudo apt install" com o pacote certo.
• Funciona como root, depois do sudo -i, sem sudo nas sugestões.

FOCO EM ESTUDO
Receitas de redes e segurança para laboratório: gateway, DNS, portas, nmap na sua rede, tcpdump, firewall, chaves SSH, logs de login, auditoria de SUID. Ferramentas de varredura sempre com o aviso: só na sua rede ou com autorização.

SEGURO POR REGRA
100% offline (o CI recusa código de rede), nada roda sem o seu Enter, comandos perigosos nunca são sugeridos, seus dados ficam em uma pasta 0700. Dá para contribuir com o que o seu modelo aprendeu, anonimizado e revisado por você.

FEITO EM KOF
Tudo é KOF, a linguagem brasileira criada por Mel Santos: o emulador de terminal, o modelo, o instalador e os 75 testes. O que falta na linguagem vira uma biblioteca KOF paralela. No caminho, encontrei e reportei 4 bugs ao compilador. Memória estável em 7,9 MB.

QUERO SUA AJUDA
É open source (GPLv3) e feito para ajudar, cooperar e somar. Não precisa saber KOF: as contribuições mais valiosas são receitas e explicações em português. Tem guia de contribuição, código de conduta e issues "good first issue" esperando por você.
```

## Link do projeto

```
https://datadotpdf.github.io/kofterm/
```

## Link do repositório

```
https://github.com/DATAdotPDF/kofterm
```

## Categoria (até 120)

```
CLI, EDUCAÇÃO, CIBERSEGURANÇA
```

## Tags separadas por vírgula (até 500)

```
linux, bash, terminal, kof, linguagem brasileira, redes, cibersegurança, cisco, kali linux, open source, educação, cli, offline, autocomplete, good first issue
```

## URL da capa

```
https://datadotpdf.github.io/kofterm/cover.png
```

(Funciona depois que o site estiver no ar. Antes disso, use
`https://raw.githubusercontent.com/DATAdotPDF/kofterm/main/site/cover.png`.)

## Endereço na URL

```
kofterm
```
