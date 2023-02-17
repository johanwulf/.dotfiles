# Wulf dotfiles
These are my dotfiles, which are managed by a bare Git repository. The choice of going with a bare Git repository instead of, e.g. symlinking, was for simplicity and reproducability.

[Tutorial for a bare git repository from scratch](https://www.atlassian.com/git/tutorials/dotfiles)

Since this repository is already setup, the easiest way to use the following script

[Script link](http://setup.wulf.gg/)
To easily setup, do the following
```bash
curl -L setup.wulf.gg >> setup.sh
chmod +x setup.sh
./setup.sh
```

Other dependencies:

## Homebrew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Nerd Font
```
brew tap homebrew/cask-fonts && brew install --cask font-go-mono-nerd-font
```

## Git
```
brew install git
```

## Kitty
```
brew install --cask kitty
```

## Neovim
```
brew install neovim
```

## fd
```
brew install fd
```

## rg
```
brew install rigrep
```
## lazygit
```
brew install jesseduffield/lazygit/lazygit
```

## To do:
- [ ] Update Gist to also download all dependencies
