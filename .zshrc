# Import aliases common for work/private
if [ -f ~/.config/.zsh_common ]; then
    source ~/.config/.zsh_common
fi

# Import aliases related to work
if [ -f ~/.config/.zsh_work ]; then
    source ~/.config/.zsh_work
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(starship init zsh)"
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'