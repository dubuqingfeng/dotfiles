# !/bin/sh

plugins=${HOME}/plugins

if [[ ! -d ${plugins} ]]; then
    mkdir ${plugins}
fi

cd ${plugins}

# install powerline fonts
if [[ ! -d ${plugins}/fonts ]]; then
	git clone https://github.com/powerline/fonts
	sh ./fonts/install.sh
fi

# install solarized adn dircolors
if [[ ! -d ${plugins}/solarized ]]; then
	git clone https://github.com/altercation/solarized.git
	open "${plugins}/solarized/iterm2-colors-solarized/Solarized Dark.itermcolors"
	open "${plugins}/solarized/osx-terminal.app-colors-solarized/xterm-256color/Solarized Dark xterm-256color.terminal"
fi

if [[ ! -d ${plugins}/dircolors-solarized ]]; then
	git clone https://github.com/seebi/dircolors-solarized.git
fi

if [[ ! -d ${plugins}/dracula ]]; then
	git clone https://github.com/dracula/zsh.git dracula
	ln -s ${HOME}/plugins/dracula/dracula.zsh-theme ~/.oh-my-zsh/themes/dracula.zsh-theme
fi

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

exit 0