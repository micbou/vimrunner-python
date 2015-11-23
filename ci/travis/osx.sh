function brew() {
  command brew "$@" || command brew "$@"
}

brew update
brew install --ignore-dependencies macvim --with-python --with-override-system-vim
