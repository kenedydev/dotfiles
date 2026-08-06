# dotfiles

Personal configuration files and scripts.

Clone it wherever you like; the commands below assume `~/dotfiles`:

```bash
git clone https://github.com/kenedydev/dotfiles.git ~/dotfiles
```

---

## Zsh (`zsh/`)

A single-file interactive shell config.

**Requires:** Zsh ≥ 5.7 for the truecolor prompt, and a Nerd Font. Optional: `zsh-autosuggestions`, `zsh-syntax-highlighting` and `zoxide`, each used only when installed.

| File     | Installed to | Purpose               |
| -------- | ------------ | --------------------- |
| `.zshrc` | `~/.zshrc`   | The whole shell setup |

### Setup

```bash
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
```

Whatever is private or particular to one machine goes in `~/.zshrc.local`, ordinary shell sourced at the end when it exists.

---

## Neovim (`nvim/`)

A minimal, single-file Neovim config aimed at quick edits in the terminal, with fast startup and few moving parts. [lazy.nvim][lazy] is bootstrapped automatically on the first launch, so there is nothing to install by hand.

Plugins: [tokyodark][tokyodark] (theme), [fzf-lua][fzf] (fuzzy finder), [lualine][lualine] (statusline), [snacks][snacks] (QoL) and [which-key][whichkey] (keymap hints). Leader is `<Space>`.

**Requires:** Neovim ≥ 0.11

| File             | Installed to                    | Purpose                                      |
| ---------------- | ------------------------------- | -------------------------------------------- |
| `init.lua`       | `~/.config/nvim/init.lua`       | Settings, keymaps and plugin specs           |
| `lazy-lock.json` | `~/.config/nvim/lazy-lock.json` | Pinned plugin versions (reproducible builds) |

### Setup

```bash
mkdir -p ~/.config/nvim
ln -sf ~/dotfiles/nvim/init.lua ~/.config/nvim/init.lua
ln -sf ~/dotfiles/nvim/lazy-lock.json ~/.config/nvim/lazy-lock.json
```

Then open `nvim`. On the first run, lazy.nvim clones itself and installs the plugins. To keep versions frozen and reproducible, commit `lazy-lock.json` after every `:Lazy update`.

[lazy]: https://github.com/folke/lazy.nvim
[tokyodark]: https://github.com/tiagovla/tokyodark.nvim
[fzf]: https://github.com/ibhagwan/fzf-lua
[lualine]: https://github.com/nvim-lualine/lualine.nvim
[snacks]: https://github.com/folke/snacks.nvim
[whichkey]: https://github.com/folke/which-key.nvim

---

## Root snapshots (`rootsnap/`)

`rootsnap` backs up the EFI partition and then takes a read-only Btrfs snapshot of the root subvolume, pruning the older ones. Only the root subvolume is snapshotted, so nested subvolumes (e.g. `/home`) are not included. Snapshots are created under `/.snapshots`; the EFI backup is mirrored to `/efi_backup` so it is captured inside each snapshot. Retention keeps the last 7 snapshots, plus one per day for 7 days and one per week for 7 weeks.

**Requires:** a Btrfs root, an ESP mounted at `/efi`, a subvolume mounted at `/.snapshots`, and `rsync` + `btrfs-progs` + `util-linux`. Must run as root.

### Setup

Install it to a system path, then run `sudo rootsnap --help`:

```bash
sudo install -Dm755 ~/dotfiles/rootsnap/rootsnap /usr/local/bin/rootsnap
```

It is copied rather than symlinked because it installs to a root-owned system path and may run before a home directory is mounted, where a symlink into `~` could dangle. Re-run the install command after editing the script.

### Automatic triggers

These two files trigger a snapshot automatically. A trigger firing less than a minute after the previous snapshot is skipped, so a boot followed by a pacman transaction takes one snapshot, not two.

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

---

## Encrypted files (`bin/cryptfiles`)

`cryptfiles` opens, closes and mirrors the two LUKS volumes holding the encrypted files: `main`, the one in daily use, and `backup`, its mirror. Each holds a Btrfs filesystem with two subvolumes, `@files` for the files and `@snapshots` for the read-only snapshots taken after each mirror.

| Role     | Mapper              | Mounted at            | Snapshots at                     |
| -------- | ------------------- | --------------------- | -------------------------------- |
| `main`   | `cryptfiles_main`   | `~/cryptfiles_main`   | `~/cryptfiles_main/.snapshots`   |
| `backup` | `cryptfiles_backup` | `~/cryptfiles_backup` | `~/cryptfiles_backup/.snapshots` |

**Requires:** Python ≥ 3.9, `cryptsetup`, `btrfs-progs`, `rsync` and `util-linux`. Must run as your own user, not as root, since it calls `sudo` per command. The volumes must already exist, formatted as Btrfs with the `@files` and `@snapshots` subvolumes.

### Setup

Symlink it into a directory on your `PATH`, then run `cryptfiles --help`:

```bash
mkdir -p ~/.local/bin
ln -sf ~/dotfiles/bin/cryptfiles ~/.local/bin/cryptfiles
```

Each role is configured by two environment variables, where `<ROLE>` is `MAIN` or `BACKUP`. Export them from your shell profile (or from a private, uncommitted file that it sources):

| Variable                 | Required | Purpose                                                  |
| ------------------------ | -------- | -------------------------------------------------------- |
| `CRYPTFILES_<ROLE>_UUID` | yes      | UUID of the LUKS block device                            |
| `CRYPTFILES_<ROLE>_KEY`  | no       | Key file to unlock it, prompts for a passphrase if unset |

The UUID is the one of the LUKS block itself, not the one of the Btrfs filesystem inside it. `blkid` on a still locked partition reports the former:

```bash
export CRYPTFILES_MAIN_UUID=$(sudo blkid -s UUID -o value /dev/nvme0n1p1)
```

The device path is derived from the UUID at each run, and a mapper backed by any other block is refused.

---

## File names (`bin/checkname`)

`checkname` reports, or renames, file and directory names that are off the lowercase snake_case convention. Only the paths given are checked, never what a directory holds.

**Requires:** Python ≥ 3.9. Runs as your own user and touches nothing outside the paths given.

### Setup

Symlink it into a directory on your `PATH`, then run `checkname --help` for the convention, the options and the exit status:

```bash
mkdir -p ~/.local/bin
ln -sf ~/dotfiles/bin/checkname ~/.local/bin/checkname
```
