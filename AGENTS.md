# Vitesse Theme Management Guide

This repository is the single source of truth for Vitesse-themed configurations. It contains the Neovim colorscheme plus terminal/application themes for Herdr and Kitty.

## Project Structure

```
.
├── colors/                       # Neovim colorscheme entry points
│   ├── vitesse.lua
│   ├── vitesse-dark.lua
│   ├── vitesse-light.lua
│   ├── vitesse-black.lua
│   ├── vitesse-dark-soft.lua
│   └── vitesse-light-soft.lua
├── lua/vitesse/
│   ├── init.lua                  # Theme loader
│   ├── config.lua                # User-configurable defaults
│   ├── palette.lua               # Color definitions for all variants
│   └── theme.lua                 # Highlight group definitions
├── extras/
│   ├── vscode-theme-vitesse/     # Upstream source theme (submodule)
│   ├── herdr/                    # Herdr theme configurations
│   └── kitty/                    # Kitty terminal themes
└── README.md
```

## Color Source

All colors ultimately come from the upstream repository [vscode-theme-vitesse](https://github.com/antfu/vscode-theme-vitesse), tracked as a git submodule:

```bash
git submodule update --remote --merge
```

Key source files:

- `extras/vscode-theme-vitesse/scripts/colors.ts` — base color scales (grays, blues, greens, reds, etc.)
- `extras/vscode-theme-vitesse/scripts/colors.ts` (`VitesseThemes`) — theme semantic colors (`foreground`, `background`, `string`, `keyword`, `green`, `cyan`, etc.)
- `extras/vscode-theme-vitesse/extra/xterm-*.json` — terminal ANSI reference mappings

## Workflow When Updating Themes

### 1. Update the upstream submodule

When `vscode-theme-vitesse` changes, pull the latest version:

```bash
cd extras/vscode-theme-vitesse
git pull origin main
cd ../..
git add extras/vscode-theme-vitesse
git commit -m "chore: update vscode-theme-vitesse submodule"
```

### 2. Sync the Neovim Palette

Edit `lua/vitesse/palette.lua`:

- Maintain five variants: `dark`, `light`, `black`, `dark_soft`, `light_soft`
- Each variant must define at least the following semantic colors:
  - Backgrounds: `bg`, `bg_dark`, `bg_highlight`, `bg_visual`, `bg_search`, `bg_float`, `bg_popup`, `bg_statusline`
  - Foregrounds: `fg`, `fg_dark`, `fg_gutter`, `fg_float`
  - Borders: `border`, `border_highlight`
  - Semantic colors: `comment`, `string`, `variable`, `keyword`, `number`, `boolean`, `operator`, `func`, `constant`, `class`, `interface`, `type`, `builtin`, `property`, `namespace`, `punctuation`, `decorator`, `regex`
  - Accent colors: `red`, `green`, `yellow`, `blue`, `cyan`, `magenta`, `orange`
  - Git: `git.add`, `git.change`, `git.delete`, `git.ignore`
  - Diff: `diff.add`, `diff.delete`, `diff.change`, `diff.text`
  - Diagnostics: `error`, `warning`, `info`, `hint`, `todo`, `note`
  - Terminal ANSI: `terminal.black` through `terminal.white_bright`

**Important:** Neovim's `nvim_set_hl` does not support 8-digit hex colors (e.g. `#dbd7caee`). Convert them to 6-digit hex (`#dbd7ca`) before using them in the palette.

### 3. Sync Terminal Extras

#### Herdr

`extras/herdr/*.toml` only override the `[theme.custom]` keys supported by Herdr:

```toml
[theme]
name = "terminal"

[theme.custom]
panel_bg = "..."
accent = "..."
green = "..."
blue = "..."
red = "..."
yellow = "..."
```

#### Kitty

`extras/kitty/*.conf` must include the standard Kitty theme fields:

- `foreground`, `background`, `cursor`, `selection_foreground`, `selection_background`
- Window/chrome colors: `active_border_color`, `inactive_border_color`, `active_tab_background`, etc.
- ANSI palette: `color0` through `color15`
- Metadata header:

```conf
# vim:ft=kitty
## name: Vitesse Dark
## author: Anthony Fu
## license: MIT
## upstream: https://github.com/antfu/vscode-theme-vitesse
## blurb: ...
```

### 4. Test

#### Neovim

```bash
nvim --headless -u NONE \
  -c "set rtp+=~/f/vitesse.nvim" \
  -c "colorscheme vitesse-dark" \
  -c "qa!"
```

Test all variants:

```bash
for style in vitesse-dark vitesse-light vitesse-black vitesse-dark-soft vitesse-light-soft; do
  nvim --headless -u NONE \
    -c "set rtp+=~/f/vitesse.nvim" \
    -c "colorscheme $style" \
    -c "qa!" && echo "$style OK"
done
```

#### Kitty

```bash
kitty +kitten themes --dump-theme "Vitesse Dark"
```

#### Herdr

```bash
herdr server reload-config
```

### 5. Commit

```bash
git add -A
git commit -m "feat: update vitesse palette and sync extras"
```

## Adding a New Variant

1. Add a new palette in `lua/vitesse/palette.lua`
2. Add an entry point in `colors/` (e.g. `colors/vitesse-xxx.lua`)
3. Add matching theme files in `extras/herdr/` and `extras/kitty/`
4. Update the variant list in `README.md`
5. Run the test script for all variants

## Local Development

The current Neovim config points lazy.nvim to the local path:

```lua
-- ~/.config/nvim/lua/plugins/vitesse.lua
{
  dir = "~/f/vitesse.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("vitesse-dark")
  end,
}
```

After editing `lua/vitesse/palette.lua` or `lua/vitesse/theme.lua`, restart Neovim to see the changes.
