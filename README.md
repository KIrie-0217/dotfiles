# dotfiles

Nix + Home Manager based terminal development environment.

## Quick Start

```bash
# Install Nix (Determinate Systems installer)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Apply (macOS)
cd ~/dotfiles && nix run home-manager -- switch --flake .#iriekos@mac

# Apply (Linux / EC2)
cd ~/dotfiles && nix run home-manager -- switch --flake .#iriekos@linux
```

## Tools

| Tool | Install | Config | Role |
|------|---------|--------|------|
| wezterm | brew (cask) | Nix (config only) | Terminal emulator + tab management |
| zellij | Nix | Nix | Terminal multiplexer (pane splitting) |
| yazi | Nix | Nix | TUI file manager |
| neovim | Nix | Nix | Editor (focused, no file tree) |
| lazygit | Nix | Nix | Git TUI |
| fzf | Nix | Nix | Fuzzy finder (shell history, file search) |
| fd | Nix | Nix | Fast file finder (fzf backend) |
| delta | Nix | Nix | Git diff viewer |
| bat | Nix | Nix | File previewer (cat replacement) |

## Config Index

```
dotfiles/
├── flake.nix                      # Nix flake (inputs + homeConfigurations)
├── home.nix                       # Home Manager (packages + config links)
└── config/
    ├── wezterm/wezterm.lua         # Tab bar, theme, font
    ├── zellij/
    │   ├── config.kdl             # Keybindings, theme
    │   └── layouts/               # Tab layouts (dev-claude, dev-git-claude, etc.)
    ├── scripts/
    │   ├── zj                     # Zellij launcher (git-aware layout, dynamic tab name)
    │   └── zj-tab                 # New tab creator (fzf dir + agent selection)
    ├── yazi/yazi.toml             # File manager settings
    └── nvim/
        ├── init.lua               # Entry point, options
        └── lua/
            ├── plugins.lua        # lazy.nvim plugin list + setup
            ├── keymap_vanila.lua  # Core keymaps (Astarte layout)
            ├── keymap_plugins.lua # Plugin keymaps
            ├── lsp_config.lua     # Mason + LSP setup
            └── colorscheme.lua    # Catppuccin Mocha
```

## Design Principles

- **Tool separation**: wezterm = tabs, zellij = panes, yazi = files, nvim = editing
- **Reproducible**: `home-manager switch` rebuilds the entire environment
- **Portable**: same config works on macOS and Linux (EC2)
- **Minimal nvim**: no file tree, no fuzzy finder, no terminal — those are external tools

## Keybindings

### wezterm

| Key | Action |
|-----|--------|
| `Shift+Cmd+D` | New tab |
| `Shift+Cmd+Plus` | Increase font size |
| `Shift+Cmd+Minus` | Decrease font size |
| `Shift+Left/Right` | Move cursor by word |
| `Shift+Backspace` | Delete previous word |

### nvim (Astarte layout)

Movement keys are remapped for the [Astarte](http://cognitom.github.io/astarte/) keyboard layout.

| Key | Action | Note |
|-----|--------|------|
| `k` | Left | replaces `h` |
| `t` | Down | replaces `j` |
| `n` | Up | replaces `k` |
| `s` | Right | replaces `l` |
| `K` | Go to line start | `^` |
| `S` | Go to line end | `$` |
| `Ctrl+a` | Select all | |
| `Esc Esc` | Clear search highlight | |
| `jj` | Exit insert mode | |

### nvim LSP

| Key | Action |
|-----|--------|
| `<leader>a` | Rust code action (rustaceanvim) |

### zellij

| Key | Action |
|-----|--------|
| `Alt n/s/t/k` | Move focus (up/right/down/left, Astarte) |
| `Alt Shift n/s/t/k` | Resize pane |
| `Alt g` | Split right |
| `Alt h` | Split down |
| `Alt w` | Close pane |
| `Alt f` | Toggle fullscreen |
| `Alt e` | Toggle floating panes |
| `Alt a` | New tab (select directory + agent) |
| `Alt [` / `Alt ]` | Previous / next tab |
| `Alt 1-5` | Go to tab N |
| `Alt /` | Enter scroll mode |
| `Alt d` | Detach |
| `Alt q` | Quit |

### zj (Zellij launcher)

```bash
zj              # Start with claude (default), git-aware layout
zj kiro         # Start with kiro
zj claude       # Start with claude (explicit)
```

Tab name is automatically set to the current directory name.
