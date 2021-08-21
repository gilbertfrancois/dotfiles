# ZSH Theme - Red alert
# Author: Gilbert Francois Duivesteijn
# Prompt is the Oh-my-zsh version of user Graawr's 'Classy Touch' themes on http://dotshare.it

local current_dir='%{$fg[red]%}[%{$reset_color%}%~% %{$fg[red]%}]%{$reset_color%}'
local current_host='%{$fg[red]%}[%{$reset_color%}%m% %{$fg[red]%}]%{$reset_color%}'
local hostname_='%hostname'
local git_branch='$(git_prompt_info)%{$reset_color%}'
virt_env='$(virtualenv_prompt_info)%{$reset_color%}'

PROMPT="%(?,
%{$fg[red]%}┌─╼${current_host}${current_dir}%{$reset_color%}${virt_env}${git_branch}
%{$fg[red]%}└────╼%{$reset_color%} ,
%{$fg[red]%}┌─╼${current_host}${current_dir}%{$reset_color%}${virt_env}${git_branch}
%{$fg[red]%}└╼ %{$reset_color%} "

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[red]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_VIRTUALENV_PREFIX=" %{$fg[yellow]%}["
ZSH_THEME_VIRTUALENV_SUFFIX="]%{$reset_color%}"
