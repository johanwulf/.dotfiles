# ================================================================== #
# Aliases                                                            #
# ================================================================== #
alias c="clear && printf '\e[3J'"
alias ls="ls -G"
alias la="ls -a"
alias ll="ls -al"
alias dfs='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias src="source ~/.zshenv && source ~/.zshrc"
alias docker="podman"
alias claude="SHELL=/bin/bash claude"
alias "docker-compose"="podman-compose"
alias gspp="git stash && git pull && git stash pop" # (g)it (s)tash (p)ull (p)op
alias history="history 1"

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
        selected=$(find $REPOS_PATH $CONFIG_PATH ~ -mindepth 0 -maxdepth 1 | fzf)
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

bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

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
# Exports, paths and stuff                                           #
# ================================================================== #
export NVM_DIR="$HOME/.nvm"
export SDKMAN_DIR="$HOME/.sdkman"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# ================================================================== #
# zsh plugin manager                                                 #
# ================================================================== #
zsh_plugin() {
    PLUGIN_NAME="${1#*/}"
    [ ! -d "$ZSH_PLUGIN_DIR" ] && mkdir -p $ZSH_PLUGIN_DIR
    [ ! -f "$ZSH_PLUGIN_DIR/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" ] && git clone "https://github.com/$1" $ZSH_PLUGIN_DIR/$PLUGIN_NAME
    source "$ZSH_PLUGIN_DIR/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh"
}

zsh_plugin "zsh-users/zsh-syntax-highlighting"
zsh_plugin "zsh-users/zsh-autosuggestions"
zsh_plugin "jeffreytse/zsh-vi-mode"
zsh_plugin "qoomon/zsh-lazyload"

# ================================================================== #
# Sourcing                                                           #
# ================================================================== #
lazyload sdk -- "source $HOME/.sdkman/bin/sdkman-init.sh"
lazyload nvm -- "source $HOMEBREW_PREFIX/opt/nvm/nvm.sh"
lazyload gcloud -- "source $HOMEBREW_PREFIX/share/google-cloud-sdk/path.zsh.inc"
lazyload -- source "$HOMEBREW_PREFIX/share/google-cloud-sdk/completion.zsh.inc"
lazyload -- source "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
source "$HOME/.zshsecret"

# ================================================================== #
# zsh plugin manager                                                 #
# ================================================================== #
tmux_plugin() {
    PLUGIN_NAME="${1#*/}"
    [ ! -d "$TMUX_PLUGIN_DIR" ] && mkdir -p $TMUX_PLUGIN_DIR
    [ ! -f "$TMUX_PLUGIN_DIR/$PLUGIN_NAME/$PLUGIN_NAME" ] && git clone "https://github.com/$1" $TMUX_PLUGIN_DIR/$PLUGIN_NAME
}

tmux_plugin "tmux-plugins/tpm"

# ================================================================== #
# Evals                                                              #
# ================================================================== #
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"

export JAVA_HOME="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
export PATH=$JAVA_HOME/bin:$PATH

# pnpm
export PNPM_HOME="/Users/johan.wulf/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
