# AGENTS.md

## Overview

This is a Nix + Home Manager based dotfiles repository. All configuration changes are symlinked into the home directory via `home-manager switch`. Security is critical — a single careless commit can expose credentials to the public.

## Security Rules

### Never commit these files or patterns

- **Private keys**: `id_rsa`, `id_ed25519`, `*.pem`, `*.key`, `*.p12`, `*.pfx` (public keys `*.pub` are OK)
- **Credentials and tokens**: `.env`, `.env.*`, files containing `password=`, `token=`, `secret=`, `api_key=`
- **AWS credentials**: `credentials`, `*.aws/credentials`, anything matching AWS key patterns (`AKIA*`, `aws_secret_access_key`)
- **Shell history**: `.bash_history`, `.zsh_history`, `.python_history`, `.mysql_history`, `.psql_history`, `.lesshst`
- **Session and auth data**: cookies, browser profiles, OAuth tokens, `.netrc`
- **OS artifacts**: `.DS_Store`, `Thumbs.db`
- **Nix build outputs**: `result`, `.direnv/`

### What is safe to commit

- Shell configuration (`.zshrc`, `.bashrc`) — but never with inline secrets
- Editor config (`nvim/`, `vim/`)
- Terminal emulator config (`wezterm/`, `zellij/`)
- Git config (`.gitconfig`) — but never with tokens or credentials
- Tool configs (`yazi/`, `hammerspoon/`, `bat/`, `lazygit/`)
- Nix files (`flake.nix`, `home.nix`, `flake.lock`)

### If a config file needs secrets

Separate the secret into a local file that is not tracked:

```bash
# In .zshrc — source a local secrets file
[ -f ~/.secrets/env.sh ] && source ~/.secrets/env.sh
```

The `~/.secrets/` directory must never be committed. Secrets should be stored in the macOS Keychain, `pass`, or a `~/.secrets/` directory with `chmod 600`.

## Security Review Process

### Before every commit

1. Run `git diff --cached` and visually inspect for secrets
2. Check that no new files match the forbidden patterns above
3. Verify `.gitignore` covers any new sensitive file types

### Automated scanning (recommended setup)

Install `git-secrets` or `gitleaks` as a pre-commit hook:

```bash
# Option A: git-secrets
brew install git-secrets
cd ~/dotfiles
git secrets --install
git secrets --register-aws
git secrets --add 'password\s*=\s*.+'
git secrets --add 'token\s*=\s*.+'
git secrets --add 'secret\s*=\s*.+'

# Option B: gitleaks
brew install gitleaks
# Add to .git/hooks/pre-commit:
# gitleaks protect --staged -v
```

### If secrets are accidentally committed

1. **Rotate the credential immediately** — assume it is compromised
2. Remove from git history: `git filter-branch` or `git filter-repo`
3. Force push the cleaned history
4. Notify affected services

## Setup

### Prerequisites

- macOS or Linux
- [Nix](https://nixos.org/) (Determinate Systems installer recommended)
- For macOS GUI apps: [Homebrew](https://brew.sh/) (wezterm, hammerspoon)

### Install

```bash
# 1. Install Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 2. Clone
git clone <repo-url> ~/dotfiles

# 3. Apply
cd ~/dotfiles

# macOS
nix run home-manager -- switch --flake .#iriekos@mac

# Linux
nix run home-manager -- switch --flake .#iriekos@linux

# 4. macOS GUI apps (not managed by Nix)
brew install --cask wezterm hammerspoon
```

### After changes

```bash
cd ~/dotfiles
nix run home-manager -- switch --flake .#iriekos@mac
```

This rebuilds all symlinks. A new shell session may be needed for environment variable changes.

## Architecture

- **Nix flake** (`flake.nix`): defines inputs and home configurations per platform
- **Home Manager** (`home.nix`): declares packages, config file symlinks, environment variables, and PATH
- **Config files** (`config/`): actual dotfiles organized by tool
- **Scripts** (`config/scripts/`): helper scripts installed to `~/.local/bin`

### What Nix manages vs. what it doesn't

| Component | Managed by | Notes |
|-----------|-----------|-------|
| CLI tools (nvim, zellij, yazi, etc.) | Nix | Declared in `home.packages` |
| Config files | Nix (symlinks) | `xdg.configFile` or `home.file` |
| wezterm (app) | Homebrew | Config managed by Nix |
| hammerspoon (app) | Homebrew | Config managed by Nix |
| Environment variables | Nix | `home.sessionVariables` |
| Secrets | **Not managed** | Keep in `~/.secrets/` or macOS Keychain |
