{ pkgs, ... }:

{
  home.username = "iriekos";
  home.homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/iriekos"
    else "/home/iriekos";

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  # CLI tools
  home.packages = with pkgs; [
    neovim
    zellij
    yazi
    lazygit
    fzf
    fd
    delta
    bat
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

  # yazi
  xdg.configFile."yazi".source = ./config/yazi;

  # kiro-editor wrapper script
  home.file.".local/bin/kiro-editor" = {
    source = ./config/scripts/kiro-editor;
    executable = true;
  };

  # Add ~/.local/bin to PATH and set EDITOR
  home.sessionVariables = {
    EDITOR = "$HOME/.local/bin/kiro-editor";
  };
  home.sessionPath = [ "$HOME/.local/bin" ];
}
