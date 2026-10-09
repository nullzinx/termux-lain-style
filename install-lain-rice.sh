#!/data/data/com.termux/files/usr/bin/bash
set -eu

mkdir -p \
  "$HOME/.config/nvim" \
  "$HOME/.termux" \
  "$HOME/.local/bin"

mv ./lain.txt ~/.config/fastfetch/lain.txt

cat > "$HOME/.zshrc" <<'EOF'
echo
clear
fastfetch --structure title:separator:os:host:kernel:uptime:packages:shell:display:de:wm:terminal:terminalfont --logo ~/.config/fastfetch/lain.txt
autoload -Uz vcs_info
autoload -Uz compinit
compinit -C

setopt AUTO_CD
setopt HIST_IGNORE_DUPS
setopt HIST_SAVE_NO_DUPS
setopt INTERACTIVE_COMMENTS
setopt PROMPT_SUBST

HISTFILE="$HOME/.zsh_history"
HISTSIZE=2000
SAVEHIST=2000

export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export CLICOLOR=1
export TERM=xterm-256color

zstyle ':vcs_info:git:*' formats ' [%b]'
zstyle ':vcs_info:git:*' actionformats ' [%b|%a]'

_precmd_lain() {
  vcs_info
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _precmd_lain

PROMPT='%F{green}null%f %F{240}::%f %F{cyan}%~%f%F{green}${vcs_info_msg_0_}%f
%F{green}λ%f '

alias v='nvim'
alias c='clear'
alias ll='ls -lah'
alias la='ls -A'
alias grep='grep --color=auto'

EOF

cat > "$HOME/.config/nvim/init.lua" <<'EOF'
vim.g.mapleader = " "

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.background = "dark"
opt.wrap = false
opt.scrolloff = 4
opt.sidescrolloff = 4
opt.splitright = true
opt.splitbelow = true
opt.ignorecase = true
opt.smartcase = true
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.updatetime = 500
opt.timeoutlen = 400
opt.completeopt = { "menuone", "noselect" }
opt.laststatus = 2
opt.showmode = false
opt.cmdheight = 1
opt.mouse = "a"

vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

local colors = {
  bg = "#080b0a",
  fg = "#b6c9b8",
  green = "#8cff98",
  bright = "#c0ffca",
  dim = "#53695a",
  cyan = "#83c9b0",
  red = "#d87878",
  selection = "#18251c",
}

vim.api.nvim_set_hl(0, "Normal", { fg = colors.fg, bg = colors.bg })
vim.api.nvim_set_hl(0, "NormalFloat", { fg = colors.fg, bg = colors.bg })
vim.api.nvim_set_hl(0, "LineNr", { fg = colors.dim, bg = colors.bg })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.green, bold = true })
vim.api.nvim_set_hl(0, "CursorLine", { bg = colors.selection })
vim.api.nvim_set_hl(0, "SignColumn", { bg = colors.bg })
vim.api.nvim_set_hl(0, "Visual", { bg = "#243b2a" })
vim.api.nvim_set_hl(0, "Search", { fg = colors.bg, bg = colors.green })
vim.api.nvim_set_hl(0, "IncSearch", { fg = colors.bg, bg = colors.cyan })
vim.api.nvim_set_hl(0, "Comment", { fg = colors.dim, italic = true })
vim.api.nvim_set_hl(0, "String", { fg = colors.green })
vim.api.nvim_set_hl(0, "Function", { fg = colors.cyan })
vim.api.nvim_set_hl(0, "Keyword", { fg = colors.green, bold = true })
vim.api.nvim_set_hl(0, "Type", { fg = colors.bright })
vim.api.nvim_set_hl(0, "Statement", { fg = colors.green })
vim.api.nvim_set_hl(0, "Constant", { fg = "#b4dfb8" })
vim.api.nvim_set_hl(0, "Identifier", { fg = colors.fg })
vim.api.nvim_set_hl(0, "Pmenu", { fg = colors.fg, bg = "#142019" })
vim.api.nvim_set_hl(0, "PmenuSel", { fg = colors.bg, bg = colors.green })
vim.api.nvim_set_hl(0, "StatusLine", { fg = colors.green, bg = "#101713" })
vim.api.nvim_set_hl(0, "StatusLineNC", { fg = colors.dim, bg = colors.bg })
vim.api.nvim_set_hl(0, "VertSplit", { fg = "#26372b", bg = colors.bg })
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = colors.red })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#d9c27a" })

opt.statusline = " %f %m%=%y  %l:%c "

local map = vim.keymap.set
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Salvar" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Sair" })
map("n", "<leader>e", "<cmd>Ex<cr>", { desc = "Explorador" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Limpar busca" })
map("n", "<leader>h", "<C-w>h")
map("n", "<leader>j", "<C-w>j")
map("n", "<leader>k", "<C-w>k")
map("n", "<leader>l", "<C-w>l")
EOF

cat > "$HOME/.tmux.conf" <<'EOF'
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",xterm-256color:Tc"
set -g history-limit 2000
set -g escape-time 10
set -g focus-events off
set -g status-interval 10
set -g renumber-windows on
set -g base-index 1
setw -g pane-base-index 1
set -g mouse on

set -g prefix C-a
unbind C-b
bind C-a send-prefix

bind | split-window -h
bind - split-window -v
bind r source-file ~/.tmux.conf \; display-message "LAIN // config reloaded"

set -g status-position bottom
set -g status-style "bg=#080b0a,fg=#53695a"
set -g message-style "bg=#18251c,fg=#8cff98"
set -g pane-border-style "fg=#26372b"
set -g pane-active-border-style "fg=#8cff98"
set -g status-left-length 24
set -g status-right-length 28
set -g status-left "#[fg=#8cff98,bold] LAIN #[fg=#53695a]// #S "
set -g status-right "#[fg=#53695a]%H:%M  %d-%m "
setw -g window-status-format " #[fg=#53695a]#I:#W "
setw -g window-status-current-format " #[fg=#8cff98,bold]#I:#W* "
setw -g window-status-separator ""
EOF

cat > "$HOME/.termux/colors.properties" <<'EOF'
background=#080b0a
foreground=#b6c9b8
cursor=#8cff98
color0=#080b0a
color1=#d87878
color2=#8cff98
color3=#d9c27a
color4=#83a8a0
color5=#a2a0bd
color6=#83c9b0
color7=#b6c9b8
color8=#53695a
color9=#e99a9a
color10=#b5ffbd
color11=#eee0a5
color12=#a0c8c0
color13=#c0b8dc
color14=#a5ead0
color15=#e2f0e3
EOF

cat > "$HOME/.termux/termux.properties" <<'EOF'
use-black-ui = true
terminal-cursor-style = block
terminal-cursor-blink-rate = 0
terminal-transcript-rows = 1000
extra-keys = [[ESC, CTRL, ALT, TAB, {key: '-', popup: '|'}, {key: '<', popup: '{'}, {key: '>', popup: '}'}], [HOME, UP, END, PGUP, LEFT, DOWN, RIGHT, PGDN]]
EOF

echo
echo "lain rice installed"
echo "by nullzinx"
echo "restart termux and enjoy :D "
