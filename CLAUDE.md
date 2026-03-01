# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a **NvChad user configuration** for Neovim - a starter/custom config that extends the [NvChad](https://github.com/NvChad/NvChad) framework. NvChad provides the base Neovim distribution with opinionated defaults, theming, and core plugins. This repository customizes and extends it.

### Key Architecture Concepts

- **NvChad Base**: The main framework is imported as a plugin (v2.5 branch) in `init.lua`. It provides defaults for options, keymaps, autocommands, and themes via the `base46` theme system.
- **Plugin Management**: Uses [Lazy.nvim](https://github.com/folke/lazy.nvim) for lazy-loading plugins.
- **Configuration Layers**:
  - `chadrc.lua`: Main config file for NvChad settings (theme, UI modules, etc.)
  - `lua/plugins/init.lua`: Plugin specifications and configuration
  - `lua/configs/`: Individual plugin configuration files
  - `lua/mappings.lua`: Custom keybindings (imports NvChad defaults then adds custom ones)
  - `lua/options.lua`: Editor options (imports NvChad defaults then adds custom ones)
  - `lua/autocmds.lua`: Autocommands (imports NvChad defaults)

### Current Configuration

**Installed Plugins** (beyond NvChad base):
- `conform.nvim`: Code formatting (currently disabled on save, uncomment in `lua/plugins/init.lua` if needed)
- `nvim-lspconfig`: LSP configuration (html, cssls servers enabled)
- `gitsigns.nvim`: Git change signs in editor
- `nvim-tree.lua`: File tree sidebar (positioned on right)
- `toggleterm.nvim`: Integrated terminal with custom multi-terminal support

**Theme**: "doomchad" (see `chadrc.lua`)

**Notable Custom Features**:
- Multi-terminal support in toggleterm with 5 terminals accessible via `<A-1>` through `<A-5>`
- Custom statusline module showing toggleterm instances
- Terminal cycling with `<S-H>` and `<S-L>` in terminal mode
- Horizontal terminal direction with 15-line height

## Common Commands

### Code Formatting

The project uses **Stylua** for Lua code formatting (see `.stylua.toml`):
```bash
cd nvim
stylua . --check        # Check formatting
stylua .                # Format files
```

### Managing Plugins

Plugins are managed through Lazy.nvim (auto-bootstrapped on first Neovim start). To interact with plugins:
- In Neovim: `:Lazy` - opens plugin manager UI
- To update lazy-lock.json: `:Lazy update` in Neovim or manually update versions

## File Structure

```
nvim/
├── init.lua                 # Entry point, bootstraps Lazy and loads configs
├── lazy-lock.json          # Locked plugin versions
├── .stylua.toml            # Stylua formatting config
├── lua/
│   ├── chadrc.lua         # Main NvChad config (theme, UI settings)
│   ├── mappings.lua       # Custom keybindings
│   ├── options.lua        # Editor options
│   ├── autocmds.lua       # Autocommands
│   ├── plugins/
│   │   └── init.lua       # Plugin specs and lazy configs
│   └── configs/
│       ├── lazy.lua       # Lazy.nvim configuration
│       ├── lspconfig.lua  # LSP server setup
│       ├── conform.lua    # Code formatter setup
│       └── toggleterm.lua # Multi-terminal implementation
└── README.md              # Credits
```

## Key Implementation Details

### toggleterm.lua

The toggleterm configuration implements a custom multi-terminal system:
- Supports up to 5 named terminals (accessed via `<A-1>` to `<A-5>`)
- Only one terminal visible at a time
- Terminal cycling in terminal mode with `<S-H>` (previous) and `<S-L>` (next)
- Stores terminal instances in `_G.term_objects` and `_G.terms` with global functions:
  - `_G.toggle_term(idx)`: Toggle terminal by index
  - `_G.toggle_current_term()`: Toggle current active terminal
  - `_G.cycle_next_term()` / `_G.cycle_previous_term()`: Cycle through terminals
  - `_G.create_terminal(idx)`: Ensure terminal exists
  - `_G.toggleterm_current_idx()`: Get current terminal index
  - `_G.toggleterm_instances`: Table of terminal instances (used in statusline)

When modifying toggleterm, be aware that it maintains state across terminal toggles and integrates with the statusline module in `chadrc.lua`.

### chadrc.lua

The config structure must match `nvconfig.lua` from the NvChad UI module ([reference](https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua)). Key sections:
- `M.base46`: Theme and highlight overrides (currently theme: "doomchad")
- `M.ui`: UI customizations including statusline modules

The custom statusline module `terminals` displays active terminal names - it gracefully handles cases where toggleterm isn't loaded yet via `pcall`.

### Neovim Configuration Loading Order

1. `init.lua` runs first
2. Lazy.nvim bootstraps and loads all plugins
3. Theme defaults load from `base46/`
4. `options.lua` loads (extends NvChad defaults)
5. `autocmds.lua` loads (extends NvChad defaults)
6. `mappings.lua` loads via `vim.schedule` (ensures all plugins are loaded, extends NvChad defaults)

## When Making Changes

- **Plugin Additions**: Add to `lua/plugins/init.lua` with Lazy spec format
- **Plugin Config**: Create new file in `lua/configs/` and reference from plugins spec
- **Keybindings**: Add to `lua/mappings.lua` (imports NvChad defaults first)
- **Editor Options**: Add to `lua/options.lua` (imports NvChad defaults first)
- **NvChad Settings**: Modify `lua/chadrc.lua` following the structure referenced in NvChad's UI module
- **Formatting**: Always run `stylua` before committing Lua files

## Lua Diagnostics Notes

The codebase has diagnostics for undefined `vim` global. This is normal for NvChad configs - `vim` is a global provided by Neovim at runtime and not available to static analysis. These warnings can be safely ignored or suppressed in your editor's Lua LSP settings.
