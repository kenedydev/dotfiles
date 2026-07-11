# dotfiles

Personal configuration files, scripts, and system resources for my Arch Linux
setup. Each top-level directory groups the files for one tool or concern, and
everything is symlinked into place from this repository, so the repo stays the
single source of truth and updates are just a `git pull`.

Clone it wherever you like; the commands below assume `~/dotfiles`:

```bash
git clone https://github.com/kenedydev/dotfiles.git ~/dotfiles
```

---

## Neovim (`nvim/`)

A minimal, single-file Neovim config aimed at quick edits in the terminal, with
fast startup and few moving parts. [lazy.nvim][lazy] is bootstrapped
automatically on the first launch, so there is nothing to install by hand.

**Requires:** Neovim ≥ 0.11

| File             | Symlinked to                    | Purpose                                      |
| ---------------- | ------------------------------- | -------------------------------------------- |
| `init.lua`       | `~/.config/nvim/init.lua`       | Settings, keymaps and plugin specs           |
| `lazy-lock.json` | `~/.config/nvim/lazy-lock.json` | Pinned plugin versions (reproducible builds) |

Plugins: [tokyodark][tokyodark] (theme), [fzf-lua][fzf] (fuzzy finder),
[lualine][lualine] (statusline), [snacks][snacks] (QoL) and
[which-key][whichkey] (keymap hints). Leader is `<Space>`.

### Setup

```bash
mkdir -p ~/.config/nvim
ln -sf ~/dotfiles/nvim/init.lua ~/.config/nvim/init.lua
ln -sf ~/dotfiles/nvim/lazy-lock.json ~/.config/nvim/lazy-lock.json
```

Then open `nvim`. On the first run, lazy.nvim clones itself and installs the
plugins. To keep versions frozen and reproducible, commit `lazy-lock.json`
after every `:Lazy update`.

[lazy]: https://github.com/folke/lazy.nvim
[tokyodark]: https://github.com/tiagovla/tokyodark.nvim
[fzf]: https://github.com/ibhagwan/fzf-lua
[lualine]: https://github.com/nvim-lualine/lualine.nvim
[snacks]: https://github.com/folke/snacks.nvim
[whichkey]: https://github.com/folke/which-key.nvim
