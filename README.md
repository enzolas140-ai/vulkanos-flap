# VulkanOS

Projeto de sistema operacional Linux para PC e para o futuro console próprio VulkanOS.

## VulkanOS PC Edition

A primeira versão pública de testes é a **VulkanOS PC Alpha 0.1**. Por enquanto, ela continua sendo, de forma transparente, um **Debian 13 (Trixie) enxuto e personalizado**, com XFCE e ferramentas voltadas a jogos.

- [Baixar a primeira Alpha pública](https://github.com/enzolas140-ai/vulkanos-flap/releases/tag/v0.1.0-alpha.1)
- [Fontes e instruções de build](pc-edition/)
- [Compilação da ISO](https://github.com/enzolas140-ai/vulkanos-flap/actions/workflows/build-vulkanos-pc.yml)

### Nova interface VulkanOS

A próxima build adiciona um dashboard experimental inspirado em interfaces de consoles:
- Menu lateral para Biblioteca, Emuladores, Navegador, Steam, Configurações e Sobre.
- Cartões para abrir Steam, RetroArch, ES-DE, Hydra Launcher e Firefox.
- Lista jogos Steam instalados e ROMs encontradas nas pastas do usuário.
- Indicadores de rede, controle detectado, Bluetooth e bateria quando disponíveis.
- Atalhos de teclado para navegação, pesquisa e retorno à área de trabalho.

O dashboard não substitui o ES-DE: ele funciona como tela inicial e abre o ES-DE como biblioteca de emulação. O mapeamento universal de controles ainda não está implementado; o status de controle é apenas uma detecção básica do dispositivo pelo Linux.

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
