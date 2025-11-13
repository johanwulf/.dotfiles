# ================================================================== #
# Aliases                                                            #
# ================================================================== #
alias c="clear && printf '\e[3J'"
alias ls="ls -G"
alias la="ls -a"
alias ll="ls -al"
alias dfs='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias src="source ~/.zshenv && source ~/.zshrc"
alias history="history 1"

# ================================================================== #
# History                                                            #
# ================================================================== #
export HISTSIZE=100000
export SAVEHIST=100000
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY

# ================================================================== #
# Exports & Paths                                                    #
# ================================================================== #
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PNPM_HOME="/Users/johan.wulf/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# ================================================================== #
# CTRL + Z to tab in and out of current buffer                       #
# ================================================================== #
ctrlz () {
    if [[ $#BUFFER -eq 0 ]]; then
        BUFFER="fg"
        zle accept-line -w
    else
        zle push-input -w
    fi
}
zle -N ctrlz
bindkey ^Z ctrlz

# ================================================================== #
# CTRL + F to fuzzy find folders in selected paths, cd into it       #
# ================================================================== #
ff () {
    selected=$(find $REPOS_PATH $CONFIG_PATH -type d -not \( -path "*/.git" -prune \) -not \( -path "*/node_modules" -prune \) -not \( -path "*/zsh_plugins" -prune \) | fzf)
    if [[ $selected ]]; then
        cd $selected
        sleep 0.1
        zle accept-line
    fi
}
zle -N ff
bindkey ^F ff

# ================================================================== #
# CTRL + N to fuzzy find in selected paths, open with nvim           #
# ================================================================== #
fn () {
    selected=$(find $REPOS_PATH $CONFIG_PATH -not \( -path "*/.git" -prune \) -not \( -path "*/node_modules" -prune \) -not \( -path "*/zsh_plugins" -prune \) | fzf)
    if [[ $selected ]]; then
        nvim $selected
        zle accept-line
    fi
}
zle -N fn
bindkey ^N fn

# ================================================================== #
# CTRL + T to fuzzy find tmux session, enter or create new           #
# ================================================================== #
ft () {
    if [[ $# -eq 1 ]]; then
        selected=$1
    else
        selected=$(find $REPOS_PATH -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | fzf)
        [[ -n $selected ]] && selected="$REPOS_PATH/$selected"
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
zle -N ft
bindkey ^T ft

# ================================================================== #
# CTRL + H to fuzzy find zsh history                                 #
# ================================================================== #
fh() {
    print -z $(history | sed -re 's/ *[0-9]* *//' | fzf)
    zle accept-line
}
zle -N fh
bindkey ^H fh

# ================================================================== #
# Prompt                                                             #
# ================================================================== #
eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"

# ================================================================== #
# zsh plugin manager                                                 #
# ================================================================== #
zsh_plugin() {
    PLUGIN_NAME="${1#*/}"
    PLUGIN_PATH="$ZSH_PLUGIN_DIR/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh"
    [ ! -d "$ZSH_PLUGIN_DIR" ] && mkdir -p $ZSH_PLUGIN_DIR
    [ ! -f "$PLUGIN_PATH" ] && git clone "https://github.com/$1" $ZSH_PLUGIN_DIR/$PLUGIN_NAME
    source "$PLUGIN_PATH"
}

zsh_plugin "zsh-users/zsh-autosuggestions"
zsh_plugin "jeffreytse/zsh-vi-mode"
zsh_plugin "zsh-users/zsh-syntax-highlighting"

# ================================================================== #
# Optimize compinit - only check once a day                          #
# ================================================================== #
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# ================================================================== #
# gcloud - lazy load to save 31ms on startup                         #
# ================================================================== #
gcloud() {
    # Load gcloud on first use
    if [[ -s "$HOMEBREW_PREFIX/share/google-cloud-sdk/path.zsh.inc" ]]; then
        source "$HOMEBREW_PREFIX/share/google-cloud-sdk/path.zsh.inc"
    fi
    if [[ -s "$HOMEBREW_PREFIX/share/google-cloud-sdk/completion.zsh.inc" ]]; then
        source "$HOMEBREW_PREFIX/share/google-cloud-sdk/completion.zsh.inc"
    fi
    # Remove this function and call the real gcloud
    unfunction gcloud
    gcloud "$@"
}

# ================================================================== #
# Secrets                                                             #
# ================================================================== #
source "$HOME/.zshsecret"

# ================================================================== #
# Work related commands                                              #
# ================================================================== #
source "$HOME/.zshwork"
