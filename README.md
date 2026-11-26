# VulkanOS

Projeto de sistema operacional Linux para PC e para o futuro console próprio VulkanOS.

## VulkanOS PC Edition

A primeira versão pública de testes é a **VulkanOS PC Alpha 0.1**. Por enquanto, sendo bem transparente, ela é basicamente um **Debian 13 (Trixie) enxuto e personalizado**, com desktop XFCE e um conjunto inicial de ferramentas para jogos. Ainda não é uma distribuição independente nem a experiência final do console.

- [Baixar VulkanOS PC Alpha 0.1](https://github.com/enzolas140-ai/vulkanos-flap/releases/tag/v0.1.0-alpha.1)
- [Fontes e instruções de build](pc-edition/)
- [Compilação da ISO](https://github.com/enzolas140-ai/vulkanos-flap/actions/workflows/build-vulkanos-pc.yml)

A Alpha inclui uma base inicial com Firefox ESR, Steam installer, RetroArch, Hydra Launcher, ES-DE, Mesa e AntiMicroX. Ainda faltam o assistente BOOT/VKROMS, modo RUNVK, configuração automática universal de controles, kernel/drivers próprios e ports específicos. A ISO ainda precisa de testes em hardware variado.

## VulkanOS Flap — Secret Arcade

Mini game arcade original, inspirado no estilo tap-to-fly, com tema vulcânico VulkanOS.

- Canvas responsivo para PC e celular.
- Controles por toque, clique e teclado.
- Pontuação, colisões e reinício.
- Recorde local salvo no navegador.
- Compartilhamento do resultado.
- Sem dependências externas, sem coleta de dados e sem permissões do Discord.

O workflow `.github/workflows/pages.yml` publica o jogo no GitHub Pages após push na branch `main`.
