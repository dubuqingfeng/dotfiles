# virtualenv config
export VIRTUALENV_USE_DISTRIBUTE=1
export VIRTUALENV_NO_SITE_PACKAGES=1  # 设置所有虚拟环境与系统site-packages进行隔离

# pyenv
export PYENV_ROOT="${HOME}/.pyenv"
export PATH="/opt/homebrew/opt/tcl-tk/bin:$PATH"
# export PATH="$PATH:${PYENV_ROOT}/bin:/usr/local/bin:/opt/homebrew/Cellar/python@3.10/3.10.8/bin"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"