local M = {}

---@class vitesse.Config
M.defaults = {
  style = "black",
  light_style = "light_soft",
  transparent = false,
  terminal_colors = true,
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
  },
  dim_inactive = false,
  on_colors = function(colors) end,
  on_highlights = function(highlights, colors) end,
}

---@type vitesse.Config
M.options = nil

---@param options? vitesse.Config
function M.setup(options)
  M.options = vim.tbl_deep_extend("force", {}, M.defaults, options or {})
end

---@param opts? vitesse.Config
function M.extend(opts)
  return opts and vim.tbl_deep_extend("force", {}, M.options, opts) or M.options
end

setmetatable(M, {
  __index = function(_, k)
    if k == "options" then
      return M.defaults
    end
  end,
})

return M
