alias c="clear && printf '\e[3J'"
alias ls="ls -G"
alias la="ls -a"
alias ll="ls -al"
alias ec="nvim ~/.zshrc"
alias n="nvim"
alias dfs='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias src="source ~/.zshenv && source ~/.zshrc"

ctrlz () {
    if [[ $#BUFFER -eq 0 ]]; then
        BUFFER="fg"
        zle accept-line -w
    else
        zle push-input -w
    fi
}

# fuzzy folder
ff () {
    selected=$(find $WORK_PATH $PERSONAL_PATH $CONFIG_PATH -type d -not \( -path "*/.git" -prune \) -not \( -path "*/node_modules" -prune \) -not \( -path "*/zsh_plugins" -prune \) | fzf)
    if [[ $selected ]]; then
        cd $selected
        sleep 0.1
        zle accept-line
    fi
}

# fuzzy nvim
fn () {
    selected=$(find $WORK_PATH $PERSONAL_PATH $CONFIG_PATH -not \( -path "*/.git" -prune \) -not \( -path "*/node_modules" -prune \) -not \( -path "*/zsh_plugins" -prune \) | fzf)
    if [[ $selected ]]; then
        nvim $selected
        zle accept-line
    fi
}

# fuzzy tmux
ft () {
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

zle -N ctrlz
bindkey ^Z ctrlz

zle -N fn
bindkey ^N fn

zle -N ff
bindkey ^F ff

zle -N ft
bindkey ^T ft

export NVM_DIR="$HOME/.nvm"
    [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
    [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# bun completions
[ -s "/Users/johan.wulf/.bun/_bun" ] && source "/Users/johan.wulf/.bun/_bun"

eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# psql
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# gcloud
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

plugin() {
    PLUGIN_NAME="${1#*/}"
    [ ! -d "$ZSH_PLUGIN_DIR" ] && mkdir -p $ZSH_PLUGIN_DIR
    [ ! -f "$ZSH_PLUGIN_DIR/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" ] && git clone "https://github.com/$1" $ZSH_PLUGIN_DIR/$PLUGIN_NAME
    source "$ZSH_PLUGIN_DIR/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh"
}

plugin "zsh-users/zsh-syntax-highlighting"
plugin "zsh-users/zsh-autosuggestions"
