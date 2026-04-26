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
