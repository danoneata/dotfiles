My dotfiles, to easily synchronize the settings across different machines.

Most of the code is copied shamelessly from various sources. Some cleaning is
necessary at the moment.

To add a new submodule to the repository:

  cd ~/dotfiles
  git submodule add http://github.com/name/package.git vim.clean/bundle/package
  git add vim.clean/bundle/.
  git commit -m "Installed package.vim bundle as a submodule."

To synchronize on a remote machine, do the following:

  cd ~/dotfiles
  git submodule init
  git submodule update
