# VulkanOS PC Edition — Alpha 0.3

A edição PC do VulkanOS é um sistema Live x86-64 com visual próprio, menu de inicialização, animação de boot e dashboard em tela cheia.

## Experiência de inicialização

1. Ligue o PC pelo pendrive VulkanOS.
2. No menu de boot, escolha **INICIAR VULKANOS LIVE** ou uma das opções **Install** para abrir o instalador gráfico/texto.
3. Ao iniciar o modo Live, o Plymouth mostra o símbolo branco do vulcão com uma pulsação e oscilação suaves.
4. O sistema entra diretamente na sessão VulkanOS, sem tela de senha, e abre o dashboard fullscreen.

A opção Live serve para experimentar o sistema sem instalar no disco. A opção de instalação inicia o instalador do Debian Live; confirme cuidadosamente o disco de destino porque a instalação pode apagar dados.

## Interface e programas

O dashboard traz as páginas Biblioteca, Emuladores, Navegador, Steam, Configurações e Sobre. A imagem inclui Firefox ESR, Steam, RetroArch e cores, ES-DE, Hydra Launcher, AntiMicro, Mesa/Vulkan, MangoHud, GameMode, Bluetooth, NetworkManager, PipeWire e ferramentas do sistema, conforme disponibilidade e compatibilidade dos pacotes.

O **VulkanOS Game Runtime** examina `~/ROMs`, identifica sistemas e inicia os cores RetroArch instalados. A primeira seleção inclui NES, SNES, Game Boy, Game Boy Color, Game Boy Advance e Mega Drive. Os cores são pacotes Debian recompilados para Trixie; os binários Buildroot do Batocera não são copiados para o sistema.

O **Game Center** apresenta jogos Steam, ROMs recentes e atalhos dos sistemas. O **Controller Manager** lista gamepads pela interface Linux evdev, salva metadados dos dispositivos e abre jstest-gtk para teste/calibração e AntiMicro para mapeamento manual de gamepad para teclado/mouse. O RetroArch usa a pilha SDL/udev para entrada direta; a compatibilidade depende do dispositivo e dos drivers.

O **Performance Center** permite habilitar GameMode e MangoHud em ROMs iniciadas pelo runtime, executar diagnóstico Vulkan/OpenGL e abrir o controle de áudio. O Vulkan não é forçado em hardware ou emuladores incompatíveis. Os shaders são configurados no próprio RetroArch.

Jogos/ROMs devem ser adicionados pelo próprio usuário em `~/ROMs`. Nenhum jogo, ROM ou BIOS é distribuído.

## Kernel e arquitetura

Esta edição inclui um **kernel Linux x86-64 compilado pelo projeto**, distribuído como pacote Debian e com configuração VulkanOS para o ambiente Live (initramfs, SquashFS e OverlayFS) e drivers comuns de PC.

O kernel é uma compilação personalizada do Linux; não é um kernel escrito do zero. O ArkOS4Clone é uma base voltada a hardware ARM de consoles portáteis e seu kernel não pode ser usado nesta edição PC. Os dois projetos precisam permanecer separados.

O kernel personalizado não é assinado. Em computadores que exigem componentes de boot assinados, pode ser necessário desativar o Secure Boot no firmware.

## Game Runtime, Game Center e Performance

No terminal:

```bash
vulkanos-game-runtime init
vulkanos-game-runtime scan
vulkanos-game-runtime systems
vulkanos-game-runtime launch ~/ROMs/nes/seu-jogo.nes
```

Configurações por usuário ficam em `~/.config/vulkanos/`. GameMode/MangoHud configurados pelo Performance Center afetam os jogos iniciados pelo runtime. Jogos Steam continuam usando o Steam e suas próprias configurações.

## Controles e periféricos

Teclados e mouses USB/Bluetooth funcionam através da pilha normal de entrada Linux quando o hardware é reconhecido. Controles USB/Bluetooth que são reconhecidos pelo Linux podem ser usados nos aplicativos compatíveis. AntiMicro permite mapear manualmente botões e eixos para teclado/mouse; não é uma garantia de compatibilidade universal. O suporte real depende do controle, Bluetooth, driver, SDL e jogo.

## Build

A imagem é construída em Debian 13 Trixie com live-build. O workflow GitHub Actions:
- valida os scripts, o dashboard e os SVGs;
- gera a arte do menu e o símbolo usado no Plymouth;
- compila o kernel x86-64 como pacote `.deb`;
- constrói a ISO híbrida Live/Installer;
- executa uma verificação de interface em display virtual e publica preview, SHA-256 e detalhes do kernel.

Para compilar manualmente, execute `bash build.sh` como root dentro de um ambiente Debian 13 Trixie com as dependências usadas pelo workflow. A compilação do kernel exige bastante CPU, memória e espaço em disco.

## Estado

**Alpha 0.3 — não estável.** A validação automatizada não substitui testes em hardware físico. Antes de chamar a versão de Release estável, ainda é necessário testar boot BIOS/UEFI, Live, instalação, vídeo, rede, áudio, Bluetooth, controles, suspensão e Steam em PCs reais.

A licença personalizada de avaliação do VulkanOS cobre apenas os materiais originais do projeto. Linux, Debian e os demais componentes de terceiros mantêm suas próprias licenças.
