{ config, pkgs, ... }:

let
  unstable = import <unstable> { };
  which-key-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "which-key.nvim";
    version = "v3.13.2";
    src = pkgs.fetchFromGitHub {
      owner = "folke";
      repo = "which-key.nvim";
      rev = "6c1584eb76b55629702716995cca4ae2798a9cca";
      sha256 = "sha256-nv9s4/ax2BoL9IQdk42uN7mxIVFYiTK+1FVvWDKRnGM=";
    };
    meta.homepage = "https://github.com/folke/which-key.nvim/";
  };
in
{
  home.packages = with pkgs; [
    actionlint
    fd
    gci
    gofumpt
    golines
    gopls
    gotools
    lua-language-server
    nil
    nixfmt-rfc-style
    stylua
    terraform
    terraform-ls
    tflint
    trivy
    yaml-language-server
    yamlfmt
    yamllint
  ];
  programs = with unstable.pkgs; {
    ripgrep.enable = true;
    neovim = {
      enable = true;
      package = unstable.pkgs.neovim-unwrapped;
      viAlias = true;
      vimAlias = true;
      plugins = [
        # lazy-nix-helper-nvim
        vimPlugins.alpha-nvim
        vimPlugins.catppuccin-nvim
        vimPlugins.cmp_luasnip
        vimPlugins.cmp-buffer
        vimPlugins.cmp-cmdline
        vimPlugins.cmp-nvim-lsp
        vimPlugins.cmp-path
        vimPlugins.conform-nvim
        vimPlugins.FixCursorHold-nvim
        vimPlugins.friendly-snippets
        vimPlugins.FTerm-nvim
        vimPlugins.lazy-nvim
        unstable.pkgs.vimPlugins.lazydev-nvim
        vimPlugins.lualine-nvim
        vimPlugins.neo-tree-nvim
        vimPlugins.neotest
        vimPlugins.neotest-golang
        vimPlugins.noice-nvim
        vimPlugins.nui-nvim
        vimPlugins.nvim-cmp
        vimPlugins.nvim-nio
        # Lazydev is only available in unstable and requires nvim 0.10.0
        vimPlugins.luasnip
        vimPlugins.nui-nvim
        vimPlugins.nvim-lint
        vimPlugins.nvim-lspconfig
        vimPlugins.nvim-notify
        vimPlugins.render-markdown-nvim
        vimPlugins.SchemaStore-nvim
        (vimPlugins.nvim-treesitter.withPlugins (
          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/nvim-treesitter/generated.nix
          plugins: with plugins; [
            bash
            c
            css
            dockerfile
            gitattributes
            gitcommit
            gitignore
            go
            gomod
            gosum
            gowork
            graphql
            hcl
            html
            javascript
            lua
            json
            make
            markdown
            markdown_inline
            nix
            proto
            python
            regex
            sql
            terraform
            typescript
            vimdoc
            yaml
          ]
        ))
        # vimPlugins.nvim-treesitter.withAllGrammars
        vimPlugins.nvim-treesitter-context
        vimPlugins.nvim-treesitter-parsers.terraform
        vimPlugins.nvim-web-devicons
        vimPlugins.persistence-nvim
        vimPlugins.plenary-nvim
        # vimPlugins.project-nvim
        vimPlugins.telescope-file-browser-nvim
        vimPlugins.telescope-fzf-native-nvim
        vimPlugins.telescope-nvim
        vimPlugins.telescope-project-nvim
        vimPlugins.telescope-ui-select-nvim
        vimPlugins.vim-sleuth
        which-key-nvim
      ];
      extraLuaConfig = ''
        vim.g.nix_packages_path = "${pkgs.vimUtils.packDir config.programs.neovim.finalPackage.passthru.packpathDirs}/pack/myNeovimPackages/start"
        require("config/options")
        require("config/autocmds")
        require("config/lazy")
      '';

    };
  };

  home.file.".config/nvim/lua".source = config.lib.file.mkOutOfStoreSymlink ./lua;
}
