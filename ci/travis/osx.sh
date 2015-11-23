function brew() {
  command brew "$@" || command brew "$@"
}

brew update
brew install --ignore-dependencies macvim --with-python --with-override-system-vim

# install pyenv
git clone https://github.com/yyuu/pyenv.git ~/.pyenv
PYENV_ROOT="$HOME/.pyenv"
PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

case "${TOXENV}" in
    py26)
        curl -O https://bootstrap.pypa.io/get-pip.py
        python get-pip.py --user
        ;;
    py27)
        curl -O https://bootstrap.pypa.io/get-pip.py
        python get-pip.py --user
        ;;
    py33)
        pyenv install 3.3.6
        pyenv global 3.3.6
        ;;
    py34)
        pyenv install 3.4.2
        pyenv global 3.4.2
        ;;
    py35)
        pyenv install 3.5.0
        pyenv global 3.5.0
        ;;
esac

pyenv rehash
python -m pip install --user virtualenv

python -m virtualenv ~/.venv
source ~/.venv/bin/activate

pip install --disable-pip-version-check --upgrade pip
pip install tox
