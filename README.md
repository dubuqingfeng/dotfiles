# My dotfiles about MacOS， Ubuntu

> The set of files used to describe session initialization procedures and store user customizations are commonly referred to as "dotfiles". These files can be used to customize screen appearance, shell behavior, program specifications and aspects of your Athena session. Most dotfiles are text files, although some exist in other formats. Dotfiles generally contain one command per line and are stored in your home directory. Dotfiles usually have names that begin with a period, hence the name dotfiles. You are given some dotfiles that are necessary for you to be able to login when you get your account.

![iMac-MacBook-flat](http://i.imgur.com/GBpjrHB.png)

这份 [dotfiles](https://github.com/dubuqingfeng/dotfiles) 是基于 zoumo 的[dotfiles](https://github.com/zoumo/dotfiles)对自己的需求进行了修改。

更多的 dotfiles 请参考 [GitHub does dotfiles](https://dotfiles.github.io/)。

# Agenda

- [快速开始](#quick-start)
  - [清除并安装](#erase-and-reinstall)
  - [安装 Xcode](#install-xcode)
  - [安装 dotfiles](#install-dotfiles)
  - [恢复备份](#restore-backup)
- [How To Use](#how-to-use)
  - [dotfiles](#dotfiles)
    - [Topical](#topical)
    - [Components](#components)
  - [MacOS](#MacOS)
    - [Homebrew packages](#homebrewpackages)
      - [Binaries](#binaries)
      - [Fonts](#fonts)
      - [Apps](#apps)
    - [MacOS defaults setting](#MacOSdefaultssetting)
  - [Mackup](#mackup)
  - [alias](#alias)
- [Issue](#issue)
- [软件更新](#softupdate)
- [Reference](#reference)

# Quick Start

## Erase and reinstall 

### Erase and reinstall MacOS

如果打算从干净的 Mac 环境开始，请参考「[OS X：如何清除並安裝](http://support.apple.com/zh-tw/HT5943)」。

1. 登出 iCloud
2. 登出 iMessage
3. 重置 NVRAM 抹掉硬盘驱动器
4. 打开实用工具，终端，输入以下指令：

```bash
diskutil secureErase freespace VALUE /Volumes/DRIVE (DRIVE example： Macintosh\ HD，Macintosh\ HD 数据)
```

Value 在 0-4 之间，0 表示全盘覆盖写入单次 0，1 表示全盘覆盖写入随机数字，2 表示全盘覆盖擦除 7 次，3 表示全盘覆盖擦除 35 次，4 表示全盘覆盖擦除 3 次。需要注意的是，SSD 擦除太多次会影响到它的使用寿命。

5. 重新安装 macOS

## Install Xcode

1. 更新APP store
2. 安装Xcode
3. 安装Xcode Command Line Tools
// 输入gcc或者git，会提示
```
xcode-select:no developer tools were found at '/Applications/Xcode.app',requesting install. 
Choose an option in the dialog to download the command Line developer tools.
```

然后执行 (m1 芯片或许不需要)：

```bash
$ xcode-select --install
```

## Install dotfiles

使用 git clone 一份到 `$HOME` 目录底下的 `.dotfiles` 文件夹里面:

```bash
$ git clone https://github.com/dubuqingfeng/dotfiles.git ~/.dotfiles
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
5. 设置 Mac OS 的 defaults settings。
6. 安装python packages(powerline-status, pyenv, ...)
7. 对 vim, ls, terminal 进行美化, 主要是安装了 solarized 配色和 powerline 状态栏

问题1:

这里如果出现 curl: (7) Failed to connect to raw.githubusercontent.com port 443: Connection refused ,建议配置代理

问题2:

```
/Users/dubuqingfeng/.zshenv:.:2: no such file or directory: /Users/dubuqingfeng/.cargo/env
```

没有安装 rust，建议通过以下命令安装：

```
curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path -y
```

完成之后, 手动安装一些其他软件(sequel-pro, sourcetree, 以及一些较大的软件java，docker)

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


## MacOS

`bin/dot` 会在`script/bootstrap`最后执行, 负责安装 MacOS 的程序和修改系统配置

执行 `$ dot` 之后，它会执行下面的脚本:

1. `$HOME/.dotfiles/os/macos/install.sh` - Homebrew packages
2. `$HOME/.dotfiles/os/macos/set-defaults.sh` - MacOS defaults setting
3. `$HOME/.dotfiles/pkg/python/install.sh`   - Set up python env
4. `$HOME/.dotfiles/os/beautify/install.sh` - beautify vim, terminal, ls

### Homebrew packages

执行 `$ $HOME/.dotfiles/os/macos/install.sh` 的时候, 脚本会使用 [Homebrew](http://brew.sh/) 來安裝 **binary**、**font** 還有 **app**，可以根据个人的需求增减packages的安装:

```bash
binaries=(
  git
  tree
  ...
)
```

字体都是以 **font-XXX** 的形式命名，可以用 `$ brew search /font-XXX/` 搜索是否存在。

```bash
fonts=(
  font-roboto
  ...
)
```

应用程序可以用 `$ brew search XXX` 或是 [Homebrew](http://brew.sh/) 网站搜索是否存在。

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
| python | MacOS 自带的python没有pip |
| ctags | 方便代码阅读 |
| [grc](http://kassiopeia.juls.savba.sk/~garabik/software/grc/README.txt)| log上色 |
| [git-flow](https://github.com/nvie/gitflow) | Git branch manage model |
| [tree](http://mama.indstate.edu/users/ice/tree/) | 树状目录结构显示 |
| [mackup](https://github.com/lra/mackup) | 同步应用程序配置 |
| [z](https://github.com/rupa/z.git) | autojump |
| tmux | tmux |
| htop | 加强版top |
| [trash](http://hasseg.org/blog/post/406/trash-files-from-the-os-x-command-line/) | 模拟Finder的移到废纸篓功能, 在alias中对rm进行替换, 进行安全删除 |
| proxychains-ng | 代理工具 |
| pyenv | pyenv |
| gettext | gettext |
| netcat | netcat |
| gdb | gdb |
| homebrew/versions/gcc48 | homebrew/versions/gcc48 |

#### Fonts

| name | info |
| --- | --- |
| [font-source-code-pro](http://www.google.com/fonts/specimen/Source+Code+Pro) | Source Code Pro |

#### Apps

| name | info |
| --- | --- |
| java | java |
| [google-chrome](www.google.com/chrome) | Google 浏览器 |
| [iterm2](https://www.iterm2.com/) | iterm2加强版终端 |
| Firefox | 火狐浏览器 |
| [scroll-reverser](http://pilotmoon.com/scrollreverser/) | 支持鼠标和触控板滚轮分别设置 |
| the-unarchiver | 优秀免费的解压软件 |
| android-studio | Android开发 |
| robomongo | mongodb client |
| pycharm-ce | 社区版pycharm |
| evernote | 印象笔记 |
| sublime-text3 | 一种编辑器 |
| xmind | 一种思维导图软件 |
| licecap | 一种录屏软件 |
| appcleaner | app卸载软件 |
| grandperspective | grandperspective # 磁盘空间分析软件 |
| mactex | mac LaTeX（比较大一点） |
| intel-haxm | intel-haxm |
| wireshark --with-qt | wireshark --with-qt |
| intellij-idea | intellij-idea |
| charles | 抓包软件 |
| android-file-transfer | Android手机传输工具 |
| nutstore | 坚果云 |

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
| dash | dash |
| [sourcetree](https://www.sourcetreeapp.com/) | git client |
| beyond-compare | beyond-compare 一个优秀的文件/目录对比工具 |
| virtualbox | virtualbox 虚拟机 |
| jdk1.6 | android 编译 |


### MacOS defaults setting

执行 `$ ./os/macos/set-defaults.sh` 之后，程序会更改 Mac OS 的一些系统设置, 根据个人喜欢和需求修改这个文件，或是参考 [Mathias’s dotfiles](https://github.com/mathiasbynens/dotfiles/blob/master/.osx) 整理好的配置。

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
| 将隐藏的应用程序 Dock 图标用半透明显示 | `defaults write com.apple.dock showhidden -bool true` 

## Mackup

当初始环境都安装好了以后, 就是需要备份了。除了 `.zsrc`、`.vimrc` 这类 dotfile 比较适合放置 Github 上面之外，其他像是 Sublime 的 plugin、iTerm2 的 setting、Oh My Zsh 的 plugin、等等很多一般程序的配置需要备份, 这些不适合放在Github上面。所以这里介紹 [Mackup](https://github.com/lra/mackup) 

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

# Issue

需要手动安装以及有一些brew cask安装不上的app

| name | 说明 |
| --- | --- |
| beyond-compare | 兼容问题 |
| postman | chrome-extendsion |
| sequel-pro | mysql client |
| sourcetree | git客户端 |

以及一些Chrome 扩展或者应用：

| name | info |
| --- | --- |
| [SwitchyOmega](https://chrome.google.com/webstore/detail/proxy-switchyomega/padekgcemlokbadohgkifijomclgjgif?hl=zh-CN) |  |
| [FireShot](https://chrome.google.com/webstore/detail/capture-webpage-screensho/mcbpblocgmgfnpjjppndjkmgjaogfceg?hl=zh-CN) |  |
| [cVim](https://chrome.google.com/webstore/detail/cvim/dbepggeogbaibhgnhhndojpepiihcmeb) |  |
| [Octotree](https://chrome.google.com/webstore/detail/octotree/ihlenndgcmojhcghmfjfneahoeklbjjh) |  |
| [Save to Pocket](https://chrome.google.com/webstore/detail/save-to-pocket/niloccemoadcdkdjlinkgdfekeahmflj) |  |
| [Tab Resize - split screen layouts](https://chrome.google.com/webstore/detail/tab-resize-split-screen-l/bkpenclhmiealbebdopglffmfdiilejc) |  |
| [Markdown Here](https://chrome.google.com/webstore/detail/markdown-here/elifhakcjgalahccnjkneoccemfahfoa) | |
| [One-Click Extensions Manager](https://chrome.google.com/webstore/detail/%E4%B8%80%E9%94%AE%E7%AE%A1%E7%90%86%E6%89%80%E6%9C%89%E6%89%A9%E5%B1%95/niemebbfnfbjfojajlmnbiikmcpjkkja) |  |
| Apps | --- |
| [Postman](https://chrome.google.com/webstore/detail/postman/fhbjgbiflinjbdggehcddcbncdddomop) | |
| [Simple Docker UI](https://chrome.google.com/webstore/detail/simple-docker-ui/jfaelnolkgonnjdlkfokjadedkacbnib?hl=zh-CN) | |
| [MySQL Admin](https://chrome.google.com/webstore/detail/chrome-mysql-admin/ndgnpnpakfcdjmpgmcaknimfgcldechn) | |
| [WorkFlowy](https://chrome.google.com/webstore/detail/workflowy/koegeopamaoljbmhnfjbclbocehhgmkm/related?hl=zh-CN) | |

还有一些压根装不上的

| name | 说明 |
| --- | --- |
| [qlcolorcode](https://code.google.com/p/qlcolorcode/) | 让 Quick Look 支持 syntax highlighting |
| [qlmarkdown](https://github.com/toland/qlmarkdown) | 让 Quick Look 支持 Markdown |
| [qlstephen](http://whomwah.github.io/qlstephen/) | 让 Quick Look 支持无后拓展名的纯文本 |
| [font-roboto](http://www.google.com/fonts/specimen/Roboto) | Roboto字体 |

# 软件更新

```
brew upgrade xxx
brew restall xxx
```

# Reference

- [First steps with Mac OS X as a Developer](http://carlosbecker.com/posts/first-steps-with-mac-os-x-as-a-developer/)
- [如何優雅地在 Mac 上使用 dotfiles?](http://segmentfault.com/a/1190000002713879)
- [osx-for-hackers.sh](https://gist.github.com/brandonb927/3195465)
- [Mackup](https://github.com/lra/mackup/tree/master/doc)
- [mac-dev-setup](https://github.com/zoumo/mac-dev-setup)
