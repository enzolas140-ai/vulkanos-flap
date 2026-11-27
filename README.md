# VulkanOS

Projeto de sistema operacional Linux para PC e para o futuro console próprio VulkanOS.

## VulkanOS PC Edition

A primeira versão pública de testes é a **VulkanOS PC Alpha 0.1**. Por enquanto, ela continua sendo, de forma transparente, um **Debian 13 (Trixie) enxuto e personalizado**, com XFCE e ferramentas voltadas a jogos.

- [Baixar a primeira Alpha pública](https://github.com/enzolas140-ai/vulkanos-flap/releases/tag/v0.1.0-alpha.1)
- [Fontes e instruções de build](pc-edition/)
- [Compilação da ISO](https://github.com/enzolas140-ai/vulkanos-flap/actions/workflows/build-vulkanos-pc.yml)

### Interface VulkanOS PC

A nova build de teste usa um dashboard experimental inspirado na referência visual do projeto:
- Barra superior com bateria, Wi-Fi e horário; linha separada para cabo/rede, controle e Bluetooth.
- Menu lateral com Biblioteca, Emuladores, Navegador, Steam, Configurações e Sobre.
- Biblioteca com cartões largos, capas Steam em cache quando existirem e artes originais VulkanOS para os sistemas retro.
- Seções de favoritos e jogos recentes, preenchidas conforme os arquivos encontrados no dispositivo.
- Barra inferior com os comandos de controle A/B/X/Y/START.

O dashboard não substitui o ES-DE: ele funciona como tela inicial e abre o ES-DE para a biblioteca de emulação. Há navegação básica por teclado e por controles reconhecidos na interface joystick do Linux (/dev/input/js*); a compatibilidade e o mapeamento não são universais. O teste automático gera também uma captura de prévia 1280×720 no artefato do GitHub Actions.

### O que ainda falta

Ainda não existem o assistente BOOT/VKROMS, modo RUNVK, configuração automática universal de controles, kernel/drivers próprios ou ports específicos. O dashboard é experimental e precisa de testes de inicialização, vídeo, áudio, rede e controles em hardware real. A versão atual continua sendo PC x86-64 (amd64), não ARM.

## VulkanOS Flap — Secret Arcade

Mini game arcade original, inspirado no estilo tap-to-fly, com tema vulcânico VulkanOS.

- Canvas responsivo para PC e celular.
- Controles por toque, clique e teclado.
- Pontuação, colisões e reinício.
- Recorde local salvo no navegador.
- Compartilhamento do resultado.
- Sem dependências externas, sem coleta de dados e sem permissões do Discord.

O workflow .github/workflows/pages.yml publica o jogo no GitHub Pages após push na branch main.

## Licenca da VulkanOS PC Alpha 0.1

A release original `v0.1.0-alpha.1` (a versao anterior ao dashboard experimental) permite testes e compartilhamento gratuito de copias originais e inalteradas, sob a licenca personalizada [LICENSE-ALPHA-0.1.txt](LICENSE-ALPHA-0.1.txt). A licenca cobre somente os materiais originais do projeto VulkanOS; componentes de terceiros mantem suas proprias licencas.
