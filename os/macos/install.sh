# !/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

mode=''
if [ $# -eq 0 ]
then
  mode="normal"
else
  mode=$1
fi

# Binaries
light_binaries=(
  tmux
  tig
  bat
  fzf
  htop
  svn
  rmtrash
  wget
  zellij
  # nvm
  # go
  # python
  # python@3.14
  # uv
)

# Apps
light_apps=(
  # flclash
  #### browsers
  google-chrome
  iterm2
  #### editor
  sublime-text
  visual-studio-code
  grandperspective
  #### password manager
  macpass
  appcleaner
  nutstore
  fork
  #### ai
  claude-code
  codex
  cursor-cli
  #### cc switch
  # brew tap farion1231/ccswitch
  # brew install --cask cc-switch
  tailscale-app
  obsidian
  zed
)

# Binaries
binaries=(
  #### language
  python
  go
  dep
  homebrew/core/php
  node
  svn
  nvm
  java
  adoptopenjdk/openjdk/adoptopenjdk8 # brew install --build-from-source openjdk@8
  #### database
  mysql
  # mongodb
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
  libusb
  mas
  z
  tmux
  htop
  rmtrash
  proxychains-ng
  pyenv
  gettext
  netcat
  bat
  fzf
  exa
  tig
  # lrzsz
  zssh
  lrzsz
  # gdb # m1 芯片暂不支持
  gcc
  ninja
  syncthing
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
  cppcheck
  cmake
  yarn
  # rust
  cbindgen
  
  ngrok
  maven
  apache-flink
  # apache-spark
  # hive
  zlib
  solidity
  grpc
  # automake 
  berkeley-db@4 
  # libtool 
  # flutter
  boost
  rocksdb
  miniupnpc 
  # openssl 
  pkg-config 
  protobuf 
  qt5 
  # libevent
  librsvg
  tldr
  buf
  hiredis
  consul-template
  # CI / CD
  earthly
  # nginx
  # hub
  # legit
  # ssh-copy-id
  cocoapods
)

# Apps
apps=(
  #### browsers
  google-chrome
  #### ide
  pycharm-ce
  iterm2 # 加强版终端
  #### devops
  docker
  #### editor
  sublime-text
  visual-studio-code
  typora
  #### password manager
  macpass
  #### database client
  # sequel-pro  # mysql8 或者 一些 奔溃原因
  homebrew/cask-versions/sequel-pro-nightly
  # another-redis-desktop-manager
  # robo-3t
  ##### other
  the-unarchiver
  appcleaner # 卸载软件
  grandperspective # 磁盘空间分析软件
  charles
  android-file-transfer
  nutstore
  # calibre
  gpg-suite
  postman
  wireshark
  neteasemusic
  fork
  #####
  # Apple store
  # pocket
  #####
  # 付费软件：
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
# brew tap ethereum/ethereum
brew tap bufbuild/buf

if [[ $mode = "normal" ]]
then
  echo "Installing binaries..."
  brew install ${binaries[@]}

  # Install apps to /Applications
  # Default is: /Users/$user/Applications
  echo "Installing apps..."
  brew install --cask --appdir="/Applications" ${apps[@]}
elif [[ $mode = "light" ]]
then
  echo "Installing Light binaries..."
  brew install ${light_binaries[@]}

  # Install apps to /Applications
  # Default is: /Users/$user/Applications
  echo "Installing apps..."
  brew install --cask --appdir="/Applications" ${light_apps[@]}
fi

echo "Installing fonts..."
brew install ${fonts[@]}

# clean things up
brew cleanup

exit 0
