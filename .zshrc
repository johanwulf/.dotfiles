# Import aliases common for work/private
if [ -f ~/.config/.zsh_common ]; then
    source ~/.config/.zsh_common
fi

# Import aliases related to work
if [ -f ~/.config/.zsh_work ]; then
    source ~/.config/.zsh_work
fi

# Node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

eval "$(starship init zsh)"
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

# TODO: Check if dependencies are installed, if not - install them

# Install zsh-autosuggestions if not present 
if [[ ! -d "$HOME/.config/zsh_plugins/zsh-autosuggestions/" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh_plugins/zsh-autosuggestions
fi

# Install zsh-syntax-highlighting if not present 
if [[ ! -d "$HOME/.config/zsh_plugins/zsh-syntax-highlighting/" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh_plugins/zsh-syntax-highlighting
fi

source ~/.config/zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
