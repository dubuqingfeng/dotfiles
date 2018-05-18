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
  ccat
  git-flow
  tree
  gpg
  mackup
  z
  tmux
  htop
  trash
  proxychains-ng
  pyenv
  gettext
  netcat
  gdb
  gcc
  node
  nvm
  httpie
  # 数据库
  mysql
  nmap
  go
  imagemagick
  # composer
  wrk
  automake
  autoconf
  curl
  pcre
  bison
  mhash
  libtool
  icu4c
  jpeg
  openssl
  libxml2
  mcrypt
  gmp
  libevent
  
  zlib
  # homebrew/nginx was deprecated. This tap is now empty as all its formulae were migrated.
  # homebrew/nginx/openresty
  
  #编译bitcoin
# brew Installing
  #automake 
  berkeley-db4 
  #libtool 
  boost --c++11 
  miniupnpc 
  #openssl 
  pkg-config 
  protobuf --c++11 
  qt5 
  #libevent
  librsvg
  tldr
  homebrew/core/php
  # /usr/local/Cellar/php/7.2.5/bin/pecl install swoole
  # /usr/local/Cellar/php/7.2.5/bin/pecl install xdebug
  hiredis
  kompose
  jenkins
  # docker 改为dockerformac
  # subversion
  # tomcat
  # mysql
  # nginx
  # mongodb

  # hub
  # legit
  # ssh-copy-id
)

# Apps
apps=(
  java
  google-chrome
  iterm2 # 加强版终端
  firefox
  robo-3t
  pycharm-ce
  the-unarchiver
  evernote
  sublime-text
  ngrok
  xmind
  licecap # 录屏gif软件
  # dash
  appcleaner # 卸载软件
  grandperspective # 磁盘空间分析软件
  intellij-idea
  # phpstorm
  visual-studio-code
  typora
  charles
  android-file-transfer
  nutstore
  macpass
  sequel-pro  #下载速度慢，需手动安装
  rdm
  docker
  kitematic
  minikube
  1password
  postman
  gpg-suite
  ## work
  bearychat
  slack
  pomotodo
  neteasemusic
  virtualbox
  #####
  # 
  # 手动安装：
  # sourcetree # git
  # shadowsocksx # shadowsocks
  # shadowsocksx-ng
  # beyond-compare # 对比软件
  # qq
  # chrome App:
  # chromebook recovery
  #
  # Apple store:
  # pocket
  # 
  # 付费软件：
  # reeder3
  # alfred
  #####
  # jadx
)

# Fonts
fonts=(
  # font-roboto
  font-source-code-pro
)

echo "Update Homebrew..."
# Update homebrew recipes
brew update

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils
# Install Bash 4
brew install bash
# Install Homebrew Cask
brew tap caskroom/cask
brew tap caskroom/fonts
brew tap caskroom/versions

#安装phpbrew
brew link --force openssl
brew link --force libxml2

echo "Installing binaries..."
brew install ${binaries[@]}

echo "Installing fonts..."
brew cask install ${fonts[@]}

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "Installing apps..."
brew cask install --appdir="/Applications" ${apps[@]}

# clean things up
brew cleanup
brew cask cleanup

exit 0
