# My dotfiles about OS X


> The set of files used to describe session initialization procedures and store user customizations are commonly referred to as "dotfiles". These files can be used to customize screen appearance, shell behavior, program specifications and aspects of your Athena session. Most dotfiles are text files, although some exist in other formats. Dotfiles generally contain one command per line and are stored in your home directory. Dotfiles usually have names that begin with a period, hence the name dotfiles. You are given some dotfiles that are necessary for you to be able to login when you get your account.

![iMac-MacBook-flat](http://i.imgur.com/GBpjrHB.png)

这份 [dotfiles](https://github.com/dubuqingfeng/dotfiles-mac) 是基于zoumo的[dotfiles](https://github.com/zoumo/dotfiles)对自己的需求进行了修改。

更多的 dotfiles 请参考 [GitHub does dotfiles](https://dotfiles.github.io/)。

## Agenda

- [快速开始](#quick-start)
  - [清除并安装 OS X](#erase-and-reinstall-os-x)
  - [安装 Xcode](#install-xcode)
  - [安装 dotfiles](#install-dotfiles)
  - [恢复备份](#restore-backup)
- [How To Use](#how-to-use)
  - [dotfiles](#dotfiles)
  - [OS X](#os-x)
  - [Mackup](#mackup)
- [Issue](#issue)

# Quick Start

## Erase and reinstall OS X

如果打算从干净的 Mac 环境开始，请参考「[OS X：如何清除並安裝](http://support.apple.com/zh-tw/HT5943)」。

## Install Xcode

1. 更新APP store
2. 安装Xcode
3. 安装Xcode Command Line Tools
//输入gcc或者git，会提示
```
xcode-select:no developer tools were found at '/Applications/Xcode.app',requesting install. Choose an option in the dialog to download the command Line developer tools.
```

```bash
$ xcode-select --install
```

## Install dotfiles

使用 git clone 一份到 `$HOME` 目录底下的 `.dotfiles` 文件夹里面:

```bash
$ git clone https://github.com/dubuqingfeng/dotfiles-mac.git ~/.dotfiles
```

进入 `.dotfiles` 文件夹, 然后安装dotfiles:

```bash
$ cd ~/.dotfiles

$ ./script/bootstrap
```

`bootstrap.sh` 这个程序会自动完成以下的工作:

1. 检查并安装 [Homebrew](http://brew.sh/)。
2. 检查并安装 [Oh My Zsh](http://ohmyz.sh/)。
3. 检查并链接 dotfiles(`.zshrc`, `.vimrc`, `.gitconfig`,` .gitignore`, ...)。
4. 更新并安装 brew packages(binaries, fonts, apps)。
5. 设置 Mac OS X 的 defaults settings。
6. 安装python packages(powerline-status, pyenv, ...)
7. 对vim, ls, terminal进行美化, 主要是安装了solarized配色和powerline状态栏

完成之后, 手动安装一些其他软件(Sublime3, Alfred, 以及一些较大的软件java, mysql, mongodb, nginx, jmeter,docker)

## Restore backup

使用 [Mackup](https://github.com/lra/mackup) 进行备份恢复:

```bash
$ mackup restore
```

# How To Use

## dotfiles

执行 `~/.dotfiles/script/bootstrap` 的时候，脚本会将目录底下所有的 `*.symlink` 文件通过 `ln` 命令建立链接至 `$HOME` 目录底下:

| topic  | *.symlink          | .dotfiles     |
| ------ | ------------------ | ------------- |
| git    | gitconfig.symlink  | ~/.gitconfig  |
|     | gitignore.symlink  | ~/.gitignore  |
| mackup | mackup.cfg.symlink | ~/.mackup.cfg |
| vim    | vimrc.symlink      | ~/.vimrc      |
| zsh    | zshrc.symlink      | ~/.zshrc      |

### Topical

每一个环境的配置是以文件夹的形式独立区分, 例如, 如果想要增加"Python"的配置到dotfiles, 则简单的新增一个名字为 `python` 的文件夹
任何后缀名是 `.zsh` 的文件将在 shell 执行时自动被载入环境中。
任何后缀名是 `.symlink` 的文件将在你执行 `script/bootstrap`的时候自动链接到 `$HOME` 目录下

### Components

目录中比较特殊的文件

- **bin/**: 任何在 `bin/` 目录下的文件可以在shell执行的时候使用。
- **topic/*.zsh**: 任何 `.zsh` 结尾的文件都会在 shell 执行的时候被载入环境。
- **topic/path.zsh**: 任何 `path.zsh` 结尾的文件会在 shell 执行时优先载入。
- **topic/*.symlink**: 任何 `*.symlink` 結尾的文件都会在 `$HOME` 目录下建立链接。

不同于 [Holman's dotfiles](https://github.com/holman/dotfiles)，修改了一些部分:

- Shell 的部分改用 [Oh My Zsh](http://ohmyz.sh/)取代原作者自己配置的 zsh。
- 移除 **topic/aliases.zsh**、**topic/completion.zsh** 等文件，改用 Oh My Zsh 的 [plugins]。(https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins) 代替。
- 移除 **zsh/prompt.zsh**、**zsh/window.zsh** 等文件，改用 Oh My Zsh 的 [themes]。(https://github.com/robbyrussell/oh-my-zsh/wiki/Themes) 代替。
- dotfiles 只專注在 **topic/*.symlink**、**topic/path.zsh** 的配置。


## OS X

`bin/dot` 会在`script/bootstrap`最后执行, 负责安装OS X的程序和修改系统配置

执行 `$ dot` 之后，它会执行下面的脚本:

1. `$HOME/.dotfiles/homebrew/install.sh` - Homebrew packages
2. `$HOME/.dotfiles/osx/set-defaults.sh` - OS X defaults setting
3. `$HOME/.dotfiles/python/install.sh`   - Set up python env
4. `$HOME/.dotfiles/beautify/install.sh` - beautify vim, terminal, ls

### Homebrew packages

执行 `$ ./homebrew/install.sh` 的时候, 脚本会使用 [Homebrew](http://brew.sh/) 和 [Homebrew Cask](http://caskroom.io/) 來安裝 **binary**、**font** 還有 **app**，可以根据个人的需求增减packages的安装:

```bash
binaries=(
  git
  tree
  ...
)
```

字体都是以 **font-XXX** 的形式命名，可以用 `$ brew cask search /font-XXX/` 搜索是否存在。

```bash
fonts=(
  font-roboto
  ...
)
```

应用程序可以用 `$ brew cask search XXX` 或是 [Cask Search](http://caskroom.io/search) 网站搜索是否存在。

```bash
apps=(
  iterm2
  google-chrome
  ...
)
```

以下是我目前自动安裝的 packages：

#### Binaries

| name | info |
| --- | --- |
| dos2unix | 文档格式转换 |
| wget | wget工具 |
| python | OS X自带的python没有pip |
| ctags | 方便代码阅读 |
| [grc](http://kassiopeia.juls.savba.sk/~garabik/software/grc/README.txt)| log上色 |
| [git-flow](https://github.com/nvie/gitflow) | Git branch manage model |
| [tree](http://mama.indstate.edu/users/ice/tree/) | 树状目录结构显示 |
| [mackup](https://github.com/lra/mackup) | 同步应用程序配置 |
| [z](https://github.com/rupa/z.git) | autojump |
| tmux | tmux |
| htop | 加强版top |
| [trash](http://hasseg.org/blog/post/406/trash-files-from-the-os-x-command-line/) | 模拟Finder的移到废纸篓功能, 在alias中对rm进行替换, 进行安全删除 |


#### Fonts

| name | info |
| --- | --- |
| [font-source-code-pro](http://www.google.com/fonts/specimen/Source+Code+Pro) | Source Code Pro |

#### Apps

| name | info |
| --- | --- |
| [google-chrome](www.google.com/chrome) | Google 浏览器 |
| [macdown](http://macdown.uranusjr.com/) | Open source Markdown editor for OS X |
| [iterm2](http://iterm2.com/) | 加强版终端 |
| [scroll-reverser](http://pilotmoon.com/scrollreverser/) | 支持鼠标和触控板滚轮分别设置 |
| [slate](https://github.com/jigish/slate) | Mac窗口调节程序,类似于Divvy and SizeUp |
| [beyond-compare](http://www.scootersoftware.com/) | Beyond Compare 是一个优秀的文件/目录对比工具 |
| the-unarchiver | 优秀免费的解压软件 |
| lingon-x | 启动项管理 |
| appzapper | app卸载器 |
| xtrafinder | finder加强 |


下面这些不太适合自动安装, 有些比较大, 有些可以不装

#### Binaries

| name | info |
| --- | --- |
| mysql | 数据库 |
| mongodb | 数据库 |
| nginx | 反向代理 |

#### Apps

| name | info |
| --- | --- |
| java | java |
| robomango | mongodb客户端 |
| Shadowsocks | Bypass firewall |

### OS X defaults setting

执行 `$ ./osx/set-defaults.sh` 之后，程序会更改Mac OS X的一些系统设置, 根据个人喜欢和需求修改这个文件，或是参考 [Mathias’s dotfiles](https://github.com/mathiasbynens/dotfiles/blob/master/.osx) 整理好的配置。

以下是目前设定的配置：


| setting | script |
| ------ | --- |
| 关闭电源进入深度睡眠 | `sudo pmset -a autopoweroff 0` |
| 加快窗口 resize 的速度(Cocoa applications)  | `defaults write NSGlobalDomain NSWindowResizeTime -float 0.001` |
| 预设展开存储窗口(1) | `defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true` |
| 预设展开存储窗口(2) | `defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true` |
| 关闭“你确定要开启这个应用程序?"的询问窗口 | `defaults write com.apple.LaunchServices LSQuarantine -bool false` |
| 加速进入睡眠模式 | `sudo pmset -a hibernatemode 0` |
| 开启触控板轻触点击功能(1) | `defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true` |
| 开启触控板轻触点击功能(2) | `defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1` |
| 开启触控板轻触点击功能(3) | `defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1` |
| 开启触控板/滑鼠右键菜单功能(1) | `defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true` |
| 开启触控板/滑鼠右键菜单功能(2) | `defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode "TwoButton"` |
| 开启触控板三指拖拽功能(1) | `defaults -currentHost write NSGlobalDomain com.apple.trackpad.threeFingerDragGesture -bool true` |
| 开启触控板三指拖拽功能(2) | `defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true` |
| 开启触控板四指下滑出现 app expose 功能(1) | `defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0` |
| 开启触控板四指下滑出现 app expose 功能(2) | `defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 0` |
| 开启触控板四指下滑出现 app expose 功能(3) | `defaults write com.apple.dock showAppExposeGestureEnabled -int 1` |
| 加快触控板/滑鼠的速度(1) | `defaults write NSGlobalDomain com.apple.trackpad.scaling -int 3` |
| 加快触控板/滑鼠的速度(2) | `defaults write NSGlobalDomain com.apple.mouse.scaling -int 3`  |
| 开启全部窗口組件支持键盘控制 | `defaults write NSGlobalDomain AppleKeyboardUIMode -int 3` |
| 关闭键盘按住的输入限制 | `defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false` |
| 加快键盘输入 | `defaults write NSGlobalDomain KeyRepeat -int 0` |
| 移除窗口截图的影子移除視窗截圖的影子 | `defaults write com.apple.screencapture disable-shadow -bool true` |
| 显示隐藏文件 | `defaults write ~/Library/Preferences/com.apple.finder AppleShowAllFiles -bool true`  |
| 预设Finder起始位置为下载(1) | `defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true` |
| 预设Finder起始位置为下载(2) | `defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true` |
| 显示所有拓展名 | `defaults write NSGlobalDomain AppleShowAllExtensions -bool true` |
| 显示 Finder 状态栏 | `defaults write com.apple.finder ShowStatusBar -bool true` |
| 显示 Finder 路径栏 | `defaults write com.apple.finder ShowPathbar -bool true` |
| 允许框选 Finder Quick Look 的文字 | `defaults write com.apple.finder QLEnableTextSelection -bool true` |
| 预设搜索的结果默认为当前的目录下 | `defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"` |
| 关闭更改拓展名的警告提示 | `defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false` |
| 开启资料夹的 spring loading 功能 | `defaults write NSGlobalDomain com.apple.springing.enabled -bool true` |
| 开启 Dock 的 spring loading 功能 | `defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true` |
| 移除 spring loading 的延迟 | `defaults write NSGlobalDomain com.apple.springing.delay -float 0` |
| 避免在 network volumes 底下建立 .DS_Store 档案 | `defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true` |
| 使用 column view 作为 Finder 预设显示选项 | `defaults write com.apple.finder FXPreferredViewStyle -string "clmv"` |
| 将窗口最小化到应用程序图标 | `defaults write com.apple.dock minimize-to-application -bool true` |
| 在 Dock 中为打开的应用程序显示指示灯 | `defaults write com.apple.dock show-process-indicators -bool true` |
| 关闭 Dashboard | `defaults write com.apple.dashboard mcx-disabled -bool true` |
| 将 Dashboard 从多重桌面之中移除 | `defaults write com.apple.dock dashboard-in-overlay -bool true` | 
| 自动显示和隐藏dock | `defaults write com.apple.dock autohide -bool true` |
| 将隐藏的应用程序 Dock 图标用半透明显示 | `defaults write com.apple.dock showhidden -bool true` |

//	Finder默认位置设置为个人

## Beautify

美化至少要对三个工具进行配色Terminal, vim, ls
使用solarized来进行终端美化, 它提供了一套比较完整的解决方案, 但是作者没有给ls配色, 所以使用另外一个作者 
[seebi](https://github.com/seebi/) 的 [dircolors-solarized](https://github.com/seebi/dircolors-solarized.git)
另外还在terminal中加入powerline状态栏来增强效果

下面展示的是完整的美化过程, 在dotfiles中除了更改字体需要手动修改, 大部分的工作都自动完成了

```bash
$ git clone https://github.com/altercation/solarized.git ~/plugins
$ git clone https://github.com/seebi/dircolors-solarized.git ~/plugins
```

### Terminal/Iterm2

在 `~/plugins/solarized/iterm2-colors-solarized/` 双击 `Solarized Dark.itermcolors` 导入iterm2的配色
 
在 `~/plugins/solarized/osx-terminal.app-colors-solarized/xterm-256color/` 双击 `Solarized Dark ansi.terminal` 导入Terminal.app的配色

### vim

```bash
$ mkdir -p ~/.vim/colors
$ cd ~/plugins/solarized/vim-colors-solarized/colors/
$ cp solarized.vim ~/.vim/colors
```

修改 `.vimrc` 

```bash
$ vi ~/.vimrc
syntax on
set background=dark
colorscheme solarized
```

### ls

Max OS X是基于FreeBSD的, 所以ls是BSD那一套, 不是GNU的ls, 所以即使Terminal/iTerm2配置了颜色, 但是ls也不会受到影响, 所以通过安装GNU的coreutils, 来解决

```bash
eval `dircolors ~/plugins/dircolors-solarized/dircolors.ansi-dark`
```


### powerline

powerline修改了terminal/vim下面的statusline

先安装__字体__不然会有乱码

```bash
$ git clone https://github.com/powerline/fonts
$ cd ~/plugins/fonts && ./install.sh
```

用`pip`安装, 然后获取到安装目录, 然后打开 vim ~/.zshrc, 在最后添加(注意前面的点)

```bash
$ pip install powerline-status
$ vim ~/.zshrc

if test $(which pip)
then
    export POWERLINE_ROOT="$(python -c "from distutils.sysconfig import get_python_lib; print get_python_lib()")/powerline"
    . ${POWERLINE_ROOT}/bindings/zsh/powerline.zsh

fi
```	
之后使用`source ~/.zshrc`使之生效, 修改终端(iTerm2)的字体为`14pt Meslo LG S DZ Regular for Powerline`

如下图

![image](http://7xjgzy.com1.z0.glb.clouddn.com/powerline_1.png)

然后修改配置powerline for vim

`vim ~/.vimrc` 添加下面的配置, 路径和字体改成自己的

```bash
set rtp+=${POWERLINE_ROOT}/bindings/vim
set guifont=Meslo\ LG\ S\ DZ\ Regular\ for\ Powerline:h14
set laststatus=2
set encoding=utf-8
set t_Co=256
set number
set fillchars+=stl:\ ,stlnc:\
set term=xterm-256color
set termencoding=utf-8
set background=dark
syntax on
colorscheme solarized
set tabstop=4
set shiftwidth=4
set expandtab
filetype plugin on
filetype indent on
```
    
效果图如下, 会有一个状态栏出来

![image](http://7xjgzy.com1.z0.glb.clouddn.com/powerline_2.png)

## Mackup

当初始环境都安装好了以后, 就是需要备份了。除了 `.zsrc`、`.vimrc` 这类 dotfile 比较适合放置Github上面之外，其他像是 Sublime 的 plugin、iTerm2 的 setting、Oh My Zsh 的 plugin、等等很多一般程序的配置需要备份, 这些不适合放在Github上面。所以这里介紹 [Mackup](https://github.com/lra/mackup) 

**它将你想要备份的文件转移到 Dropbox ,Google Drive, 百度云这样的云盘在本地的同步目录如 `~/dropbox/mackup`, 然后使用`ln -s`进行链接 `link -> ~/dropbox/mackup`**

install

```bash
$ brew install mackup
```

配置方式也很容易，建立一份 `~/.mackup.cfg` 來修改:

```bash
[storage]
engine = dropbox # 同步的云盘, 目前只有dropbox和google_drive可以选择
directory = Mackup # 同步的文件夹，这里会将所有的同步备份至 ~/Dropbox/Mackup 底下

# 指定要同步的应用程序
[applications_to_sync]
iterm2
oh-my-zsh
sublime-text-3
ssh

[applications_to_ignore]
# 指定不想同步的应用程序
```

还可以在 `~/.mackup`文件夹中添加自定义程序同步配置(注意, 如果自定义的配置与默认支持的程序同名, 会覆盖默认配置)

```bash
$ vim ~/.mackup/sublime-text-3.cfg
[application]
name = Sublime Text 3

[configuration_files]
# Based on https://packagecontrol.io/docs/syncing
Library/Application Support/Sublime Text 3/Packages
Library/Application Support/Sublime Text 3/Installed Packages
.config/sublime-text-3/Packages/User
```

进行备份, 以后的任意修改都会被同步到云端

```bash
$ mackup backup
```

就可以将文件备份到 Dropbox 或 Google Drive。需要恢复的适合则执行:

```bash
$ mackup restore
```

以下是目前备份的应用程序：


| app | backup-conf |
| --- | --- |
| git | ~/.gitconfig和.config/git/ignore |
| mackup | ~/.mackup.cfg和~/.mackup |
| iterm2 | 默认配置 |
| oh-my-zsh | ~/.oh-my-zsh |
| scroll-reverser | 默认配置 |
| slate | ~/.slate |
| sublime-text-3 | plugins和config |
| pycharm40 | config |
| vim | ~/.vimrc 和~/.vim |


更多详细的配置说明和支持软件请查看 [mackup 的文件](https://github.com/lra/mackup/tree/master/doc)。

## alias

由于个人习惯需要对一些命令进行alias, 如下

```bash
alias dos2mac="dos2unix -c mac"
alias gbk2utf8="iconv -f GBK -t UTF-8"
alias utf82gbk="iconv -f UTF-8 -t GBK"
alias tailf="tail -f"
alias ve="pyenv local"
alias rm="trash" # 这个需要brew install trash
```

## Issue

有一些程序使用的破解版本, 需要手动安装
以及有一些brew cask安装不上的app

| name | 说明 |
| --- | --- |
| Sublime Text 3 | Editor |
| Alfred | workflow神器 |
| Airmail2 | 漂亮的邮件客户端 |
| MindNode Pro | 简单漂亮的思维导图 |
| clipmenu | 粘贴板增强 |
| sourcetree | git客户端 |

还有一些压根装不上的

| name | 说明 |
| --- | --- |
| [qlcolorcode](https://code.google.com/p/qlcolorcode/) | 让 Quick Look 支持 syntax highlighting |
| [qlmarkdown](https://github.com/toland/qlmarkdown) | 让 Quick Look 支持 Markdown |
| [qlstephen](http://whomwah.github.io/qlstephen/) | 让 Quick Look 支持无后拓展名的纯文本 |
| [font-roboto](http://www.google.com/fonts/specimen/Roboto) | Roboto字体 |

## 软件更新

## Reference

- [Hacker's Guide to Setting up Your Mac](http://lapwinglabs.com/blog/hacker-guide-to-setting-up-your-mac)
- [First steps with Mac OS X as a Developer](http://carlosbecker.com/posts/first-steps-with-mac-os-x-as-a-developer/)
- [Mac 开发配置手册](https://www.gitbook.com/book/aaaaaashu/mac-dev-setup/details)
- [如何優雅地在 Mac 上使用 dotfiles?](http://segmentfault.com/a/1190000002713879)
- [osx-for-hackers.sh](https://gist.github.com/brandonb927/3195465)
- [Mackup](https://github.com/lra/mackup/tree/master/doc)
- [mac-dev-setup](https://github.com/zoumo/mac-dev-setup)