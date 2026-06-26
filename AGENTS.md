# Vitesse Theme 管理指南

本仓库是 Vitesse 主题的统一管理仓库，包含 Neovim colorscheme 以及 Herdr / Kitty 等终端/应用主题。

## 项目结构

```
.
├── colors/                       # Neovim colorscheme 入口
│   ├── vitesse.lua
│   ├── vitesse-dark.lua
│   ├── vitesse-light.lua
│   ├── vitesse-black.lua
│   ├── vitesse-dark-soft.lua
│   └── vitesse-light-soft.lua
├── lua/vitesse/
│   ├── init.lua                  # 主题加载器
│   ├── config.lua                # 用户配置默认值
│   ├── palette.lua               # 所有 variant 的色板定义
│   └── theme.lua                 # highlight groups 定义
├── extras/
│   ├── vscode-theme-vitesse/     # 源主题 submodule
│   ├── herdr/                    # Herdr 主题配置
│   └── kitty/                    # Kitty 终端主题
└── README.md
```

## 颜色来源

所有颜色最终来自上游仓库 [vscode-theme-vitesse](https://github.com/antfu/vscode-theme-vitesse)，通过 git submodule 引入：

```bash
git submodule update --remote --merge
```

关键源文件：

- `extras/vscode-theme-vitesse/scripts/colors.ts` —— 基础色阶（灰、蓝、绿、红等）
- `extras/vscode-theme-vitesse/scripts/colors.ts` 中的 `VitesseThemes` —— 主题语义色（foreground、background、string、keyword、green、cyan 等）
- `extras/vscode-theme-vitesse/extra/xterm-*.json` —— 终端 ANSI 映射参考

## 修改主题时的流程

### 1. 更新上游 submodule

当 vscode-theme-vitesse 有更新时，先拉取：

```bash
cd extras/vscode-theme-vitesse
git pull origin main
cd ../..
git add extras/vscode-theme-vitesse
git commit -m "chore: update vscode-theme-vitesse submodule"
```

### 2. 同步 Neovim 色板

修改 `lua/vitesse/palette.lua`：

- 保持 5 个 variant：`dark`、`light`、`black`、`dark_soft`、`light_soft`
- 每个 variant 至少包含以下语义颜色：
  - 背景系：`bg`、`bg_dark`、`bg_highlight`、`bg_visual`、`bg_search`、`bg_float`、`bg_popup`、`bg_statusline`
  - 前景系：`fg`、`fg_dark`、`fg_gutter`、`fg_float`
  - 边框：`border`、`border_highlight`
  - 语义色：`comment`、`string`、`variable`、`keyword`、`number`、`boolean`、`operator`、`func`、`constant`、`class`、`interface`、`type`、`builtin`、`property`、`namespace`、`punctuation`、`decorator`、`regex`
  - 通用色：`red`、`green`、`yellow`、`blue`、`cyan`、`magenta`、`orange`
  - Git：`git.add`、`git.change`、`git.delete`、`git.ignore`
  - Diff：`diff.add`、`diff.delete`、`diff.change`、`diff.text`
  - 诊断：`error`、`warning`、`info`、`hint`、`todo`、`note`
  - 终端：`terminal.black` ... `terminal.white_bright`

注意：Neovim 的 `nvim_set_hl` 不支持 8 位 hex（如 `#dbd7caee`），必须转换为 6 位 hex（`#dbd7ca`）。

### 3. 同步终端 extras

#### Herdr

`extras/herdr/*.toml` 只覆盖 Herdr 支持的 `[theme.custom]` 键：

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

`extras/kitty/*.conf` 需要包含 Kitty 主题标准字段：

- `foreground`、`background`、`cursor`、`selection_foreground`、`selection_background`
- 边框/标题栏/标签栏：`active_border_color`、`inactive_border_color`、`active_tab_background` 等
- ANSI：`color0` - `color15`
- metadata header：

```conf
# vim:ft=kitty
## name: Vitesse Dark
## author: Anthony Fu
## license: MIT
## upstream: https://github.com/antfu/vscode-theme-vitesse
## blurb: ...
```

### 4. 测试

#### Neovim

```bash
nvim --headless -u NONE \
  -c "set rtp+=~/f/vitesse.nvim" \
  -c "colorscheme vitesse-dark" \
  -c "qa!"
```

要测试所有 variant：

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

### 5. 提交

```bash
git add -A
git commit -m "feat: update vitesse palette and sync extras"
```

## 新增 variant 的流程

1. 在 `lua/vitesse/palette.lua` 添加新 palette
2. 在 `colors/` 添加入口文件 `vitesse-xxx.lua`
3. 在 `extras/herdr/` 和 `extras/kitty/` 添加对应主题文件
4. 更新 `README.md` 的 variant 列表
5. 运行测试脚本

## 本地开发

当前 Neovim 配置通过 lazy.nvim 指向本地路径：

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

修改 `lua/vitesse/palette.lua` 或 `lua/vitesse/theme.lua` 后，重启 Neovim 即可生效。
