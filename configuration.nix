{ config, pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    <home-manager/nixos>
    ./nvim.nix
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
      lua-language-server
      libnotify
      heroku
      nodejs
      nodePackages.pnpm
      nodePackages.typescript-language-server
      nodePackages.eslint
      nodePackages.vscode-langservers-extracted
      nodePackages.prettier
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
      font.name = "Hack";
    };

    programs.i3status = {
      enable = true;
      general = {
        colors = true;
        color_good = "#e0e0e0";
        color_degraded = "#d7ae00";
        color_bad = "#f69d6a";
        interval = 1;
      };
    };

    home.stateVersion = "23.05";
  };

  programs.zsh.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.kernelModules = [ "amdgpu" ];
  environment.pathsToLink = [ "/libexec" ];

  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    layout = "us";
    xkbVariant = "";
    desktopManager = { xterm.enable = false; };
    displayManager = { defaultSession = "none+i3"; };
    windowManager.i3 = {
      package = pkgs.i3-gaps;
      enable = true;
      extraPackages = with pkgs; [ dmenu i3status i3lock i3blocks ];
    };
    displayManager.setupCommands = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --output DisplayPort-2 --mode 5120x1440 --primary --rate 239.76 --pos 0x1080 --rotate normal --output HDMI-A-0 --mode 1920x1080 --pos 1440x0 --rotate normal
    '';
    xautolock = {
      enable = true;
      locker = "${pkgs.i3lock}/bin/i3lock --color 000000";
      time = 15; # minutes
      enableNotifier = true;
      notify = 30; # seconds before lock
      notifier = "${pkgs.libnotify}/bin/notify-send 'Locking in 30 seconds'";
    };
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Vancouver";
  i18n.defaultLocale = "en_CA.UTF-8";

  users.users.tehp = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "tehp";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
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
    steam
  ];

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "Hack" ]; })
  ];

  programs.steam = {
    enable = true;
    # remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  hardware.ckb-next.enable = true;
  hardware.pulseaudio.enable = true;

  # Don't change if you don't know what you are doing
  system.stateVersion = "23.05";
}
