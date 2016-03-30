# !/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Binaries
binaries=(
  dos2unix
  wget
  python
  ctags
  grc
  git-flow
  tree
  mackup
  z
  tmux
  htop
  trash
  proxychains-ng
  pyenv
  gettext
  # subversion

  # mysql
  # nginx
  # mongodb

  # boot2docker
  # docker

  # grc
  # hub
  # legit
  # nvm
  # ssh-copy-id
)

# Apps
apps=(
  java
  google-chrome
  iterm2 # 加强版终端
  firefox
  scroll-reverser  # 可以分别鼠标和触控板滚动方向
  the-unarchiver  # 免费的解压软件
  android-studio # 较大
  robomongo # mongodb client
  lingon-x # 启动项管理
  pycharm-ce
  evernote
  sublime-text3
  filezilla
  vagrant
  vagrant-manager
  xmind
  licecap # 录屏gif软件
  dash
  thunder 
  appcleaner # 卸载软件
  grandperspective # 磁盘空间分析软件
  mactex
  # macdown # markdown编辑器
  # sourcetree # git
  # sequel-pro # mysql client
  # shadowsocksx # shadowsocks
  # beyond-compare # 对比软件
  # virtualbox
  # Postman chrome 扩展
)

# Fonts
fonts=(
  # font-roboto
  font-source-code-pro
)

echo "Update Homebrew..."
# Update homebrew recipes
# brew update

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils
# Install Bash 4
brew install bash
# Install Homebrew Cask
brew tap caskroom/fonts
brew tap caskroom/versions
brew install caskroom/cask/brew-cask
brew upgrade brew-cask

echo "Installing binaries..."
brew install ${binaries[@]}

echo "Installing fonts..."
brew cask install ${fonts[@]}

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "Installing apps..."
sudo brew cask install --appdir="/Applications" ${apps[@]}

# clean things up
brew cleanup
brew cask cleanup

exit 0
