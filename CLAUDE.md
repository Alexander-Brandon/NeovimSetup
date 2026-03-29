# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a **Neovim configuration** [Package Manager: Lazy.nvim] — all configuration is hand-written.

## Architecture

- **Plugin Management**: Lazy.nvim (auto-bootstrapped in `lua/config/lazy.lua`)
- **Entry point**: `init.lua` — loads `config.lazy`, `config.keymaps`, `config.autocmds`
- **Configuration files**:
  - `lua/config/lazy.lua`: Bootstraps Lazy.nvim, sets leader keys, imports `lua/plugins/`
  - `lua/config/keymaps.lua`: All custom keybindings
  - `lua/config/options.lua`: Editor options
  - `lua/config/autocmds.lua`: Autocommands
  - `lua/plugins/init.lua`: All plugin specs and inline configuration

## Installed Plugins

- `conform.nvim`: Code formatting (`<leader>fm`)
- `which-key.nvim`: Keymap popup hints
- `bufferline.nvim`: Buffer tab bar (shows Harpoon slot index on pinned buffers)
- `nvim-lualine/lualine.nvim`: Statusline
- `saghen/blink.cmp`: Autocompletion (Tab/S-Tab to navigate, CR to accept)
- `fzf-lua`: Fuzzy finder (`<leader>l*`)
- `harpoon` (harpoon2 branch): File navigation (`<leader>h*`)
- `mason.nvim` + `mason-lspconfig.nvim` + `nvim-lspconfig`: LSP auto-install and setup
- `gitsigns.nvim`: Git blame and change signs
- `catppuccin/nvim`: Colorscheme (macchiato flavour)
- `nvim-tree.lua`: File tree sidebar (right side, opens on VimEnter)
- `nvim-web-devicons`: File icons
- `toggleterm.nvim`: Integrated terminal (popup + horizontal; also used for lazygit)
- `nvim-treesitter`: Syntax highlighting

## Key Mappings

- `.` / `,` — BufferLine next/prev buffer
- `<leader>bd` — Close buffer
- `<leader>ha` — Harpoon add file
- `<leader>he` — Harpoon quick menu
- `<leader>h1`–`<leader>h9` — Jump to harpoon slots (which-key shows filename dynamically)
- `<leader>hh` / `<leader>hl` — Harpoon prev/next
- `<leader>lf` — fzf-lua find files
- `<leader>lg` — fzf-lua live grep
- `<leader>lr` — fzf-lua recent files
- `<leader>ls` — fzf-lua search word under cursor
- `<leader>lk` — fzf-lua keymaps
- `<leader>fm` — Format file (conform)
- `<leader>gg` — Open LazyGit (float terminal via toggleterm)
- `<leader>BB` — Toggle nvim-tree
- `<leader>ef/el/eh` — Diagnostic float/next/prev
- `<M-i>` — Toggle popup terminal (float)
- `<M-h>` — Toggle horizontal terminal
- `<C-h/j/k/l>` — Window navigation

## File Structure

```
nvim/
├── init.lua                  # Entry point
├── lazy-lock.json            # Locked plugin versions
├── .stylua.toml              # Stylua formatting config (2 spaces)
└── lua/
    ├── config/
    │   ├── lazy.lua          # Lazy.nvim bootstrap and setup
    │   ├── keymaps.lua       # All keybindings
    │   ├── options.lua       # Editor options
    │   └── autocmds.lua      # Autocommands
    └── plugins/
        └── init.lua          # All plugin specs
```

## When Making Changes

- **Plugin Additions**: Add to `lua/plugins/init.lua` using Lazy spec format
- **Keybindings**: Add to `lua/config/keymaps.lua`
- **Editor Options**: Add to `lua/config/options.lua`
- **Autocommands**: Add to `lua/config/autocmds.lua`
- **Formatting**: Use `<leader>fm` in Neovim to format with conform
- **Git**: All git commands are forbidden — suggest only, never run

## Notes

- The two persistent terminals (`popup_term`, `horizontal_term`) are created in the toggleterm config and exposed as `_G` globals so `keymaps.lua` can toggle them
- LazyGit is spawned as a fresh `Terminal:new()` on each `<leader>gg` call with custom black/neon-green highlight overrides
- `vim` is a Neovim runtime global — undefined variable warnings from the Lua LSP are expected and can be ignored
