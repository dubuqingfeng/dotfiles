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
  netcat
  gdb
  homebrew/versions/gcc48
  node
  nmap
  go
  imagemagick
  # 通过phpbrew进行composer配置
  # composer

  phpbrew
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

  php55-redis
  
  #编译bitcoin
  brew Installing
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

  homebrew/php/php71
  # docker 改为dockerformac
  # boot2docker
  # subversion
  # tomcat
  # mysql
  # nginx
  # mongodb

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
  robomongo # mongodb client
  pycharm-ce
  the-unarchiver
  #evernote
  sublime-text3
  filezilla
  vagrant
  # vagrant-manager
  xmind
  licecap # 录屏gif软件
  # dash
  appcleaner # 卸载软件
  grandperspective # 磁盘空间分析软件
  # intel-haxm
  intellij-idea
  charles
  android-file-transfer
  nutstore
  alfred
  macpass
  sequel-pro  #下载速度慢，需手动安装
  squirrel
  docker
  kitematic
  slack
  #####
  # 
  # macdown # markdown编辑器
  # 手动安装：
  # sourcetree # git
  # sequel-pro # mysql client
  # shadowsocksx # shadowsocks
  # beyond-compare # 对比软件
  # virtualbox
  # qq
  # airdroid
  # cs
  # leanote
  # jdk1.6
  #
  # chrome App:
  # Postman
  # google keep
  # chromebook recovery
  # docker client
  # mysqladmin
  #
  # Keepass:
  # Xquartz 
  # Apple store:
  # pocket
  # 
  # 付费软件：
  # reeder3
  # SnippetsLab
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
# brew update

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
brew tap homebrew/versions
brew install caskroom/cask/brew-cask
brew upgrade brew-cask

#安装phpbrew
brew link icu4c
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
