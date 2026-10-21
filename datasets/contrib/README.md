# Contribuições da comunidade para o modelo

Cada arquivo `.kofdata` desta pasta foi gerado por alguém com `kofterm contribute`, revisado
pela própria pessoa e enviado por Pull Request. O KofTerm carrega todos eles ao iniciar, junto
com `corpus/sessions.txt`: é assim que cada versão nova sai com um modelo mais esperto.

## O que tem num `.kofdata`

Só padrões agregados que apareceram pelo menos 3 vezes, já anonimizados na máquina de quem
contribuiu:

```text
# kofterm-contrib v1
L 7 git push origin main                    linha usada 7 vezes
T 4 git status => git add .                 "git add ." veio depois de "git status" 4 vezes
F 5 git git                                 o comando git foi usado 5 vezes numa pasta com .git
L 3 scp <FILE> <USER>@<IP>:<PATH>           o que era pessoal virou marcador
```

Não há datas, ordem real da sessão, nomes de pastas, máquinas ou pessoas. Linhas com cara de
segredo (senha, token, `export X=...`, chaves) são descartadas antes, nunca mascaradas.

## Como contribuir

```bash
kofterm contribute --preview
```
```bash
kofterm contribute
```

Leia o arquivo gerado, copie para esta pasta com um apelido (`datasets/contrib/<apelido>.kofdata`)
e abra um Pull Request. O CI roda `kofterm check` em todos os arquivos e recusa qualquer linha
que não esteja anonimizada.
