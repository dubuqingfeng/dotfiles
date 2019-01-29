# !/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Binaries
binaries=(
  # language
  python
  # python@2
  go
  dep
  homebrew/core/php

  dos2unix
  wget
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
  # security
  sqlmap
  # Node
  node@8
  nvm
  httpie
  pstree
  privoxy
  textql
  kafka
  # 数据库
  mysql
  nmap
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
  maven
  zlib
  # homebrew/nginx was deprecated. This tap is now empty as all its formulae were migrated.
  # homebrew/nginx/openresty
  
  solidity
  #编译bitcoin
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
  # /usr/local/Cellar/php/7.2.5/bin/pecl install swoole
  # /usr/local/Cellar/php/7.2.5/bin/pecl install xdebug
  hiredis
  consul-template
  # CI / CD
  jenkins
  # jenkins-x/jx/jx
  kubernetes-helm
  # mysql
  # nginx
  # mongodb
  # hub
  # legit
  # ssh-copy-id
)

# Apps
apps=(
  # language
  java
  # browsers
  google-chrome
  firefox
  
  iterm2 # 加强版终端
  the-unarchiver
  # note
  evernote
  #workflowy-beta
  boostnote
  # editor
  sublime-text
  visual-studio-code
  ngrok
  xmind
  licecap # 录屏gif软件
  appcleaner # 卸载软件
  grandperspective # 磁盘空间分析软件
  pycharm-ce
  intellij-idea
  typora
  charles
  android-file-transfer
  nutstore
  docker
  minikube
  # password manager
  macpass
  1password
  postman
  gpg-suite
  wireshark
  neteasemusic
  ## work
  bearychat
  # slack
  zoomus
  virtualbox
  sourcetree
  # database client
  sequel-pro  #下载速度慢，需手动安装
  robo-3t
  wechat
  # rdm
  #####
  # 
  # 手动安装：
  # shadowsocksx # shadowsocks
  # shadowsocksx-ng
  # beyond-compare # 对比软件
  #
  # Apple store:
  # pocket
  # 
  #####
  # 付费软件：
  # reeder3
  # alfred
  # phpstorm
  # goland
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

brew tap ethereum/ethereum
brew tap jenkins-x/jx

brew link --force openssl
brew link --force libxml2

echo "Installing binaries..."
brew install ${binaries[@]}

brew linkapps solidity

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
