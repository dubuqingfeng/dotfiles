# !/bin/sh

install_ohmyzsh() {
    echo "Installing oh my zsh..."
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
}

# https://www.sublimetext.com/docs/3/linux_repositories.html
install_sublime() {
    echo "Installing sublime text..."
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    apt-get install apt-transport-https
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    apt-get update
    apt-get install sublime-text
}

# https://typora.io/#linux
install_typora() {
    # sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BA300B7755AFCFAE
    wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
    # add Typora's repository
    add-apt-repository 'deb https://typora.io/linux ./'
    apt-get update
    # install typora
    apt-get install typora
}

software=''
if [ $# -eq 0 ]
then
    software=""
else
    software=$1
fi

if [[ $software = "ohmyzsh" ]]
then
    install_ohmyzsh
elif [[ $software = "sublime" ]]
then
    install_sublime
elif [[ $software = "typora" ]]
then
    install_typora
fi