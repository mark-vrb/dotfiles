# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal macOS dotfiles managed with GNU Stow. Each top-level directory is a "package" whose contents mirror the layout under `$HOME` — Stow symlinks them into place rather than copying.

## Install / apply changes

```bash
./install
```

This creates `~/.config` and `~/.local` if missing, then for each package in `dotdirs` (in `install`) it does `stow -D` (unstow) followed by `stow` (restow) targeting `$HOME`. Restowing is the way to pick up a newly added file in an existing package (e.g. a new file inside `nvim/.config/nvim/`) — a plain re-run of `stow` alone won't create new symlinks for files added after the initial stow in some edge cases, so this script always unstows first.

To add a new tool's config to this repo, follow the existing pattern: create a top-level directory named after the tool, lay out files inside it exactly as they should appear relative to `$HOME` (e.g. `foo/.config/foo/config.yml`, or `foo/Library/Application Support/foo/config.yml` for macOS apps that don't respect XDG on this machine), then add the directory name to the `dotdirs` array in `install` and run `./install`.

Current packages: `tmux`, `nvim`, `bin`, `ghostty`, `starship`, `lazygit`.

Note: `tmp/` at the repo root holds superseded draft scripts (earlier iterations of `bin/.local/scripts/tmux-sesh`) and is not a Stow package — it's not in `dotdirs` and nothing there gets symlinked.

## Theme

Everything in this repo is styled to match Neovim's built-in `default` colorscheme in **light** mode (see `nvim/.config/nvim/lua/config/options.lua`: `background = "light"`, `colorscheme("default")`). The source of truth for the palette is Ghostty's "Nvim Light" theme (`ghostty/.config/ghostty/config`, `theme = Nvim Light`):

| Role | Hex |
|---|---|
| background | `#ffffff` |
| foreground | `#090909` |
| selection background | `#e0e0e0` |
| accent (blue) | `#0000ff` |
| muted/inactive (bright black) | `#a9a9a9` |
| red | `#ff0000` |
| green | `#008000` |
| yellow | `#b8860b` |
| cyan | `#008b8b` |

Conventions established across configs (tmux status bar, lazygit theme, starship prompt):
- Blue is the primary accent for active/selected elements (active pane border, active window, prompt success state) — used as **text**, not as a filled background.
- Muted gray (`#a9a9a9`) is used for filled background badges/highlights instead of a bright accent color — a bright royal blue (`#4169e1`) was tried for status-bar/highlight backgrounds and rejected as too bright for the light theme.
- Red/yellow follow their conventional error/warning semantics (e.g. starship's error symbol and git-status color), matching nvim's `Error`/`WarningMsg` groups.
- Cyan is reserved for syntax-highlighting-like roles (e.g. lazygit's `searchingActiveBorderColor`), not general UI chrome.

When adding color to a new tool's config, derive values from this table rather than hardcoding an unrelated color, and prefer terminal-portable hex (truecolor) over named ANSI colors where the tool supports it, since not everything stowed here runs inside Ghostty with its palette active.

## Neovim config

Minimal, hand-built config requiring **Neovim 0.11+** (uses native `vim.lsp.config`). Full details, key bindings, and rationale for deliberately excluded plugins live in `nvim/.config/nvim/README.md` — read it before making changes there. Highlights:

- `init.lua` just requires `config.options`, `config.keymaps`, `config.lazy` in order.
- `lua/config/lazy.lua` bootstraps `lazy.nvim` on first launch; plugins are declared per-file under `lua/plugins/` (one file per concern: `treesitter.lua`, `lsp.lua`, `completion.lua`, `nav.lua`, `format.lua`, `lint.lua`, `gitsigns.lua`), and `require("lazy").setup("plugins", ...)` auto-loads that whole directory.
- LSP servers are managed via `mason` + native `vim.lsp.config` (not `nvim-lspconfig`'s older setup pattern) — ruby_lsp, basedpyright, rust_analyzer, ts_ls, html, cssls, tailwindcss, astro.
- `rustfmt` is intentionally *not* Mason-managed — it should track the active `rustup` toolchain (`rustup component add rustfmt`).
- `rubocop` is likewise intentionally *not* Mason-managed, for the same reason: it needs to track the per-project Ruby/gem toolchain (rbenv/bundler), not a global always-latest Mason copy. A global Mason `rubocop` can shadow the project's own `rubocop` on `PATH` inside Neovim and crash against older `rubocop-capybara`/`rubocop-rspec` extension gems that assume an older `rubocop` API. Install it per-project instead (`gem install rubocop` under the project's Ruby version, or via its `Gemfile`).
- lazygit is used standalone, outside Neovim, by design — don't add `lazygit.nvim` or wire lazygit into a Neovim keymap.

## tmux

`tmux/.tmux.conf` has `termguicolors`-equivalent truecolor enabled (`terminal-overrides ",*:RGB"`) and status-bar colors are hardcoded hex (not named ANSI colors) so the theme is deterministic regardless of the active terminal palette — see the Theme table above before changing any color there.

## bin

`bin/.local/scripts/tmux-sesh` is a fzf-driven tmux session switcher (searches `~`, `~/Work`, `~/Personal`, `~/Code` for directories). It's stowed via the `bin` package, but nothing in this repo adds `~/.local/scripts` to `PATH` — per the README TODO, that export still needs to be added to `.zshrc`, which isn't tracked here.
