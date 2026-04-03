# newVim

Personal Vim setup built around native Vim packages and git submodules.

This repo intentionally uses:

- native Vim packages under `.vim/pack/plugins/{start,opt}`
- git submodules for pinned plugin versions
- `packadd` for optional plugins

It does not use a separate plugin manager.

## Bootstrap

Clone the repo and initialize plugins:

```bash
git clone <repo-url> newVim
cd newVim
git submodule update --init --recursive
```

That gives you the plugin directories tracked by `.gitmodules`.

## Requirements

Base requirements:

- Vim 9.x
- Node.js for `coc.nvim`
- `fzf` binary on `PATH`
- `ripgrep` (`rg`) on `PATH` for content search via FZF

Optional requirements:

- `pdflatex` for LaTeX compilation from Vim
- GitHub Copilot access/subscription for `copilot.vim`
- a Nerd Font or another icon-capable font if you want `vim-devicons` to render correctly

## Layout

Managed plugins live in:

- `.vim/pack/plugins/start`
- `.vim/pack/plugins/opt`

Current optional plugins:

- `copilot.vim`
- `vim-latex`

Everything else that is kept loads from `start/`.

## Common Workflows

### Fresh Checkout on Another Machine

```bash
git submodule update --init --recursive
```

Then make sure the external tools from the requirements section are installed.

### Upgrade an Existing Plugin

Example for a `start/` plugin:

```bash
cd .vim/pack/plugins/start/<plugin-name>
git fetch origin
git checkout <tag-or-commit>
cd /home/tobi/Code/newVim
git add .vim/pack/plugins/start/<plugin-name>
git commit -m "Update <plugin-name>"
```

Example for an `opt/` plugin:

```bash
cd .vim/pack/plugins/opt/<plugin-name>
git fetch origin
git checkout <tag-or-commit>
cd /home/tobi/Code/newVim
git add .vim/pack/plugins/opt/<plugin-name>
git commit -m "Update <plugin-name>"
```

If the upgrade also changes `.gitmodules`, stage that too:

```bash
git add .gitmodules
```

Important:

- the superproject commit stores the submodule pointer
- do not commit incidental local files created inside a plugin unless you intentionally mean to maintain a fork

### Inspect a Dirty Plugin Submodule

If root `git status` shows a plugin as modified, inspect the plugin directly:

```bash
cd .vim/pack/plugins/start/<plugin-name>
git status
git log --oneline --decorate -n 5
```

Possible causes:

- the submodule is checked out to a different commit
- local changes were made inside the plugin
- a plugin-specific install/build step modified tracked files

If a plugin-specific setup step modified tracked files inside the submodule,
future upgrades may be blocked until those local changes are cleaned or stashed.
In that case:

1. inspect the plugin with `git status`
2. reset or stash local plugin changes you do not intend to keep
3. upgrade the plugin to the new commit
4. re-run the local setup step if needed
5. commit only the parent repo's submodule pointer unless you intentionally want a forked plugin state

### Add a New Plugin

Example for an always-on plugin:

```bash
git submodule add <plugin-url> .vim/pack/plugins/start/<plugin-name>
git commit -m "Add <plugin-name>"
```

Example for an optional plugin:

```bash
git submodule add <plugin-url> .vim/pack/plugins/opt/<plugin-name>
git commit -m "Add <plugin-name>"
```

Then document:

- why the plugin is kept
- whether it belongs in `start/` or `opt/`
- any external dependency, auth step, or post-install step

### Remove a Plugin

Removal should be deliberate and done in one cleanup change:

1. remove the config that depends on the plugin
2. remove the submodule entry from the index
3. remove the plugin path from `.gitmodules` if Git does not do it for you
4. commit the cleanup together

Typical flow for a tracked plugin:

```bash
git rm -f .vim/pack/plugins/start/<plugin-name>
git commit -m "Remove <plugin-name>"
```

If the plugin lives in `opt/`, remove it from that path instead.

Do not leave dead config behind after plugin removal.

## Optional Plugin Loading

This repo uses Vim-native `packadd` for optional plugins.

### Copilot

`copilot.vim` lives in `opt/` and does not load at startup.

Enable it explicitly from inside Vim:

```vim
:CopilotEnable
```

That command:

- runs `packadd copilot.vim`
- applies the Copilot-specific mapping

After the plugin is loaded for the first time on a machine, run:

```vim
:Copilot setup
```

### LaTeX

`vim-latex` lives in `opt/`.

It loads automatically when opening a LaTeX file such as `*.tex`.

## Local Config

The supported local override mechanism is:

- `~/.vim/local.vim`

The main config sources that file only if it exists.

Use it for:

- machine-specific executable paths
- local visual/font tweaks
- personal mappings
- temporary experiments you do not want tracked

Do not use it for:

- required base behavior
- shared plugin definitions
- anything needed for normal bootstrap

If you prefer to keep local config near the repo, the cleanest approach is usually to keep the supported file outside the repo and symlink or generate it yourself. The tracked setup itself only assumes `~/.vim/local.vim`.

## Plugin Notes

### coc.nvim

Requirements:

- Node.js installed locally

Notes:

- this repo tracks the plugin as a pinned submodule
- after upgrading it, verify that Vim still starts cleanly and completion still works

### fzf.vim

Important:

- `fzf.vim` is only the Vim integration layer
- it depends on the external `fzf` binary
- content search is expected to use `ripgrep` through `:Rg`

If `:Files`, `:GFiles`, or `:Rg` fail, check your external tool installation first.

### copilot.vim

Requirements:

- Node.js installed locally
- GitHub Copilot access/subscription

Notes:

- this repo keeps it as an optional plugin in `opt/`
- load it with `:CopilotEnable`
- do not commit local auth state

### vim-latex

Requirements:

- LaTeX tooling such as `pdflatex`

Notes:

- the plugin loads on demand for LaTeX files
- `<Leader>p` compiles the current LaTeX file in its own directory

### vim-devicons

Requirements:

- a compatible icon-capable font, typically a Nerd Font

Notes:

- without the expected font support, icon rendering may be broken or degraded

## What Not To Commit

Do not commit:

- local auth state
- machine-specific generated caches
- incidental edits inside plugin submodules unless you intentionally mean to fork or patch that plugin

## Plugin Inventory

### Retained Plugins

| Plugin | Mode | Purpose | Notes |
| --- | --- | --- | --- |
| `coc.nvim` | `start` | LSP, completion, diagnostics | Requires Node.js |
| `gruvbox` | `start` | colorscheme | core UI choice |
| `editorconfig` | `start` | EditorConfig support | project formatting defaults |
| `vim-surround` | `start` | surround editing helpers | core editing workflow |
| `fzf.vim` | `start` | file and content search UI | requires `fzf` and `rg` |
| `nerdtree` | `start` | file tree | core navigation workflow |
| `nerdcommenter` | `start` | commenting helpers | active workflow |
| `auto-pairs` | `start` | pairing helpers | retained as useful |
| `vim-airline` | `start` | statusline | retained as useful |
| `vim-devicons` | `start` | file icons | depends on font support |
| `vim-css3-syntax` | `start` | CSS syntax improvements | retained |
| `vim-graphql` | `start` | GraphQL syntax/filetype support | web workflow |
| `vim-prisma` | `start` | Prisma syntax/filetype support | web workflow |
| `vim-rzip` | `start` | zip editing helper | retained |
| `copilot.vim` | `opt` | AI completion | load with `:CopilotEnable` |
| `vim-latex` | `opt` | LaTeX support | loads for LaTeX files |

### Removed Plugins

Removed during cleanup:

- `ack.vim`
- `ultisnips`
- `vim-snippets`
- `typescript-vim`
- `vim-javascript`
- `vim-jsx`
- `vim-jsx-typescript`
- `elm-vim`
- `purescript-vim`
- `vim-reason-plus`

Reasons:

- replaced by a cleaner search workflow
- not part of the real editing workflow
- redundant with built-in Vim support
- no longer relevant enough to keep installed
