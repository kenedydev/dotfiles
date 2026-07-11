# dotfiles

Personal configuration files, scripts, and system resources for my Arch Linux
setup. Each top-level directory groups the files for one tool or concern, and
the repo is the single source of truth. See each section below for how to
install its files.

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

| File             | Installed to                    | Purpose                                      |
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

---

## Root snapshots (`rootsnap/`)

`rootsnap` backs up the EFI partition and then takes a read-only Btrfs snapshot
of the root subvolume. Retention keeps the last 7 snapshots, plus one per day
for 7 days and one per week for 7 weeks. Only the root subvolume is snapshotted,
so nested subvolumes (e.g. `/home`) are not included.

**Requires:** a Btrfs root, an ESP mounted at `/efi`, a subvolume mounted at
`/.snapshots`, and `rsync` + `btrfs-progs`. Must run as root. Snapshots are
created under `/.snapshots`; the EFI backup is mirrored to `/efi_backup` so it is
captured inside each snapshot.

### Setup

Install it to a system path, then run it whenever you want a snapshot:

```bash
sudo install -Dm755 ~/dotfiles/rootsnap/rootsnap /usr/local/bin/rootsnap
sudo rootsnap -n <name>   # <name> is an optional label, e.g. "manual"
```

It is copied rather than symlinked because it installs to a root-owned system
path and may run before a home directory is mounted, where a symlink into `~`
could dangle. Re-run the install command after editing the script.

### Automatic triggers

These two files trigger a snapshot automatically.

| File               | Installed to                           | Triggers a snapshot             |
| ------------------ | -------------------------------------- | ------------------------------- |
| `90_rootsnap.hook` | `/etc/pacman.d/hooks/90_rootsnap.hook` | Before every pacman transaction |
| `rootsnap.service` | `/etc/systemd/system/rootsnap.service` | Once on each boot               |

```bash
# Snapshot before every pacman transaction
sudo install -Dm644 ~/dotfiles/rootsnap/90_rootsnap.hook /etc/pacman.d/hooks/90_rootsnap.hook

# Snapshot once on each boot
sudo install -Dm644 ~/dotfiles/rootsnap/rootsnap.service /etc/systemd/system/rootsnap.service
sudo systemctl enable rootsnap.service
```
