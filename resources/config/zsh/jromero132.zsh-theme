# Author: Jose A. Romero (jromero132)

# This is my (jromero132) custom ZSH theme
# Doc: https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html#Prompt-Expansion

# Font type
local f_bold="$FX[bold]"
local f_no_bold="$FX[no-bold]"

# Colors
local c_gray="$FG[247]"
local c_white="$FG[255]"
local c_cyan="$FG[014]"
local c_dark_green="$FG[038]"
local c_green="$FG[047]"
local c_red="$FG[009]"

local time="${c_gray}[%D{%H:%m:%S}]"                                 # hh:mm:ss
local username="${c_dark_green}%n"                                   # user
local return_code="${f_bold}%(?:${c_green}✔:${c_red}✖)${f_no_bold}"  # ✔ success | ✖ fail
local current_dir="${f_bold}${c_cyan}%~${f_no_bold}"                 # ~/Downloads
# local current_dir="%{$fg_bold[cyan]%}%~%{$reset_color%}"
local separator="${c_gray} » "                                         # »
local cmd_number="«%!»"
local is_admin="%(#:😎:👀)"                                          # 😎 root (uid 0) | 👀 no root

# Left/normal prompt
PROMPT="${time} ${username} ${return_code} ${current_dir}${separator}"
# PROMPT+='$(git_prompt_info)${c_white}'

# Right prompt
RPROMPT="${cmd_number} ${is_admin}"

# Git prompt
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%{$fg[white]%}➤ "
ZSH_THEME_GIT_PROMPT_DIRTY="★%{$fg[blue]%}★)"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

# »