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
  # mysql
  # nginx
  # node
  # mongodb
  # boot2docker
  # docker
  # grc
  # hub
  # legit
  # nvm
  # ssh-copy-id
  # trash

)

# Apps
apps=(
  # java
  google-chrome
  macdown  # markdown编辑器
  iterm2 # 加强版终端
  scroll-reverser  # 可以分别鼠标和触控板滚动方向
  slate  # 开源免费的桌面窗口控制调整工具
  beyond-compare  # 优秀的文件比较软件
  the-unarchiver  # 免费的解压软件
  # clipmenu  # 粘贴版扩展 0.4.3
  sourcetree  # git 管理
  lingon-x # 启动项管理
  appzapper  # app卸载器
  xtrafinder  # 加强finder
  # mou
  # alfred
  # dash
  evernote
  # flux
  # keka
  # kitematic
  # obs
  # recordit
  # sublime-text3
  # virtualbox
  # vlc
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
