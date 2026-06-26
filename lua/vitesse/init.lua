local config = require("vitesse.config")
local palette = require("vitesse.palette")

local M = {}

M.styles = {}

---@param opts? vitesse.Config
function M.load(opts)
  opts = config.extend(opts)

  local style = opts.style
  local is_light = style == "light" or style == "light_soft"
  local style_bg = is_light and "light" or "dark"

  if vim.o.background ~= style_bg then
    if vim.g.colors_name and vim.g.colors_name:find("vitesse") then
      style = vim.o.background == "light" and (M.styles.light or opts.light_style) or (M.styles.dark or "dark")
    else
      vim.o.background = style_bg
    end
  end
  M.styles[vim.o.background] = style

  local c = palette.get(style)
  opts.on_colors(c)

  if vim.g.colors_name then
    vim.cmd("hi clear")
  end

  vim.o.termguicolors = true
  vim.g.colors_name = "vitesse-" .. style:gsub("_", "-")

  local hl = require("vitesse.theme").get(c, opts)
  opts.on_highlights(hl, c)

  for group, val in pairs(hl) do
    val = type(val) == "string" and { link = val } or val
    vim.api.nvim_set_hl(0, group, val)
  end

  return c, hl, opts
end

M.setup = config.setup

return M
