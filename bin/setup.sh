#!/bin/bash
clear
echo -e "\033[1;34mjohanwulf setup\033[0m"
echo ""
echo "This script will set up Homebrew, packages and config files"
echo "If you do not know what you are doing, do not proceed"
echo " "
echo -e "\033[1;31mProceeding with installation will back up and move the following files\033[0m"
echo "~/.config/*"
echo "~/.zshrc"
echo "~/.hushlogin"
echo "~/.dotfiles/*"

which -s brew

if [[ $? != 0 ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew install gum
else
  which -s gum
  if [[ $? != 0 ]]; then
    brew install gum
  fi
fi

gum confirm "Do you wish to continue?" && echo "" || exit 0

gum spin --spinner dot --title "Backing up files..." -- dotfiles-backup.sh
echo "✅ Files backed up"

git clone --bare git@github.com-personal:johanwulf/dotfiles.git $HOME/.dotfiles
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@"
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@ checkout
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@ config status.showUntrackedFiles no

echo "✅ Dotfiles cloned"


gum spin --spinner dot --title "Running brew update..." -- brew update
echo "✅ brew updated"
gum spin --spinner dot --title "Running brew upgrade..." -- brew upgrade
echo "✅ brew upgraded"
gum spin --spinner dot --title "Installing brew bundle packages..." -- brew bundle --file=~/.config/Brewfile
echo "✅ brew packages installed"

echo ""

echo "Done!"
