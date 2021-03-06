# !/bin/sh
#
#
#

echo "Updating Packages."
apt-get -qq update
echo "Installing Software."
echo "Installing Core Packages."

# 必备软件
necessary=(
    vim
    git
    zsh
    python-pip
    pm-utils
    indicator-muiltload
    htop
)

app=(
    gitg
    # keepasss
    # terminator
    # 手动安装：
    # vscode
    # nutstore
)

binaries=(
    # docker
    # nodejs
    # proxychains-ng
    # vi /usr/local/etc/proxychains.conf
    # sogoupinyin
    # wget -q -O sogoupinyin_i386.deb http://pinyin.sogou.com/linux/download.php?f=linux&bit=64
    # java
    # tar -xzf jdk-8u65-linux-x64.tar.gz
    # mv jdk1.8.0_101 /usr/local/java
    #chrome
    # wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    # dpkg -i google-chrome-stable_current_amd64.deb
    # apt-get install -f
    ###
)

repositories=(
    ppa:hzwhuang/ss-qt5
    ppa:webupd8team/sublime-text-3
    ppa:docky-core/stable
    ppa:damien-moore/codeblocks-stable
    ppa:freyja-dev/unity-tweak-tool-daily
)

dep_app=(
    shadowsocks-qt5
    sublime-text-installer
    codeblocks
    # docky
    # unity-tweak-tool
)

apt-get install -qq -y ${necessary[@]}

echo "Installing oh my zsh..."
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

echo "Installing Repositories..."

add-apt-repository -y ${repositories[@]}
apt-get install -qq -y ${dep_app[@]}

install_typora() {
    # sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BA300B7755AFCFAE
    wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
    # add Typora's repository
    add-apt-repository 'deb https://typora.io/linux ./'
    apt-get update
    # install typora
    apt-get install typora
}

# apt-get install -qq -y ibus ibus-clutter ibus-gtk ibus-gtk3 ibus-qt4 ibus-pinyin

rm -rf /var/lib/apt/lists/*