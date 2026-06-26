# vitesse.nvim

A hand-ported Neovim colorscheme based on [Anthony Fu's Vitesse theme](https://github.com/antfu/vscode-theme-vitesse).

## Variants

- `vitesse` / `vitesse-dark`
- `vitesse-light`
- `vitesse-black`
- `vitesse-dark-soft`
- `vitesse-light-soft`

## Installation

### lazy.nvim

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

### Local development

```lua
{
  dir = "~/f/vitesse.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("vitesse-dark")
  end,
}
```

## Configuration

```lua
require("vitesse").setup({
  style = "dark",          -- default style
  light_style = "light",   -- default style when background is light
  transparent = false,
  terminal_colors = true,
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
  },
  on_colors = function(colors) end,
  on_highlights = function(highlights, colors) end,
})
```

## Extras

This repo also includes theme files for other applications in `extras/`:

- **Herdr** – copy a file from `extras/herdr/` into `~/.config/herdr/config.toml`
- **Kitty** – include a file from `extras/kitty/` in `~/.config/kitty/kitty.conf`, or copy it to `~/.config/kitty/themes/` and pick it with `kitty +kitten themes`

## Contributing

See [AGENTS.md](./AGENTS.md) for the theme management workflow.

## License

MIT
