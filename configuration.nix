{ config, pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  nix.nixPath = [
    "/home/tehp/.nix-defexpr/channels"
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/home/tehp/nix-config/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  home-manager.users.tehp = { pkgs, ... }: {

    home.file.".config/i3/config".source = ./i3config;
    home.file.".config/nvim/init.lua".source = ./init.lua;

    home.packages = with pkgs; [
      kitty
      rnix-lsp
      nixfmt
      stylua
      zsh
      rofi
      flameshot
      ranger
      exa
      bat
      ripgrep
      clang
      rust-analyzer
      xclip
      rustc
      rustfmt
      cargo
      git
      killall
      neofetch
      gh
    ];

    programs.git = {
      enable = true;
      userName = "tehp";
      userEmail = "maccraig98@gmail.com";
    };

    programs.zsh = {
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "refined";
      };
      shellAliases = { n = "nvim"; ls = "exa"; cat = "bat"; ranger = "ranger"; rebuild = "nixos-rebuild switch"; b = "cd .."; };
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      initExtra = ''
        export EDITOR="nvim"
      '';
    };

    programs.kitty = {
      enable = true;
      keybindings = {
        "ctrl+c" = "copy_to_clipboard";
        "ctrl+v" = "paste_from_clipboard";
        "ctrl+shift+c" = "copy_or_interrupt";
      };
      extraConfig = ''
        foreground            #E5E9F0
        background            #2E3440
        selection_foreground  none
        selection_background  #3F4758
        url_color             #88C0D0
        cursor                #81A1C1

        # black
        color0   #3B4252
        color8   #4C566A

        # red
        color1   #E06C75
        color9   #E06C75

        # green
        color2   #9EC183
        color10  #9EC183

        # yellow
        color3   #EBCB8B
        color11  #EBCB8B

        # blue
        color4   #81A1C1
        color12  #81A1C1

        # magenta
        color5   #B988B0
        color13  #B988B0

        # cyan
        color6   #88C0D0
        color14  #8FBCBB

        # white
        color7   #E5E9F0
        color15  #ECEFF4

        # Tab bar
        active_tab_foreground   #88C0D0
        active_tab_background   #434C5E
        inactive_tab_foreground #6C7A96
        inactive_tab_background #2E3440
      '';
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
        nvim-lspconfig
        nvim-treesitter
        nvim-cmp
        cmp-nvim-lsp
        lsp-zero-nvim
        plenary-nvim
        onenord-nvim
        vim-sleuth
        gitsigns-nvim
        nvim-navic
        indent-blankline-nvim
        auto-pairs
        nvim-web-devicons
        lualine-nvim
        telescope-nvim
        nvim-tree-lua
      ];
    };

    home.stateVersion = "23.05";
  };

  programs.zsh.enable = true;
  users.extraUsers.tehp = { shell = pkgs.zsh; extraGroups = [ "audio" ]; };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  environment.pathsToLink = [ "/libexec" ];

  services.xserver = {
    desktopManager = { xterm.enable = false; };
    displayManager = { defaultSession = "none+i3"; };
    windowManager.i3 = {
      package = pkgs.i3-gaps;
      enable = true;
      extraPackages = with pkgs; [ dmenu i3status i3lock i3blocks ];
    };
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Vancouver";
  i18n.defaultLocale = "en_CA.UTF-8";

  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  users.users.tehp = {
    isNormalUser = true;
    description = "tehp";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    google-chrome
    zsh
    gnome.gedit
    discord
    spotify
    ckb-next
    pavucontrol
  ];

  hardware.ckb-next.enable = true;

  # sound
  hardware.pulseaudio.enable = true;

  # Don't change if you don't know what you are doing
  system.stateVersion = "23.05";
}
