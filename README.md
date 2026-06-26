# vitesse.nvim

Neovim colorscheme ported from [vscode-theme-vitesse](https://github.com/antfu/vscode-theme-vitesse).

## Variants

- `vitesse` / `vitesse-dark`
- `vitesse-light`
- `vitesse-black`
- `vitesse-dark-soft`
- `vitesse-light-soft`

## Install

```lua
{
  "kvoon3/vitesse.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("vitesse-dark")
  end,
}
```

## Options

```lua
require("vitesse").setup({
  style = "dark",
  light_style = "light",
  transparent = false,
  terminal_colors = true,
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
  },
  on_colors = function(colors) end,
  on_highlights = function(hl, colors) end,
})
```

## Extras

- `extras/herdr/` — Herdr theme configs
- `extras/kitty/` — Kitty terminal themes

See [AGENTS.md](./AGENTS.md) for the theme workflow.

## License

MIT
