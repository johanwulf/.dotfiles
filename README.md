# Wulf dotfiles
These are my dotfiles, which are managed by a bare Git repository. The choice of going with a bare Git repository instead of, e.g. symlinking, was for simplicity and reproducability.

[Tutorial for a bare git repository from scratch](https://www.atlassian.com/git/tutorials/dotfiles)

Since this repository is already setup, the easiest way to use the following script

[Script link](https://gist.github.com/johanwulf/5f3a0d7cad6ba672740c381d945e172b)

Simply save that Gist to a .sh file and run it. It will move all current dotfiles to a dotfiles-backup folder, and then setup the repository.


Other dependencies:

## Homebrew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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

## To do:
- [ ] Update Gist to also download all dependencies
- [ ] Create custom domain for the setup script for easy access, for instance wulf.gg/setup 
