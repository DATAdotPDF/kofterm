# Política de segurança

O KofTerm roda entre você e o seu Bash: ele vê o que você digita. Por isso, segurança e
privacidade são regras do projeto, não detalhes.

## O que o KofTerm promete

- **Nenhuma conexão de rede.** Não há código de rede em `src/`; o CI recusa um PR que tente
  adicionar. Confira você mesmo: dentro do KofTerm, `ls -l /proc/$PPID/fd | grep -c socket`
  mostra `0`.
- **Nada roda sozinho.** Sugestões e receitas só preenchem a linha.
- **Seus dados ficam com você**, em `~/.local/share/kofterm` (pasta 0700, arquivos 0600).
  Senhas digitadas em `sudo` não passam pelo editor do KofTerm e não são gravadas. Linhas com
  cara de segredo (senha, token, chave, `usuario:senha` numa URL) e linhas que começam com
  espaço rodam normalmente, mas não vão para o histórico nem ensinam o modelo.
- **Só o Bash do KofTerm fala com o KofTerm.** O marcador invisível que avisa "o prompt
  voltou" leva um token sorteado a cada início; uma saída qualquer (um arquivo, uma página, um
  programa pedindo senha) não consegue imitá-lo para capturar o que você digita.
- **Testado de verdade.** `kofterm selftest` abre o próprio KofTerm num terminal novo e confere
  sinais, restauração do terminal, saídas enormes e binárias, o marcador e o histórico. O CI roda
  a cada push.
- **Contribuições anonimizadas.** `kofterm contribute --preview` mostra tudo antes de sair da
  máquina; caminhos, nomes, IPs, e-mails e segredos são removidos.

## Versões com suporte

Só a versão mais recente recebe correções de segurança. Veja as
[releases](https://github.com/DATAdotPDF/kofterm/releases).

## Como relatar uma vulnerabilidade

**Não abra uma issue pública.** Use o relato privado do GitHub:
[Security → Report a vulnerability](https://github.com/DATAdotPDF/kofterm/security/advisories/new).
Se não conseguir, mande mensagem privada para o mantenedor no
[LinkedIn](https://www.linkedin.com/in/data-pdf/) ou pelo e-mail data.pedutraferreira@gmail.com.

Conte:

- o que acontece e qual o impacto (vazamento de dados, comando executado sem querer…);
- os passos para reproduzir, a versão (`kofterm version`) e a distribuição;
- se possível, uma sugestão de correção.

Respondemos em **até 5 dias**. Depois da correção, você recebe o crédito no CHANGELOG (se
quiser).

## Fora do escopo

- Falhas no próprio Bash, no `sudo` ou em ferramentas que o KofTerm só explica (`nmap`,
  `tcpdump`…): relate a quem mantém essas ferramentas.
- Comandos que a pessoa decide rodar por conta própria.
