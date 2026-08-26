# nvim config

Minimal, hand-built Neovim config (Neovim 0.11+ required - uses native `vim.lsp.config`).

## Install

```
git clone <this> ~/.config/nvim
nvim
```
`lazy.nvim` bootstraps itself on first launch and installs everything else.

## One manual step: rustfmt

Not installed via Mason on purpose - it should track your active Rust toolchain via rustup,
not a standalone Mason-managed binary:

```
rustup component add rustfmt
```

## Optional: Rails awareness for ruby_lsp

`ruby_lsp` gets model/route/schema awareness with this addon gem in your project's Gemfile:

```ruby
gem "ruby-lsp-rails", group: :development
```

## Layout

```
init.lua
KEYBINDINGS.md  -- key bindings quick-reference table (see below)
lua/
  config/
    options.lua   -- editing/UI options, hardcoded light background + default colorscheme
    keymaps.lua    -- buffer nav (leader-leader = alternate buffer, [b/]b = cycle),
                       <leader>? renders KEYBINDINGS.md as a cheat-sheet popup
    lazy.lua       -- plugin manager bootstrap
  plugins/
    treesitter.lua -- syntax/indent: ruby, python, rust, ts/tsx, html, css, astro, ...
    lsp.lua        -- mason + LSP servers: ruby_lsp, basedpyright, rust_analyzer, ts_ls,
                       html, cssls, tailwindcss, astro
    completion.lua -- blink.cmp (LSP/path/snippet/buffer sources, no AI)
    nav.lua        -- telescope (find/grep/MRU buffer switch) + oil (file explorer)
    format.lua     -- conform.nvim: rubocop, prettier, rustfmt, format-on-save
    lint.lua       -- nvim-lint: rubocop diagnostics separate from formatting
    gitsigns.lua   -- inline hunk signs/preview/stage/reset/blame
```

## Deliberately excluded

- **lazygit / lazygit.nvim** - used as a separate standalone tool, not wired into Neovim.
- **harpoon** - dropped in favor of `<leader>fb` (Telescope buffers, MRU-sorted).
- **bufferline.nvim** - no persistent buffer tab strip; `<leader>fb` / `:ls` on demand instead.
- **diffview.nvim** - PR-level diffing stays in lazygit.
- **OS theme sync** - background is hardcoded to light, not synced to system appearance.

## Key bindings

See [`KEYBINDINGS.md`](./KEYBINDINGS.md) for the full quick-reference table (also viewable
inside Neovim via `<leader>?`).
