FOLDER="$HOME/dotfiles-backup-$(date +%Y-%m-%d_%H-%M-%S)"
mkdir $FOLDER
mv ~/.config/ $FOLDER/.config/
mv ~/.dotfiles/ $FOLDER/.dotfiles/
mv ~/.hushlogin $FOLDER/.hushlogin
mv ~/.zshrc $FOLDER/.zshrc
