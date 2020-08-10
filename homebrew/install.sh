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

  graphviz
  dos2unix
  wget
  ctags
  grc
  ccat
  git-flow
  tree
  telnet
  pass
  gnupg
  gpg
  mackup
  mas
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
  grin
  # security
  sqlmap
  # Node
  node@8
  nvm
  httpie
  pstree
  privoxy
  textql
  libconfig
  glog
  librdkafka
  apache-arrow
  protobuf
  # kafka
  # 数据库
  mysql
  nmap
  zmap
  imagemagick
  composer
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
  apache-flink
  apache-spark
  hive
  zlib
  # homebrew/nginx was deprecated. This tap is now empty as all its formulae were migrated.
  # homebrew/nginx/openresty
  
  solidity
  grpc
  #编译bitcoin
  #automake 
  berkeley-db4 
  #libtool 
  #flutter
  boost
  rocksdb
  miniupnpc 
  #openssl 
  pkg-config 
  protobuf 
  qt5 
  #libevent
  librsvg
  tldr
  # /usr/local/Cellar/php/7.2.5/bin/pecl install swoole
  # /usr/local/Cellar/php/7.2.5/bin/pecl install xdebug
  hiredis
  consul-template
  # CI / CD
  # 需要 java8
  # jenkins
  # jenkins-x/jx/jx
  kubernetes-helm
  # mysql
  # nginx
  # mongodb
  # hub
  # legit
  # ssh-copy-id
  cocoapods
)

# Apps
apps=(
  # language
  java
  adoptopenjdk/openjdk/adoptopenjdk8
  # browsers
  google-chrome
  firefox
  # ide
  android-studio
  pycharm-ce
  intellij-idea 
  # term
  iterm2 # 加强版终端
  # the rar
  the-unarchiver
  # vlc
  calibre
  # note
  evernote
  # notion
  # workflowy-beta
  boostnote
  # editor
  sublime-text
  visual-studio-code
  ngrok
  xmind
  licecap # 录屏gif软件
  appcleaner # 卸载软件
  grandperspective # 磁盘空间分析软件

  typora
  charles
  android-file-transfer
  nutstore # 坚果云
  docker
  minikube
  # password manager
  macpass
  1password
  gpg-suite
  postman
  wireshark
  neteasemusic
  ## work
  bearychat
  # slack
  zoomus
  virtualbox
  fork
  # database client
  homebrew/cask-versions/sequel-pro-nightly
  # sequel-pro  # mysql8 或者 一些 奔溃原因
  another-redis-desktop-manager
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
  # helm
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
brew tap homebrew/cask-fonts
brew tap homebrew/cask-versions

brew tap ethereum/ethereum
brew tap jenkins-x/jx

brew link --force openssl
brew link --force libxml2

echo "Installing binaries..."
brew install ${binaries[@]}

# brew linkapps solidity

echo "Installing fonts..."
brew cask install ${fonts[@]}

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "Installing apps..."
brew cask install --appdir="/Applications" ${apps[@]}

# clean things up
brew cleanup

exit 0
