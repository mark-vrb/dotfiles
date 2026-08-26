# nvim config

Minimal, hand-built Neovim config (Neovim 0.11+ required — uses native `vim.lsp.config`).

## Install

```
git clone <this> ~/.config/nvim
nvim
```
`lazy.nvim` bootstraps itself on first launch and installs everything else.

## One manual step: rustfmt

Not installed via Mason on purpose — it should track your active Rust toolchain via rustup,
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
lua/
  config/
    options.lua   -- editing/UI options, hardcoded light background + default colorscheme
    keymaps.lua    -- buffer nav (leader-leader = alternate buffer, [b/]b = cycle),
                       <leader>? cheat-sheet popup of this table
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

- **lazygit / lazygit.nvim** — used as a separate standalone tool, not wired into Neovim.
- **harpoon** — dropped in favor of `<leader>fb` (Telescope buffers, MRU-sorted).
- **bufferline.nvim** — no persistent buffer tab strip; `<leader>fb` / `:ls` on demand instead.
- **diffview.nvim** — PR-level diffing stays in lazygit.
- **OS theme sync** — background is hardcoded to light, not synced to system appearance.

## Key bindings quick reference

`Source` says whether the key is defined by this config (**Custom** — grep for it under `lua/`)
or ships with Neovim itself (**Default** — nothing to configure, works in any 0.11+ install).

| Key | Action | Source |
|---|---|---|
| `<leader>?` | Show this table in a floating window (cheat sheet) | Custom |
| `<leader>ff` | Find files | Custom |
| `<leader>fg` | Live grep | Custom |
| `<leader>fb` | Find buffers (MRU) | Custom |
| `<leader>fo` | Recently opened files | Custom |
| `-` | Open parent directory (oil) | Custom |
| `<leader><leader>` | Toggle last buffer | Custom |
| `[b` / `]b` | Cycle buffers | Custom |
| `<C-w>h/j/k/l` | Move to split left/down/up/right | Default |
| `<C-w>w` | Cycle to next window | Default |
| `<C-w>p` | Jump to previously active window | Default |
| `gd` | Go to definition | Custom |
| `<C-o>` / `<C-i>` | Back / forward through the jumplist (e.g. return from a `gd` jump — works across files) | Default |
| `:jumps` | Show the full jump list | Default |
| `grr` / `gri` / `grt` | References / implementation / type definition | Default *(0.11)* |
| `grn` / `gra` | Rename / code action | Default *(0.11)* |
| `gO` | Document symbols | Default *(0.11)* |
| `K` | Hover docs | Default *(0.11)* |
| `<C-s>` (insert mode) | Signature help, on demand | Default *(0.11)* |
| `<leader>cf` | Format buffer | Custom |
| `[h` / `]h` | Prev/next git hunk | Custom |
| `<leader>hp` / `hs` / `hr` / `hb` | Preview / stage / reset / blame hunk | Custom |
