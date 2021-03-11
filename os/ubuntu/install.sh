# !/bin/sh
#
#

. ./os/ubuntu/softwares.sh

echo "Updating Packages."
apt-get -qq update
echo "Installing Software."
echo "Installing Core Packages."

# 必备软件
necessary=(
    vim
    git
    zsh
    pm-utils
    htop
    # apt-get install -qq -y ibus ibus-clutter ibus-gtk ibus-gtk3 ibus-qt4 ibus-pinyin
    ibus-pinyin
)

app=(
    gitg
    # keepasss
    # terminator
    # 手动安装：
    # vscode
    # nutstore
    # sublime-text-installer
    # codeblocks
    # indicator-muiltload
)

binaries=(
    # docker
    # nodejs
    # nvm
    # proxychains-ng
    # sogoupinyin
    #   wget -q -O sogoupinyin_i386.deb http://pinyin.sogou.com/linux/download.php?f=linux&bit=64
    # java
    #   tar -xzf jdk-8u65-linux-x64.tar.gz
    #   mv jdk1.8.0_101 /usr/local/java
    # chrome
    #   wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    #   dpkg -i google-chrome-stable_current_amd64.deb
    #   apt-get install -f
    ###
)

# 需要 add-apt-repository 的，需要注意是否有对应版本
repositories=(
)

dep_app=(
)

apt-get install -qq -y ${necessary[@]}
echo "Installing Repositories..."


for i in $repositories
  do
   add-apt-repository -y $i
done
apt-get -qq update
apt-get install -qq -y ${dep_app[@]}

# install_ohmyzsh
# install_typora

rm -rf /var/lib/apt/lists/*