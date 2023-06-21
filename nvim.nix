{ config, pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];
  home-manager.users.tehp = { pkgs, ... }: {
    home.file.".config/nvim/init.lua".source = ./init.lua;
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
        nvim-lspconfig
        nvim-treesitter
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
        vim-vsnip
        nvim-tree-lua
        comment-nvim

        # nvim-cmp
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
      ];
    };

  };
}

