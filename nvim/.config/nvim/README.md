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
    keymaps.lua    -- buffer nav (leader-leader = alternate buffer, [b/]b = cycle)
    lazy.lua       -- plugin manager bootstrap
  plugins/
    treesitter.lua -- syntax/indent: ruby, python, rust, ts/tsx, html, css, astro, ...
    lsp.lua        -- mason + LSP servers: ruby_lsp, basedpyright, rust_analyzer, ts_ls,
                       html, cssls, tailwindcss, astro
    completion.lua -- blink.cmp (LSP/path/snippet/buffer sources, no AI)
    nav.lua        -- telescope (find/grep/MRU buffer switch/changed files) + oil (file explorer)
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

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Find buffers (MRU) |
| `<leader>fo` | Recently opened files |
| `<leader>fc` | Find files changed on this branch (vs `main`/`master`) |
| `-` | Open parent directory (oil) |
| `<leader><leader>` | Toggle last buffer |
| `[b` / `]b` | Cycle buffers |
| `gd` | Go to definition (only custom LSP nav keymap — no built-in default) |
| `grr` / `gri` / `grt` | References / implementation / type definition *(Neovim 0.11 built-in)* |
| `grn` / `gra` | Rename / code action *(Neovim 0.11 built-in)* |
| `gO` | Document symbols *(Neovim 0.11 built-in)* |
| `K` | Hover docs *(Neovim 0.11 built-in)* |
| `<C-s>` (insert mode) | Signature help, on demand *(Neovim 0.11 built-in)* |
| `<leader>cf` | Format buffer |
| `[h` / `]h` | Prev/next git hunk |
| `<leader>hp` / `hs` / `hr` / `hb` | Preview / stage / reset / blame hunk |
