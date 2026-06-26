# Agent Guide

Manage the Vitesse theme port in this repo.

## Structure

```
colors/              -- Neovim colorscheme entries
lua/vitesse/
  palette.lua        -- color palettes
  theme.lua          -- highlight groups
  init.lua           -- loader
  config.lua         -- defaults
extras/
  vscode-theme-vitesse/  -- upstream submodule
  herdr/             -- Herdr themes
  kitty/             -- Kitty themes
```

## Source of truth

Colors come from `extras/vscode-theme-vitesse/`.

Update the submodule:

```bash
git submodule update --remote --merge
```

## Changing colors

1. Edit `lua/vitesse/palette.lua`
   - 5 variants: `dark`, `light`, `black`, `dark_soft`, `light_soft`
   - Use 6-digit hex only (Neovim does not support 8-digit hex like `#dbd7caee`)
2. Sync `extras/herdr/*.toml` and `extras/kitty/*.conf`
3. Update `README.md` if adding a new variant

## Testing

Neovim:

```bash
for s in vitesse-dark vitesse-light vitesse-black vitesse-dark-soft vitesse-light-soft; do
  nvim --headless -u NONE -c "set rtp+=~/f/vitesse.nvim" -c "colorscheme $s" -c "qa!" && echo "$s ok"
done
```

Kitty:

```bash
kitty +kitten themes --dump-theme "Vitesse Dark"
```

Herdr:

```bash
herdr server reload-config
```

## Local dev

`~/.config/nvim/lua/plugins/vitesse.lua` points to `~/f/vitesse.nvim`. Restart Neovim after edits.
