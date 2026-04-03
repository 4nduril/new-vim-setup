# Vim Setup Cleanup Plan

This document is the working plan for cleaning up this Vim setup.

The current state is recoverable, but there are a few structural problems:

- plugin installation is not fully reproducible
- package roots are inconsistent
- config and plugin state have drifted apart
- some language and UX plugins likely overlap
- machine-specific settings are mixed into tracked config
- there is no bootstrap documentation

The recommendation is to clean this up in small, reversible phases instead of rewriting everything at once.

## Goals

- make the repo reproducible from a clean clone
- reduce plugin/config drift
- keep the setup Vim-native and understandable
- preserve existing workflows unless there is a strong reason to remove them
- separate portable config from machine-local overrides

## Non-Goals

- migrating to Neovim
- replacing everything with a modern Lua stack
- changing editor behavior aggressively before the structure is cleaned up

## Current Findings

### Plugin Management

- Most plugins are tracked as git submodules in `.gitmodules`.
- `copilot.vim`, `ultisnips`, and `vim-snippets` currently exist as nested git repos under `.vim/pack/addons/start/` but are not registered as submodules.
- `coc.nvim` has local drift from the submodule commit recorded in the index.
- Package roots are inconsistent:
  - `.vim/pack/addons/start/...`
  - `.vim/pack/bundle/start/...`

### Config Drift

- `.vimrc` configures `indent_guides`, but that plugin is not installed.
- Language-related config and plugin declarations are mixed into one file.
- Several machine-specific paths are committed:
  - CoC Reason language server path
  - backup / swap / undo directories under `$HOME`

### Probable Plugin Overlap

The main overlap area was the JS/TS syntax stack:

- `typescript-vim`
- `vim-javascript`
- `vim-jsx`
- `vim-jsx-typescript`

That overlap has now been resolved in the plan: remove the extra JS/TS plugin stack and rely on built-in Vim support first.

## Recommended Cleanup Order

1. stabilize plugin management
2. remove stale config and obvious drift
3. split the config by concern
4. move non-core plugins out of eager loading
5. separate portable config from local machine settings
6. add bootstrap documentation

## Phase 1: Stabilize Plugin Management

### 1.1 Pick One Source of Truth

Decision:

- Option A: keep native Vim packages plus git submodules
- Option B: switch to a plugin manager

Recommendation:

- Choose Option A for this cleanup pass.
- Reason: the repo already uses native packages and submodules; finishing that cleanup is lower-risk than migrating plugin management and config structure at the same time.

Status:

- Chosen: Option A
- Documentation target: `README.md` should define bootstrap, upgrade, submodule commit workflow, and plugin-specific post-install/post-checkout steps.

### 1.2 Normalize Package Roots

Decision:

- Option A: keep both `addons` and `bundle`
- Option B: collapse to a single namespace

Recommendation:

- Choose Option B.
- Suggested target layout:
  - `.vim/pack/plugins/start/...`
  - `.vim/pack/plugins/opt/...`
- Reason: `addons` vs `bundle` adds no useful meaning and makes the layout harder to reason about.

Status:

- Chosen: Option B
- Target layout:
  - `.vim/pack/plugins/start/...`
  - `.vim/pack/plugins/opt/...`

Migration note:

- Do not mix old and new roots long-term.
- During the migration there may be a temporary mixed state, but the end state should leave only the `plugins` namespace under `.vim/pack/`.
- Any future plugin additions should target `plugins/start` or `plugins/opt`, not `addons` or `bundle`.

### 1.3 Fix Untracked Nested Plugin Repos

Affected plugins:

- `copilot.vim`
- `ultisnips`
- `vim-snippets`

Decision:

- Option A: formalize them as submodules
- Option B: remove them

Recommendation:

- Formalize them as submodules only if they are actively used.
- Otherwise remove them.
- Do not keep nested git repos in `pack/*` without tracking them through `.gitmodules`.

Status:

- Keep `copilot.vim`.
- Defer final handling of `ultisnips` and `vim-snippets` to the snippet workflow decision.

Implementation intent:

- convert `copilot.vim` into a properly tracked submodule if it remains part of the setup
- place retained plugins under the normalized package root during the Phase 1 migration
- document any post-install or post-auth steps in `README.md`

Deferred documentation:

- add a dedicated README section for plugin removal
- include exact removal steps for submodules and any plugin-specific cleanup

Superseded by later decision:

- Phase 2.4 now marks `ultisnips` and `vim-snippets` for removal rather than formalization.

### 1.4 Decide Whether to Keep Submodules Long-Term

Decision:

- Option A: stay on submodules long-term
- Option B: revisit a plugin manager later

Recommendation:

- Postpone this decision until after cleanup.
- Use submodules for now, then reassess once the plugin inventory and config structure are clean.

Status:

- Stay on submodules for now.

Interpretation:

- Phase 1 and the following cleanup phases should assume submodules remain the plugin tracking mechanism.
- Re-evaluating plugin management is explicitly out of scope until after the current cleanup is complete.

### Phase 1 Execution Plan

This section translates the Phase 1 decisions into concrete repo changes to make later.

#### Target End State

- all managed plugins live under `.vim/pack/plugins/start/...` or `.vim/pack/plugins/opt/...`
- all managed plugins are tracked as submodules
- no plugin remains under `.vim/pack/addons/...`
- no plugin remains under `.vim/pack/bundle/...`
- no nested unmanaged git repos remain inside `.vim/pack/...`
- `.gitmodules` matches the actual on-disk plugin layout
- `README.md` documents bootstrap, upgrade, and removal workflows for the final layout

#### Planned Migration Steps

1. inventory all current plugin directories under `.vim/pack/...`
2. decide the target destination for each plugin:
   - `plugins/start`
   - `plugins/opt`
3. create the normalized package root:
   - `.vim/pack/plugins/start`
   - `.vim/pack/plugins/opt`
4. migrate existing tracked submodules from:
   - `.vim/pack/addons/start/...`
   - `.vim/pack/bundle/start/...`
   into the normalized root
5. formalize the currently unmanaged nested repos as submodules:
   - `copilot.vim`
6. remove unmanaged nested repos that are no longer part of the setup:
   - `ultisnips`
   - `vim-snippets`
7. update `.gitmodules` so every managed plugin path matches the new layout
8. update the git index so each submodule pointer points at the normalized path
9. verify there are no remaining plugin directories in legacy roots
10. verify root `git status` shows only the intended path/submodule changes
11. update `README.md` so the documented bootstrap and upgrade workflow matches the new layout

#### Plugin Migration Table

This is the current expected Phase 1 migration set.

| Current path | Planned action | Target path |
| --- | --- | --- |
| `.vim/pack/addons/start/ack.vim` | remove submodule | removed |
| `.vim/pack/addons/start/auto-pairs` | move submodule | `.vim/pack/plugins/start/auto-pairs` |
| `.vim/pack/addons/start/coc.nvim` | move submodule | `.vim/pack/plugins/start/coc.nvim` |
| `.vim/pack/addons/start/copilot.vim` | formalize as submodule and move | `.vim/pack/plugins/opt/copilot.vim` |
| `.vim/pack/addons/start/editorconfig` | move submodule | `.vim/pack/plugins/start/editorconfig` |
| `.vim/pack/addons/start/elm-vim` | remove submodule | removed |
| `.vim/pack/addons/start/fzf.vim` | move submodule | `.vim/pack/plugins/start/fzf.vim` |
| `.vim/pack/addons/start/gruvbox` | move submodule | `.vim/pack/plugins/start/gruvbox` |
| `.vim/pack/addons/start/nerdcommenter` | move submodule | `.vim/pack/plugins/start/nerdcommenter` |
| `.vim/pack/addons/start/nerdtree` | move submodule | `.vim/pack/plugins/start/nerdtree` |
| `.vim/pack/addons/start/purescript-vim` | remove submodule | removed |
| `.vim/pack/addons/start/typescript-vim` | remove submodule | removed |
| `.vim/pack/addons/start/ultisnips` | remove nested repo | removed |
| `.vim/pack/addons/start/vim-airline` | move submodule | `.vim/pack/plugins/start/vim-airline` |
| `.vim/pack/addons/start/vim-css3-syntax` | move submodule | `.vim/pack/plugins/start/vim-css3-syntax` |
| `.vim/pack/addons/start/vim-devicons` | move submodule | `.vim/pack/plugins/start/vim-devicons` |
| `.vim/pack/addons/start/vim-graphql` | move submodule | `.vim/pack/plugins/start/vim-graphql` |
| `.vim/pack/addons/start/vim-javascript` | remove submodule | removed |
| `.vim/pack/addons/start/vim-jsx` | remove submodule | removed |
| `.vim/pack/addons/start/vim-jsx-typescript` | remove submodule | removed |
| `.vim/pack/addons/start/vim-latex` | move submodule | `.vim/pack/plugins/opt/vim-latex` |
| `.vim/pack/addons/start/vim-prisma` | move submodule | `.vim/pack/plugins/start/vim-prisma` |
| `.vim/pack/addons/start/vim-reason-plus` | remove submodule | removed |
| `.vim/pack/addons/start/vim-snippets` | remove nested repo | removed |
| `.vim/pack/addons/start/vim-surround` | move submodule | `.vim/pack/plugins/start/vim-surround` |
| `.vim/pack/bundle/start/vim-rzip` | move submodule | `.vim/pack/plugins/start/vim-rzip` |

Notes:

- This table now reflects the current final destination for each known plugin.
- If a later decision changes plugin retention or loading mode, this table should be updated first.

#### Expected `.gitmodules` Outcome

After Phase 1:

- every plugin path in `.gitmodules` should begin with `.vim/pack/plugins/`
- there should be no `.vim/pack/addons/...` entries
- there should be no `.vim/pack/bundle/...` entries
- `copilot.vim` should have a proper submodule entry
- `ultisnips` and `vim-snippets` should no longer exist as nested repos under `.vim/pack/...`

#### README Follow-Up

Once the migration is done, `README.md` should be updated to reflect:

- the normalized package root
- the exact add/upgrade/remove submodule workflow
- plugin-specific post-install steps
- which plugins require external binaries or auth

#### Verification Checklist

Phase 1 should not be considered complete until all of the following are true:

- `find .vim/pack -maxdepth 3 -type d` shows only the normalized plugin roots for managed plugins
- `git submodule status` lists every managed plugin, including `copilot.vim`
- root `git status` shows no accidental nested repo noise under `.vim/pack/...`
- `.gitmodules` contains only normalized plugin paths
- the bootstrap commands in `README.md` match the actual repo structure

## Phase 2: Remove Drift and Dead Weight

### 2.1 Remove Stale Config

Known stale config:

- `indent_guides` settings in `.vimrc`

Recommendation:

- Remove plugin config aggressively when the plugin is not installed.
- Reason: stale config hides the real dependency set and wastes time during debugging.

Status:

- Agreed: remove stale config.

Execution intent:

- delete config blocks for plugins that are not installed or no longer intentionally part of the setup
- start with known stale config such as `indent_guides`
- verify after each removal that no remaining mappings or settings still assume that plugin exists

Guardrail:

- do not mix stale-config cleanup with unrelated behavior changes
- if a config block looks stale but the plugin is about to be restored intentionally, postpone deletion until that decision is explicit

### 2.2 Audit Search Workflow

Current tools:

- `fzf.vim`
- `ack.vim`
- external `ag`

Decision:

- Option A: keep both `fzf.vim` and `ack.vim`
- Option B: standardize on one primary search workflow

Recommendation:

- Keep `fzf.vim`.
- Keep `ack.vim` only if `:Ack` is part of regular muscle memory.
- If not, remove `ack.vim` and standardize around FZF plus ripgrep/ag-backed commands.

Status:

- Standardize on `fzf.vim` for both file search and content search.
- Prefer `ripgrep` as the content-search backend.
- `ack.vim` is planned for removal.

Planned end state:

- file search via `fzf.vim` commands such as `:Files` or `:GFiles`
- content search via `fzf.vim` commands such as `:Rg`
- no `ack.vim` dependency in the plugin set
- no `ag`-specific root config unless needed as a fallback

Migration intent:

- replace existing `:Ack` mappings with `fzf.vim` content-search mappings
- remove `ack.vim` plugin config
- remove `g:ackprg` config once no remaining workflow depends on it

Reasoning:

- one search UI is easier to maintain
- `ripgrep` is a better long-term default than `ag`
- this reduces plugin overlap without reducing capability

### 2.3 Audit Tree/File Navigation

Current plugin:

- `NERDTree`

Decision:

- Option A: keep it
- Option B: remove it
- Option C: replace it later

Recommendation:

- Keep it temporarily if it is still used.
- If it is rarely used, remove it instead of replacing it immediately.
- Avoid changing file navigation workflows until the setup is reproducible and documented.

Status:

- Keep `NERDTree`.
- It is an active core workflow used in most Vim sessions.

Implication:

- `NERDTree` should be treated as a stable part of the setup, not as legacy plugin debt.
- Do not remove or replace it as part of cleanup unless that decision is revisited explicitly later.

Packaging note:

- For now, keep it in the normal plugin set during cleanup.
- Any later `start` vs `opt` decision should assume a bias toward `start` because it is used constantly.

### 2.4 Audit Snippet Workflow

Current state:

- UltiSnips config exists
- `ultisnips` and `vim-snippets` are present as untracked nested repos

Decision:

- Option A: formalize and keep snippet support
- Option B: remove it

Recommendation:

- Keep snippets only if they are actively used.
- If kept, formalize both plugins as submodules and make snippet behavior explicit in the config.
- If not actively used, remove both. The current half-installed state should not remain.

Status:

- Remove snippet support.
- `ultisnips` and `vim-snippets` are not part of the actual editing workflow.

Reasoning:

- they were installed speculatively rather than from sustained usage
- they add maintenance cost and config surface without real payoff
- they are poor candidates to keep around "just in case"

Implication:

- this overrides the earlier Phase 1.3 placeholder decision to formalize all unmanaged nested repos
- `copilot.vim` should still be handled independently
- `ultisnips` and `vim-snippets` should move from "formalize" to "remove" when execution begins

Cleanup intent:

- remove snippet plugin config
- remove snippet plugin directories
- remove any mappings that exist only for snippet expansion
- document the removal flow in `README.md` when the README is finalized

### 2.5 Audit Copilot

Current state:

- Copilot config exists
- `copilot.vim` is present as an untracked nested repo

Decision:

- Option A: keep and formalize it
- Option B: remove it

Recommendation:

- Keep it as part of the daily workflow.
- Make it a proper submodule and keep it in `opt/` instead of eager-loading it.

Status:

- Keep `copilot.vim`.
- It is an important part of the setup.

Implication:

- `copilot.vim` should be formalized as a proper submodule during Phase 1 execution.
- Treat its config as intentional and maintained, not speculative drift.

Updated loading preference:

- `copilot.vim` should be optional rather than eager-loaded
- target packaging should therefore bias toward `opt/`
- add an explicit user command that runs `packadd copilot.vim` and starts the Copilot workflow
- create Copilot-specific mappings only after the plugin has been loaded

Execution note:

- do not keep Copilot mappings or function calls in startup config unless they are guarded so they only apply after `packadd`

Target behavior:

- Vim starts without loading Copilot
- a user command such as `:CopilotEnable` loads `copilot.vim`
- that command also installs the Copilot-specific mappings/setup exactly once

### 2.6 Audit Auto-Pairs and UI Plugins

Plugins reviewed here:

- `auto-pairs`
- `vim-airline`
- `vim-devicons`

Decision:

- keep or remove based on actual usage

Recommendation:

- Keep `vim-airline` if you still value the statusline and it is stable.
- Keep `vim-devicons` only if the terminal/font setup is consistent and the visual benefit matters.
- Keep `auto-pairs` only if it clearly improves editing and does not conflict with CoC/snippets.

Status:

- Keep `auto-pairs`.
- Keep `vim-airline`.
- Keep `vim-devicons`.

Rationale:

- these plugins are still considered useful parts of the setup
- no current cleanup goal justifies removing them

README follow-up:

- add a dedicated note that `vim-devicons` depends on a compatible icon-capable font setup
- document that icon rendering may degrade or break on machines without the expected fonts

### Phase 2 Execution Plan

This phase removes confirmed dead weight and preserves the plugins that are part of the real workflow.

#### Target End State

- no stale config remains for plugins that are not installed
- search is unified around `fzf.vim`
- `ack.vim` and its config are removed
- `NERDTree` remains intact as a core workflow
- snippet support is removed completely
- `copilot.vim` remains retained
- `auto-pairs`, `vim-airline`, and `vim-devicons` remain retained

#### Planned Steps

1. delete confirmed stale config blocks such as `indent_guides`
2. remove `ack.vim` from the plugin set
3. replace `:Ack`-based mappings and config with `fzf.vim` search mappings
4. remove `g:ackprg` and any remaining `ag`-specific config unless a fallback is intentionally kept
5. leave `NERDTree` mappings and config in place
6. remove snippet-related plugin config and mappings
7. remove `ultisnips` and `vim-snippets` from the planned plugin set
8. preserve `copilot.vim` as a retained plugin
9. preserve `auto-pairs`, `vim-airline`, and `vim-devicons`
10. verify no remaining config refers to removed plugins

#### Concrete Removal Set

Remove in this phase:

- stale `indent_guides` config
- `ack.vim`
- `ultisnips`
- `vim-snippets`
- snippet-only mappings and config

Keep in this phase:

- `nerdtree`
- `copilot.vim`
- `auto-pairs`
- `vim-airline`
- `vim-devicons`

#### Verification Checklist

- no config remains for `indent_guides`
- no config remains for `ack.vim`
- no config remains for UltiSnips or snippet expansion
- search mappings point at `fzf.vim` commands rather than `:Ack`
- `NERDTree` mappings still exist
- retained UI plugins are unaffected by the cleanup

## Phase 3: Consolidate Language Plugin Overlap

### 3.1 JavaScript and TypeScript

Current likely-overlapping plugins:

- `vim-javascript`
- `vim-jsx`
- `vim-jsx-typescript`
- `typescript-vim`

Decision:

- Option A: keep the full stack
- Option B: reduce to the minimal syntax/filetype set

Recommendation:

- Choose Option B.
- Start from the assumption that `coc.nvim` owns completion, diagnostics, rename, references, and jump-to-definition.
- Keep syntax/filetype plugins only where they still improve highlighting or file detection in practice.
- This area is a strong candidate for pruning.

Status:

- Remove the extra JS/TS syntax plugin stack first.

Planned removals:

- `typescript-vim`
- `vim-javascript`
- `vim-jsx`
- `vim-jsx-typescript`

Decision basis:

- current Vim versions already provide built-in support for JavaScript, TypeScript, and TypeScript React
- the extra plugin stack appears more likely to be legacy overlap than necessary functionality

Fallback strategy:

- rely on built-in Vim support first
- if JSX or TSX support turns out insufficient in practice, re-add the minimum plugin necessary afterward

Guardrail:

- do not keep overlapping JS/TS plugins without a concrete problem they are solving

### 3.2 GraphQL and Prisma

Current plugins:

- `vim-graphql`
- `vim-prisma`

Decision:

- keep eager-loaded, move to optional, or remove

Recommendation:

- Move them to `opt/` unless these filetypes are used constantly.
- Keep them only if they noticeably improve syntax/filetype behavior beyond what CoC and built-in detection provide.

Status:

- Keep `vim-graphql`.
- Keep `vim-prisma`.

Rationale:

- both are considered useful enough to retain
- they are not currently being treated as overlap debt to prune

Packaging note:

- as part of normal web development workflow, `vim-graphql` and `vim-prisma` should remain eagerly loaded

### 3.3 Secondary Language Plugins

Current plugins:

- `vim-latex`
- `elm-vim`
- `purescript-vim`
- `vim-reason-plus`

Decision:

- keep eager-loaded, move to optional, or remove

Recommendation:

- Move them to `opt/` by default.
- Keep them only if those languages are still relevant to active work.
- These are exactly the kinds of plugins that should not load for every Vim session.

Status:

- Keep `vim-latex` in `opt/`.
- Remove `elm-vim`.
- Remove `purescript-vim`.
- Remove `vim-reason-plus`.

Rationale:

- `vim-latex` is still useful but not part of the common startup path
- Elm, PureScript, and Reason support are no longer important enough to keep installed

Execution note:

- any config that exists only for removed language plugins should be cleaned up with the plugin removal
- any LaTeX-specific config should be reviewed later to ensure it still works when the plugin is loaded via `packadd`

### Phase 3 Execution Plan

This phase removes language plugin overlap and keeps only the language support that is still justified.

#### Target End State

- built-in Vim support handles JavaScript and TypeScript first
- extra JS/TS syntax plugins are removed unless proven necessary later
- GraphQL and Prisma support remain installed and eager-loaded
- LaTeX remains available as an optional plugin
- unused secondary language plugins are removed

#### Planned Steps

1. remove the JS/TS plugin stack:
   - `typescript-vim`
   - `vim-javascript`
   - `vim-jsx`
   - `vim-jsx-typescript`
2. remove any config that exists only to support those plugins
3. keep `vim-graphql` in the retained plugin set
4. keep `vim-prisma` in the retained plugin set
5. keep `vim-latex`, but place it in `opt/`
6. remove `elm-vim`
7. remove `purescript-vim`
8. remove `vim-reason-plus`
9. remove any config that exists only for Elm, PureScript, or Reason plugins
10. review LaTeX config so it still works when loaded on demand

#### Concrete Keep / Remove Set

Remove:

- `typescript-vim`
- `vim-javascript`
- `vim-jsx`
- `vim-jsx-typescript`
- `elm-vim`
- `purescript-vim`
- `vim-reason-plus`

Keep in `start/`:

- `vim-graphql`
- `vim-prisma`

Keep in `opt/`:

- `vim-latex`

#### Verification Checklist

- no JS/TS-specific plugin config remains for removed plugins
- built-in Vim support is the only JS/TS syntax/filetype layer left
- `vim-graphql` and `vim-prisma` remain in the planned eager-load set
- LaTeX config is compatible with `packadd`
- no config remains for removed secondary language plugins

## Phase 4: Split Config by Concern

### 4.1 Break Up `.vimrc`

Decision:

- Option A: keep a single `.vimrc`
- Option B: split into sourced files

Recommendation:

- Choose Option B.
- Suggested layout:
  - `.vimrc`
  - `.vim/vimrc/core.vim`
  - `.vim/vimrc/ui.vim`
  - `.vim/vimrc/mappings.vim`
  - `.vim/vimrc/plugins.vim`
  - `.vim/vimrc/languages.vim`
  - `.vim/vimrc/local.vim` if present

Reason:

- This keeps the top-level entry point small and makes drift easier to spot.

Status:

- Chosen: split `.vimrc` into sourced files.

Intent:

- keep `.vimrc` as a thin entry point
- move real configuration into a small number of focused files
- avoid leaving large mixed-responsibility blocks in the top-level file

### 4.2 Separate Plugin Config from Core Behavior

Decision:

- Option A: split one file per plugin
- Option B: split by concern

Recommendation:

- Choose Option B.
- One-file-per-plugin usually becomes another kind of sprawl.
- Group by stable concerns instead:
  - core editor behavior
  - UI
  - mappings
  - plugin integration
  - language/filetype behavior

Status:

- Chosen: split by concern, not by plugin and not by filetype.

Implication:

- keep the number of config files relatively small
- group settings where they are conceptually stable
- avoid scattering related behavior across many tiny files

### 4.3 Use `ftdetect/` and `ftplugin/`

Current examples:

- EJS and Dust filetype mapping live in `.vimrc`

Recommendation:

- Move filetype detection into `ftdetect/` where appropriate.
- Move per-language settings into `ftplugin/`.
- Keep `.vimrc` focused on global editor behavior and high-level plugin setup.

Status:

- Agreed.

Interpretation:

- use `ftdetect/` and `ftplugin/` for genuinely filetype-specific behavior
- do this selectively, not as a blanket rewrite of all language-related config

Examples:

- custom filetype detection such as EJS and Dust mappings belongs in `ftdetect/`
- settings that should apply only to one filetype belong in `ftplugin/`
- global editor behavior should remain in the main concern-based config files

### Phase 4 Execution Plan

This phase restructures the configuration without intentionally changing editor behavior.

#### Target End State

- `.vimrc` is a thin entry point
- configuration is split into a small number of concern-based files
- filetype-specific behavior lives in `ftdetect/` and `ftplugin/` where appropriate
- global behavior is no longer mixed with plugin and filetype details in one large file

#### Planned Steps

1. create the target config layout under the repo-managed Vim config tree
2. keep `.vimrc` minimal and make it source the concern-based files
3. move global editor behavior into a core settings file
4. move UI-related settings into a UI file
5. move generic mappings into a mappings file
6. move plugin integration into a plugin-oriented concern file
7. move language-specific but still global behavior into a language/config file
8. move custom filetype detection rules such as EJS and Dust into `ftdetect/`
9. move truly filetype-local settings into `ftplugin/`
10. verify that behavior is unchanged aside from intentional cleanup

#### Proposed Config Shape

- `.vimrc`
- `.vim/vimrc/core.vim`
- `.vim/vimrc/ui.vim`
- `.vim/vimrc/mappings.vim`
- `.vim/vimrc/plugins.vim`
- `.vim/vimrc/languages.vim`
- optional local override hook
- `.vim/ftdetect/...`
- `.vim/ftplugin/...`

#### Guardrails

- do not split into one file per plugin
- do not split into one file per filetype as a general rule
- only use `ftdetect/` and `ftplugin/` where the behavior is genuinely filetype-specific
- avoid bundling structural reorganization with unrelated functional changes

#### Verification Checklist

- `.vimrc` is short and acts mainly as an entry point
- concern-based config files are present and named consistently
- EJS/Dust filetype detection no longer lives in the main config
- global settings are not hidden inside filetype-local files
- plugin behavior still works after the split

## Phase 5: Add Loading Discipline

### 5.1 Decide What Stays in `start/`

Recommendation:

- follow the current final placement decisions recorded below

Status:

- resolved from earlier decisions

Current target placement:

Keep in `start/`:

- `coc.nvim`
- `gruvbox`
- `editorconfig`
- `vim-surround`
- `fzf.vim`
- `nerdtree`
- `nerdcommenter`
- `auto-pairs`
- `vim-airline`
- `vim-devicons`
- `vim-css3-syntax`
- `vim-graphql`
- `vim-prisma`
- `vim-rzip`

Keep in `opt/`:

- `copilot.vim`
- `vim-latex`

Remove:

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

Notes:

- this placement plan reflects current decisions only
- if a later phase changes a plugin retention decision, this section should be updated to match

### 5.2 Lazy Loading Strategy

Decision:

- Option A: simple `opt/` plus `packadd`
- Option B: add a plugin manager just for lazy-loading

Recommendation:

- Choose Option A.
- Native `opt/` plus `packadd` is enough for this setup and keeps the system comprehensible.

Status:

- Resolved: use native `opt/` plus `packadd`.

Current intended uses:

- `copilot.vim` loads on explicit user command
- `vim-latex` loads on demand when needed

Principle:

- do not introduce a separate plugin manager just to get lazy-loading
- optional plugins should use straightforward Vim-native loading patterns

### Phase 5 Execution Plan

This phase applies the decided `start/` / `opt/` split and wires optional plugins correctly.

#### Target End State

- always-on plugins live in `start/`
- optional plugins live in `opt/`
- optional plugins are loaded with `packadd`
- no startup config assumes an `opt/` plugin is already loaded

#### Planned Steps

1. move retained always-on plugins into `plugins/start`
2. move retained optional plugins into `plugins/opt`
3. ensure `copilot.vim` is treated as optional
4. implement a user command such as `:CopilotEnable` that:
   - runs `packadd copilot.vim`
   - applies Copilot setup and mappings exactly once
5. ensure startup config does not call Copilot functions before load
6. ensure `vim-latex` is treated as optional
7. define how LaTeX support is loaded on demand
8. verify removed plugins are not still referenced by startup config

#### Current Placement Plan

`start/`:

- `coc.nvim`
- `gruvbox`
- `editorconfig`
- `vim-surround`
- `fzf.vim`
- `nerdtree`
- `nerdcommenter`
- `auto-pairs`
- `vim-airline`
- `vim-devicons`
- `vim-css3-syntax`
- `vim-graphql`
- `vim-prisma`
- `vim-rzip`

`opt/`:

- `copilot.vim`
- `vim-latex`

Removed:

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

#### Verification Checklist

- `git` layout matches the intended `start/` / `opt/` split
- startup config has no unguarded references to `copilot.vim`
- `:CopilotEnable`-style behavior is defined and idempotent
- LaTeX can be loaded on demand
- no removed plugin is still treated as `start/` or `opt/`

## Phase 6: Make the Repo Portable

### 6.1 Local Override File

Current machine-specific config includes:

- hardcoded Reason language server path
- backup/swap/undo path assumptions

Decision:

- Option A: keep machine-specific config tracked
- Option B: move it to a local override file

Recommendation:

- Choose Option B.
- Keep repo defaults portable.
- Put machine-local paths and optional overrides in an untracked local config file.

Status:

- Agreed: keep a local override mechanism.

Planned mechanism:

- source an additional Vim file only if it exists
- prefer keeping that file outside the repo so it stays naturally untracked
- reserve it for truly machine-local paths, overrides, and experiments

Usage examples:

- machine-specific executable paths
- local theme/font adjustments
- personal mappings that should not be shared
- temporary local overrides during experimentation

Non-goals:

- do not require the local file for normal bootstrap
- do not move core shared behavior into the local file

Current note:

- the Reason-specific local path may disappear entirely once Reason support is removed
- the local override mechanism still remains useful beyond that one case

README follow-up:

- add a section describing the local config mechanism
- explain the main placement options for a local config file
- explain what kinds of settings belong there and what kinds do not

### 6.2 Ensure Required Directories Exist

Decision:

- Option A: require manual setup
- Option B: auto-create missing directories

Recommendation:

- Choose Option B.
- Auto-create undo, backup, and swap directories when missing.
- Reason: this removes avoidable setup failure from a clean environment.

Status:

- Chosen: Option B.

Intent:

- auto-create required undo, backup, and swap directories during startup if they do not exist
- avoid making these directories a manual bootstrap prerequisite

### 6.3 Review Keybindings That Depend on Terminal Behavior

Current example:

- `<C-i>` is used for Copilot accept

Recommendation:

- Reconsider this mapping unless terminal behavior is known to be reliable.
- `<C-i>` often collides with Tab semantics depending on terminal and environment.

Status:

- keep the current mapping for now
- if it causes problems on another machine or terminal, remap it then

Documentation note:

- when this mapping remains in tracked config, add a short explanatory comment next to it
- the comment should state that the mapping is intentionally kept because it works in the current terminal setup, but may need remapping elsewhere

### Phase 6 Execution Plan

This phase separates portable defaults from local assumptions and reduces machine-specific setup friction.

#### Target End State

- a local override mechanism exists but is optional
- required state directories are created automatically
- tracked config clearly documents any intentional terminal-sensitive assumptions
- portable config remains usable without a local override file

#### Planned Steps

1. add a local override hook that sources an extra Vim file only if it exists
2. prefer a local config location outside the repo so it stays untracked naturally
3. keep machine-local paths and experiments out of the tracked base config
4. remove machine-specific config that disappears due to plugin/language cleanup
5. auto-create undo, backup, and swap directories if missing
6. keep the current terminal-sensitive Copilot mapping for now
7. add a short explanatory comment for that mapping when editing the tracked config
8. document the local override mechanism in the README

#### Local Config Policy

Belongs in local config:

- machine-specific executable paths
- local visual/font tweaks
- personal overrides and experiments

Does not belong in local config:

- required base behavior
- shared plugin definitions
- anything needed for a normal bootstrap to succeed

#### Verification Checklist

- startup succeeds whether or not a local override file exists
- undo/backup/swap directories are created automatically
- no unnecessary machine-specific path remains in tracked config
- terminal-sensitive mappings are commented clearly if retained

## Phase 7: Document Bootstrap and Maintenance

### 7.1 Add a Root README

Recommendation:

Document at least:

- how to clone the repo
- how to initialize submodules
- required external tools
- optional language-specific tools
- what belongs in local overrides
- how to add, update, and remove plugins

Additional requirement:

- any TODO placeholders introduced into the initial README during planning should be resolved when the README is finalized
- the final README should not leave known workflow-critical sections as placeholders

### 7.2 Add a Plugin Inventory

Recommendation:

Create a table with:

- plugin name
- purpose
- keep/remove decision
- `start/` vs `opt/`
- external dependencies
- notes about overlap

This will force explicit decisions and reduce cargo-cult retention.

Status:

- explicitly desired

Intent:

- include a plugin inventory in the documentation
- use it to record purpose, retention decision, loading mode, and notable dependencies

### Phase 7 Execution Plan

This phase turns the cleaned-up setup into something another future-you can actually maintain.

#### Target End State

- `README.md` documents bootstrap and maintenance clearly
- README TODO placeholders have been resolved
- plugin add/update/remove workflows are documented
- local config options are documented
- a plugin inventory exists and reflects the final setup

#### Planned Steps

1. revise the initial README draft so it matches the final repo structure
2. replace temporary TODO placeholders with final instructions
3. document the bootstrap flow for a clean checkout
4. document the plugin add workflow
5. document the plugin upgrade workflow
6. document the plugin removal workflow
7. document plugin-specific post-install or post-auth steps
8. document the local config mechanism and placement options
9. add the font requirement note for `vim-devicons`
10. add a plugin inventory table
11. ensure the README reflects the actual final `start/` / `opt/` / removed set

#### Plugin Inventory Fields

For each retained plugin, document:

- plugin name
- purpose
- loading mode (`start` or `opt`)
- why it is kept
- notable external dependency or setup step

For removed plugins, optionally document:

- why they were removed

#### Verification Checklist

- README bootstrap instructions work against the final layout
- README contains no stale TODO placeholders
- README explains local config options
- README explains icon font expectations for `vim-devicons`
- plugin inventory matches the final plan and implementation

## Final Plugin Summary

This section summarizes the currently decided end state.

### Keep in `start/`

- `coc.nvim`
- `gruvbox`
- `editorconfig`
- `vim-surround`
- `fzf.vim`
- `nerdtree`
- `nerdcommenter`
- `auto-pairs`
- `vim-airline`
- `vim-devicons`
- `vim-graphql`
- `vim-prisma`
- `vim-rzip`
- `vim-css3-syntax`

### Keep in `opt/`

- `copilot.vim`
- `vim-latex`

### Remove

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

### Remove Config Alongside Plugin Cleanup

- stale `indent_guides` config
- `ack.vim` config and mappings
- snippet-only config and mappings
- config that exists only for removed language plugins

## Suggested Execution Sequence

1. execute Phase 1 normalization so plugin paths and submodules match the planned final layout
2. execute Phase 2 cleanup so stale config, `ack.vim`, and snippet support are removed
3. execute Phase 3 language cleanup so the retained language plugin set matches the plan
4. execute Phase 4 config restructuring so `.vimrc` becomes a thin entry point
5. execute Phase 5 loading changes so `start/` and `opt/` behavior matches the plan
6. execute Phase 6 portability work so local overrides and state directories are handled cleanly
7. execute Phase 7 documentation so README and plugin inventory match the final implementation

## Open Questions

No strategic plugin or structure decisions are intentionally open at this time.

Implementation details may still need naming choices, such as the exact command name used to enable Copilot.

## Working Principle

Prefer deletion over indefinite ambiguity.

If a plugin or config block does not have a clear owner, current purpose, and reproducible install path, it should either be formalized or removed.
