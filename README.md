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
The setup script will download all needed dependencies. It will also remove any files that it would overwrite, and is intended for new machines only. Consider backing up any of the affected files.
