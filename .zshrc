if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    source ~/.zshrc_linux
elif [[ "$OSTYPE" == "darwin"* ]]; then
    source ~/.zshrc_osx
fi

# Directory stack
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

# Alias
alias c="clear && printf '\e[3J'"
alias la="ls -a"
alias ll="ls -al"
alias ec="nvim ~/.zshrc"
alias n="nvim"
alias dfs='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Functions
# Used to be able to toggle back and forth between nvim and terminal 
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line -w
  else
    zle push-input -w
  fi
}

# Fuzzy find folders in personal and work directory, and cd into them
fzf-folder () {
    cd $(find $WORK_PATH $PERSONAL_PATH $CONFIG_PATH ~ -mindepth 0 -maxdepth 1 | fzf)
    sleep 0.1
    zle accept-line
}

# Fuzzy find folders and files and open them with nvim
fzf-nvim () {
    nvim $(find $WORK_PATH $PERSONAL_PATH $HOME/.config -not \( -path "*/.git" -prune \) -not \( -path "*/node_modules" -prune \) -not \( -path "*/zsh_plugins" -prune \) | fzf)
    zle accept-line
}

fzf-tmux () {
if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find $WORK_PATH $PERSONAL_PATH $CONFIG_PATH ~ -mindepth 0 -maxdepth 1 | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi

tmux switch-client -t $selected_name
}

# Keybindings
zle -N fancy-ctrl-z
bindkey ^Z fancy-ctrl-z

zle -N fzf-nvim
bindkey ^N fzf-nvim

zle -N fzf-folder
bindkey ^F fzf-folder

zle -N fzf-tmux
bindkey ^T fzf-tmux

# Starship
eval "$(starship init zsh)"

# bun completions
[ -s "/Users/johan.wulf/.bun/_bun" ] && source "/Users/johan.wulf/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Custom plugin manager
plugin() {
    PLUGIN_NAME="${1#*/}"
    [ ! -d "$ZSH_PLUGIN_DIR" ] && mkdir -p $ZSH_PLUGIN_DIR
    [ ! -f "$ZSH_PLUGIN_DIR/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" ] && git clone "https://github.com/$1" $ZSH_PLUGIN_DIR/$PLUGIN_NAME
    source "$ZSH_PLUGIN_DIR/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh"
}

plugin "zsh-users/zsh-syntax-highlighting"
plugin "zsh-users/zsh-autosuggestions"
