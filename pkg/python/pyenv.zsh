# virtualenv config
export VIRTUALENV_USE_DISTRIBUTE=1
export VIRTUALENV_NO_SITE_PACKAGES=1  # 设置所有虚拟环境与系统site-packages进行隔离

# pyenv
export PYENV_ROOT="${HOME}/.pyenv"
export PATH="$PATH:${PYENV_ROOT}/bin:/usr/local/bin"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"