{ pkgs, glipt-pkg, gleeam-code-pkg, ... }:

{
  home.username = "iriekos";
  home.homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/iriekos"
    else "/home/iriekos";

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  # Neovim (plugins + LSP servers managed by Nix)
  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;
    plugins = with pkgs.vimPlugins; [
      # lsp
      nvim-lspconfig
      none-ls-nvim
      plenary-nvim

      # completion
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      lspkind-nvim

      # treesitter
      (nvim-treesitter.withPlugins (p: with p; [
        bash c css gleam go html javascript json lua markdown markdown-inline
        nix python rust toml typescript vue yaml
      ]))

      # ui
      catppuccin-nvim
      lualine-nvim
      nvim-web-devicons
      indent-blankline-nvim
      nvim-cursorline

      # fold
      pretty-fold-nvim
      fold-preview-nvim
      (pkgs.vimUtils.buildVimPlugin {
        pname = "keymap-amend-nvim";
        version = "2024-09-09";
        src = pkgs.fetchFromGitHub {
          owner = "anuvyklack";
          repo = "keymap-amend.nvim";
          rev = "b8bf9d820878d5497fdd11d6de55dea82872d98e";
          hash = "sha256-fjhZLetXo+chDywxukJtuMv15gJgi4c3lwYx+ubOUr4=";
        };
      })

      # git
      gitsigns-nvim
      git-blame-nvim

      # markdown
      render-markdown-nvim

      # ai
      (pkgs.vimUtils.buildVimPlugin {
        pname = "amazonq-nvim";
        version = "0.1.0";
        src = pkgs.fetchFromGitHub {
          owner = "awslabs";
          repo = "amazonq.nvim";
          rev = "9f6d2278042f282feeb74a83a32f554a5ad0ae95";
          hash = "sha256-EoykpuPlck3JCY1dkkt0SBb7vj9miHVVIGi5UboB7lU=";
        };
      })

      # rust
      rustaceanvim
    ];
  };

  # CLI tools
  home.packages = with pkgs; [
    zellij
    yazi
    lazygit
    fzf
    fd
    delta
    bat

    # Languages
    gleam
  ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
    # Gleam tools (from flake inputs) — require Hex downloads that fail in sandboxed Linux builds
    glipt-pkg
    gleeam-code-pkg
  ] ++ [

    # LSP servers
    pyright
    lua-language-server
    vscode-langservers-extracted  # jsonls, cssls, html
    yaml-language-server
    gopls
    rust-analyzer
  ];

  # wezterm: config only on macOS (binary installed via brew)
  xdg.configFile."wezterm/wezterm.lua" = {
    source = ./config/wezterm/wezterm.lua;
    enable = pkgs.stdenv.isDarwin;
  };

  # nvim: config managed here
  xdg.configFile."nvim".source = ./config/nvim;

  # zellij
  xdg.configFile."zellij/config.kdl".source = ./config/zellij/config.kdl;
  xdg.configFile."zellij/layouts".source = ./config/zellij/layouts;

  # yazi
  xdg.configFile."yazi".source = ./config/yazi;

  # hammerspoon: config only on macOS (binary installed via brew)
  home.file.".hammerspoon/init.lua" = {
    source = ./config/hammerspoon/init.lua;
    enable = pkgs.stdenv.isDarwin;
  };

  # zellij launcher (git-aware layout selection)
  home.file.".local/bin/zj" = {
    source = ./config/scripts/zj;
    executable = true;
  };

  # zellij new-tab with layout/dir selection
  home.file.".local/bin/zj-tab" = {
    source = ./config/scripts/zj-tab;
    executable = true;
  };

  # yazi opener (open file in nvim right pane)
  home.file.".local/bin/yazi-open.sh" = {
    source = ./config/scripts/yazi-open.sh;
    executable = true;
  };

  # Kiro CLI autocomplete spec for zj (zellij wrapper)
  home.file.".fig/autocomplete/build/zj.js".source = ./config/fig/zj.js;

  # Source Home Manager session variables (EDITOR, PATH, etc.)
  home.file.".zshenv".text = ''
    . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
  '';

  # Add ~/.local/bin to PATH and set EDITOR
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  home.sessionPath = [ "$HOME/.local/bin" ];
}
