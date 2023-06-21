{ config, pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  # nixos-config path required for custom config location
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
      shellAliases = {
        n = "nvim";
        ls = "exa";
        cat = "bat";
        ranger = "ranger";
        rebuild = "sudo nixos-rebuild switch";
        conf = "nvim ~/nix-config/configuration.nix";
        b = "cd ..";
      };
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
      theme = "Nord";
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
