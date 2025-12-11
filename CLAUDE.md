# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a dotfiles repository for macOS and Ubuntu that provides a comprehensive development environment setup. It's based on [zoumo/dotfiles](https://github.com/zoumo/dotfiles) with personal customizations. The repository follows a modular, topic-based organization with support for both full and light installation modes.

## Common Commands

### Installation
```bash
# Clone and install (full interactive installation)
git clone https://github.com/dubuqingfeng/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./script/bootstrap

# Or use the dot command directly
dot          # Full installation (default)
dot light    # Light installation (skips Python/Node.js setup)
```

### Maintenance
```bash
# Update dotfiles
cd ~/.dotfiles
git pull origin master
./script/bootstrap

# Update Homebrew packages
brew update
brew upgrade
brew cleanup
```

### Configuration Management
```bash
# Backup application configs with Mackup
mackup backup

# Restore application configs
mackup restore
```

## Architecture

### Directory Structure
```
├── bin/                    # Executable scripts (added to PATH)
│   └── dot                # Main installation controller
├── functions/             # Shell functions (autoloaded by zsh)
├── git/                   # Git configuration
├── os/                    # OS-specific configurations
│   ├── beautify/         # Terminal beautification (Solarized theme, Powerline fonts)
│   ├── macos/            # macOS-specific (Homebrew packages, system defaults)
│   └── ubuntu/           # Ubuntu-specific
├── pkg/                   # Package configurations (modular .zsh files)
│   ├── brewfile/         # Brewfile management
│   ├── git/              # Git aliases and configs
│   ├── go/               # Go configuration
│   ├── java/             # Java configuration
│   ├── mackup/           # Mackup backup config
│   ├── node/             # Node.js configuration
│   ├── python/           # Python/pyenv configuration
│   ├── shell/            # Shell utilities
│   ├── system/           # System aliases/paths
│   └── terminator/       # Terminator config
├── script/                # Installation scripts
│   └── bootstrap         # Main bootstrap entry point
├── vim/                   # Vim configuration
├── zsh/                   # Zsh configuration
└── *.symlink             # Files symlinked to $HOME
```

### Key Components

1. **Symlink System**: All `*.symlink` files are automatically linked to `$HOME` during installation:
   - `vim/vimrc.symlink` → `~/.vimrc`
   - `zsh/zshrc.symlink` → `~/.zshrc`
   - `zsh/zshenv.symlink` → `~/.zshenv`
   - `git/gitignore_global.symlink` → `~/.gitignore_global`

2. **Modular Zsh Configuration**: Zsh loads `.zsh` files from `pkg/` directories in a specific order:
   - `path.zsh` files are loaded first (for PATH configuration)
   - All other `.zsh` files are loaded after Oh My Zsh initialization
   - Files are autoloaded from `functions/` directory

3. **Installation Modes**:
   - **Full installation**: Includes all software packages, Python/Node.js environments, and terminal beautification
   - **Light installation**: Skips Python/Node.js setup, installs only essential packages

4. **OS Detection**: The `pkg/shell/os.sh` script detects the operating system (macOS, Ubuntu, Debian) and adjusts installation accordingly.

### Installation Flow

**Full installation (`dot` or `./script/bootstrap`)**:
1. Install Homebrew (if not present)
2. Install Oh My Zsh (if not present)
3. Create symlinks for all `*.symlink` files
4. Install Homebrew packages (binaries, fonts, apps)
5. Configure macOS system defaults (`os/macos/set-defaults.sh`)
6. Set up Python environment (pyenv, packages)
7. Set up Node.js environment
8. Beautify terminal (Solarized theme, Powerline fonts)

**Light installation (`dot light`)**:
1. Configure macOS system defaults
2. Beautify terminal
3. Install essential Homebrew packages only

### Package Management

- **Homebrew packages** are defined in `os/macos/install.sh` with three categories:
  - `binaries`: Command-line tools
  - `fonts`: Homebrew Cask fonts
  - `apps`: GUI applications
- **Light mode** installs a subset of essential packages
- **AI tools included**: `claude-code`, `codex`, `cursor-cli`

### Configuration Patterns

1. **Topic-based organization**: Each configuration topic (git, python, system) has its own directory in `pkg/`
2. **Path loading order**: `path.zsh` files load before other configuration to ensure PATH is set correctly
3. **Conditional loading**: Some configurations check for command availability before loading
4. **Function autoloading**: Shell functions in `functions/` are automatically available in zsh

### Multi-OS Support

- **macOS**: Full support with Homebrew package management and system defaults
- **Ubuntu/Debian**: Basic support with apt-get package installation
- **OS detection**: Uses `/etc/lsb-release` and other system files to determine OS

### Backup Integration

- **Mackup**: Backs up application configurations to cloud storage (Dropbox, Google Drive, iCloud)
- **Configuration**: `~/.mackup.cfg` defines storage engine and applications to sync
- **Custom configs**: Can be placed in `~/.mackup/` to override defaults

## Development Notes

- The repository is actively maintained with recent commits
- Documentation is primarily in Chinese with some English
- Based on established dotfiles patterns with personal customizations
- Includes modern CLI tools: bat, exa, fzf, ripgrep, fd
- Terminal uses Solarized theme with Powerline fonts for aesthetics
- Supports both Apple Silicon (M1/M2/M3) and Intel Macs