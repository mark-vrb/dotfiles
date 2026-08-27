# Key bindings quick reference

`Source` says whether the key is defined by this config (**Custom** - grep for it under `lua/`)
or ships with Neovim itself (**Default** - nothing to configure, works in any 0.11+ install).

Shown in Neovim itself via `<leader>?` (see `lua/config/keymaps.lua`), rendered as an aligned
box-drawing table in a floating window.

| Key | Action | Source |
|---|---|---|
| `<leader>?` | Show this table in a floating window (cheat sheet) | Custom |
| `<leader>ff` | Find files | Custom |
| `<leader>fg` | Live grep | Custom |
| `<leader>fb` | Find buffers (MRU) | Custom |
| `<leader>fo` | Recently opened files | Custom |
| `gf` | Go to file path under cursor, or a Rails route's `controller/path#action` (jumps to the `def`); falls back to Telescope find_files pre-filled with it if not directly resolvable | Custom |
| `-` | Open parent directory (oil) | Custom |
| `<leader><leader>` | Toggle last buffer | Custom |
| `[b` / `]b` | Cycle buffers | Custom |
| `<C-w>h/j/k/l` | Move to split left/down/up/right | Default |
| `<C-w>w` | Cycle to next window | Default |
| `<C-w>p` | Jump to previously active window | Default |
| `gd` | Go to definition | Custom |
| `<C-o>` / `<C-i>` | Back / forward through the jumplist (e.g. return from a `gd` jump - works across files) | Default |
| `:jumps` | Show the full jump list | Default |
| `grr` / `gri` / `grt` | References / implementation / type definition | Default *(0.11)* |
| `grn` / `gra` | Rename / code action | Default *(0.11)* |
| `gO` | Document symbols | Default *(0.11)* |
| `K` | Hover docs | Default *(0.11)* |
| `<C-s>` (insert mode) | Signature help, on demand | Default *(0.11)* |
| `"+y` | Yank to system clipboard (visual/normal mode) | Default |
| `<leader>cf` | Format buffer | Custom |
| `[h` / `]h` | Prev/next git hunk | Custom |
| `<leader>hp` / `hs` / `hr` / `hb` | Preview / stage / reset / blame hunk | Custom |
| `<leader>tm` | Mark a tmux pane to run specs in | Custom |
| `<leader>ts` | Run spec for current file (`rake web:spec[...]`) in the marked tmux pane | Custom |
