{ config, pkgs, lib, ...}:

let
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
in {
    home.packages = with pkgs; [
        fd
        gopls
        lua-language-server
        stylua
        terraform-ls
    ];
    programs = with pkgs; {
        ripgrep.enable = true;
        neovim = {
            enable = true;
            viAlias = true;
            vimAlias = true;
            plugins = [
                # lazy-nix-helper-nvim
                vimPlugins.catppuccin-nvim
                vimPlugins.cmp_luasnip
                vimPlugins.cmp-buffer
                vimPlugins.cmp-cmdline
                vimPlugins.cmp-nvim-lsp
                vimPlugins.cmp-path
                vimPlugins.conform-nvim
                vimPlugins.friendly-snippets
                vimPlugins.lazy-nvim
                vimPlugins.lualine-nvim
                vimPlugins.neo-tree-nvim
                vimPlugins.none-ls-nvim
                vimPlugins.nui-nvim
                vimPlugins.alpha-nvim
                vimPlugins.nvim-cmp
                vimPlugins.luasnip
                vimPlugins.nvim-lspconfig
                (vimPlugins.nvim-treesitter.withPlugins (
                    plugins: with plugins; [
                        bash
                        c
                        go
                        gomod
                        gosum
                        gowork
                        javascript
                        lua
                        nix
                        python
                        typescript
                    ]
                ))
                # vimPlugins.nvim-treesitter.withAllGrammars
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
