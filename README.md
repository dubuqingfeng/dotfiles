# dotfiles

> Dotfiles for macOS and Ubuntu - configuration files that personalize your development environment

![iMac-MacBook-flat](http://i.imgur.com/GBpjrHB.png)

这份 [dotfiles](https://github.com/dubuqingfeng/dotfiles) 基于 [zoumo/dotfiles](https://github.com/zoumo/dotfiles) 并根据个人需求进行了定制和扩展。

更多 dotfiles 参考: [GitHub does dotfiles](https://dotfiles.github.io/)

## 目录

- [快速开始](#快速开始)
  - [系统准备](#系统准备)
  - [安装 Xcode](#安装-xcode)
  - [安装 dotfiles](#安装-dotfiles)
  - [恢复备份](#恢复备份)
  - [多设备管理](#多设备管理)
  - [常见问题](#常见问题)
- [使用指南](#使用指南)
  - [dotfiles 说明](#dotfiles-说明)
  - [macOS 配置](#macos-配置)
  - [Mackup 备份](#mackup-备份)
  - [自定义别名](#自定义别名)
- [软件列表](#软件列表)
  - [命令行工具](#命令行工具)
  - [字体](#字体)
  - [应用程序](#应用程序)
- [已知问题](#已知问题)
- [更新维护](#更新维护)
- [参考资料](#参考资料)

## 快速开始

### 系统准备

如需从全新的 Mac 环境开始，参考 [OS X: 如何清除并安装](http://support.apple.com/zh-tw/HT5943)：

1. 登出 iCloud 和 iMessage
2. 进入恢复模式：
   - **Apple Silicon (M1/M2/M3等)**: 关机后长按电源键，直到看到"正在载入启动选项"
   - **Intel Mac**: 重启时按住 Command + R
3. 使用磁盘工具抹掉硬盘
4. 重新安装 macOS

**关于安全擦除：**
- **Apple Silicon Mac**: 使用 APFS 加密卷宗，直接抹掉即可安全删除数据，无需额外擦除
- **Intel Mac (HDD)**: 可选择安全擦除空闲空间

```bash
# Intel Mac HDD 安全擦除命令（仅在必要时使用）
diskutil secureErase freespace VALUE /Volumes/DRIVE

# VALUE 说明：
# 0: 单次覆写 0
# 1: 单次随机数覆写
# 2: 7 次覆写
# 3: 35 次覆写
# 4: 3 次覆写
```

注意：SSD（固态硬盘）不建议频繁擦除，会缩短使用寿命。现代 Mac 基本都使用 SSD，直接抹掉即可。

### 安装 Xcode

1. 更新系统至最新版本
2. 从 App Store 安装 Xcode
3. 安装 Xcode Command Line Tools

```bash
# 方式 1: 命令行安装（推荐）
xcode-select --install

# 方式 2: 输入 gcc 或 git 会自动提示安装
```

### 安装 dotfiles

克隆仓库到 `~/.dotfiles` 目录：

```bash
git clone https://github.com/dubuqingfeng/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./script/bootstrap
```

`bootstrap` 脚本会自动完成以下工作：

1. 检查并安装 [Homebrew](http://brew.sh/)
2. 检查并安装 [Oh My Zsh](https://ohmyz.sh/)
3. 链接 dotfiles (`.zshrc`, `.vimrc`, `.gitconfig`, `.gitignore` 等)
4. 安装 Homebrew packages (binaries, fonts, apps)
5. 配置 macOS 系统默认设置
6. 安装 Python packages (powerline-status, pyenv 等)
7. 美化 vim、ls、terminal (Solarized 配色 + Powerline 状态栏)

安装完成后，需要配置 Homebrew 环境变量：

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### 恢复备份

使用 [Mackup](https://github.com/lra/mackup) 恢复应用程序配置：

```bash
mackup restore
```

### 多设备管理

管理多台设备的配置建议：

1. 为不同设备创建分支或使用条件配置
2. 使用 Mackup 同步应用程序配置
3. 在 `.gitignore` 中排除设备特定的配置文件

### 常见问题

**问题 1: 连接 raw.githubusercontent.com 失败**

```
curl: (7) Failed to connect to raw.githubusercontent.com port 443
```

解决方法：配置网络代理或修改 hosts 文件

**问题 2: Cargo 环境未找到**

```
.zshenv:.:2: no such file or directory: ~/.cargo/env
```

解决方法：安装 Rust 工具链

```bash
# 方式 1: 使用 Homebrew
brew install rustup
rustup-init

# 方式 2: 官方安装脚本
curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path -y
```

## 使用指南

### dotfiles 说明

执行 `script/bootstrap` 时，脚本会将所有 `*.symlink` 文件链接到 `$HOME` 目录：

| Topic | *.symlink | Link Path |
|-------|-----------|-----------|
| vim   | vimrc.symlink | ~/.vimrc |
| zsh   | zshrc.symlink | ~/.zshrc |
| git   | gitconfig.symlink | ~/.gitconfig |

#### 目录结构

采用主题化的目录结构，每个环境配置独立存放：

- **bin/**: 可执行脚本，会自动添加到 PATH
- **topic/*.zsh**: shell 启动时自动加载
- **topic/path.zsh**: 优先加载的路径配置
- **topic/*.symlink**: 自动链接到 `$HOME` 目录

### macOS 配置

`bin/dot` 在 `script/bootstrap` 最后执行，负责安装软件和配置系统。

**使用方式：**

```bash
# 完整安装（默认）- 包含所有软件包和开发环境
dot

# 轻量安装 - 跳过 Python 和 Node.js 环境配置，只安装必要软件
dot light
```

**完整安装执行流程：**

1. `os/macos/install.sh` - 安装 Homebrew packages
2. `os/macos/set-defaults.sh` - 配置 macOS 系统设置
3. `pkg/python/install.sh` - 配置 Python 环境
4. `pkg/node/install.sh` - 配置 Node.js 环境
5. `os/beautify/install.sh` - 美化终端环境

**轻量安装执行流程：**

1. `os/macos/set-defaults.sh` - 配置 macOS 系统设置
2. `os/beautify/install.sh` - 美化终端环境
3. `os/macos/install.sh light` - 安装必要的 Homebrew packages

#### Homebrew packages

在 `os/macos/install.sh` 中自定义需要安装的软件包：

```bash
# 命令行工具
binaries=(
  git
  tree
  wget
  ...
)

# 字体 (格式: font-XXX)
fonts=(
  font-source-code-pro
  ...
)

# 应用程序
apps=(
  iterm2
  google-chrome
  visual-studio-code
  ...
)
```

#### macOS 系统设置

`os/macos/set-defaults.sh` 会修改系统默认设置，可根据需求自定义。

主要配置项：

- **性能优化**
  - 加快窗口 resize 速度
  - 加速进入睡眠模式
  - 关闭不必要的动画效果

- **触控板/鼠标**
  - 开启轻触点击
  - 开启三指拖拽
  - 开启右键菜单
  - 提高移动速度

- **键盘**
  - 开启全键盘控制
  - 加快按键重复速度
  - 关闭按键长按限制

- **Finder**
  - 显示隐藏文件
  - 显示文件扩展名
  - 显示状态栏和路径栏
  - 允许文本选择
  - 设置默认搜索范围
  - 使用列视图

- **Dock**
  - 窗口最小化到应用图标
  - 自动隐藏/显示
  - 半透明显示隐藏应用

更多配置参考: [Mathias's dotfiles](https://github.com/mathiasbynens/dotfiles/blob/master/.macos)

### Mackup 备份

[Mackup](https://github.com/lra/mackup) 用于备份和同步应用程序配置到云端。

**工作原理：**
将配置文件移动到云盘同步目录（如 `~/Dropbox/Mackup`），然后创建符号链接。

**安装：**

```bash
brew install mackup
```

**配置：**

创建 `~/.mackup.cfg` 文件：

```ini
[storage]
engine = dropbox          # 支持 dropbox, google_drive, icloud
directory = Mackup        # 同步目录名称

[applications_to_sync]
iterm2
oh-my-zsh
sublime-text-3
ssh

[applications_to_ignore]
# 不想同步的应用
```

**自定义应用配置：**

在 `~/.mackup/` 目录下创建配置文件（会覆盖默认配置）：

```bash
# ~/.mackup/sublime-text-3.cfg
[application]
name = Sublime Text 3

[configuration_files]
Library/Application Support/Sublime Text 3/Packages
Library/Application Support/Sublime Text 3/Installed Packages
.config/sublime-text-3/Packages/User
```

**使用：**

```bash
# 备份配置
mackup backup

# 恢复配置
mackup restore

# 取消同步
mackup uninstall
```

**支持的应用：**

| 应用 | 备份内容 |
|------|---------|
| git | `.gitconfig`, `.config/git/ignore` |
| iterm2 | 所有设置 |
| oh-my-zsh | `~/.oh-my-zsh` |
| sublime-text-3 | 插件和配置 |
| pycharm | 配置 |
| vim | `.vimrc`, `.vim` |

更多支持的应用: [Mackup 文档](https://github.com/lra/mackup/tree/master/doc)

### 自定义别名

在对应的 topic 目录下创建 `.zsh` 文件定义别名：

```bash
# 文件格式转换
alias dos2mac="dos2unix -c mac"
alias gbk2utf8="iconv -f GBK -t UTF-8"
alias utf82gbk="iconv -f UTF-8 -t GBK"

# 常用命令
alias tailf="tail -f"
alias ve="pyenv local"

# 安全删除（需要先 brew install trash）
alias rm="trash"
```

## 软件列表

### 命令行工具

| 工具 | 说明 |
|------|------|
| dos2unix | 文本格式转换 |
| wget | 文件下载工具 |
| curl | HTTP 客户端 |
| python | Python 解释器（含 pip） |
| ctags | 代码标签生成器 |
| [grc](http://kassiopeia.juls.savba.sk/~garabik/software/grc/README.txt) | 日志着色工具 |
| [git-flow](https://github.com/nvie/gitflow) | Git 分支管理模型 |
| [tree](http://mama.indstate.edu/users/ice/tree/) | 目录树显示 |
| [mackup](https://github.com/lra/mackup) | 应用配置同步 |
| [z](https://github.com/rupa/z) | 智能目录跳转 |
| tmux | 终端多路复用器 |
| htop | 系统监控工具 |
| [trash](http://hasseg.org/blog/post/406/trash-files-from-the-os-x-command-line/) | 安全删除文件 |
| proxychains-ng | 代理工具 |
| pyenv | Python 版本管理 |
| rustup | Rust 工具链 |
| jq | JSON 处理工具 |
| ripgrep | 快速文本搜索 |
| fd | 快速文件查找 |
| bat | cat 的增强版 |
| exa | ls 的现代化替代 |

### 字体

| 字体 | 说明 |
|------|------|
| [font-source-code-pro](https://fonts.google.com/specimen/Source+Code+Pro) | Adobe 开源等宽字体 |
| font-fira-code | 带连字的编程字体 |

### 应用程序

#### 开发工具

| 应用 | 说明 |
|------|------|
| [iterm2](https://iterm2.com/) | 终端增强工具 |
| [visual-studio-code](https://code.visualstudio.com/) | 代码编辑器 |
| [zed](https://zed.dev/) | 高性能现代化代码编辑器 |
| [sublime-text](https://www.sublimetext.com/) | 文本编辑器 |
| [docker](https://www.docker.com/) | 容器平台 |

#### 浏览器

| 应用 | 说明 |
|------|------|
| [google-chrome](https://www.google.com/chrome) | Chrome 浏览器 |
| firefox | Firefox 浏览器 |

#### 实用工具

| 应用 | 说明 |
|------|------|
| [scroll-reverser](https://pilotmoon.com/scrollreverser/) | 鼠标/触控板滚动方向分离 |
| the-unarchiver | 解压缩工具 |
| appcleaner | 应用卸载工具 |
| [charles](https://www.charlesproxy.com/) | HTTP 抓包工具 |
| nutstore | 坚果云网盘 |

#### 其他应用

| 应用 | 说明 |
|------|------|
| xmind | 思维导图 |
| licecap | GIF 录屏工具 |
| grandperspective | 磁盘空间分析 |
| wireshark | 网络协议分析 |

#### 可选安装（较大或按需安装）

| 应用 | 说明 |
|------|------|
| mysql | MySQL 数据库 |
| mongodb | MongoDB 数据库 |
| nginx | Web 服务器 |
| postgresql | PostgreSQL 数据库 |
| redis | Redis 缓存 |
| virtualbox | 虚拟机 |
| dash | API 文档浏览器 |
| [sourcetree](https://www.sourcetreeapp.com/) | Git 客户端 |
| beyond-compare | 文件对比工具 |

## 已知问题

### Chrome 扩展推荐

| 扩展 | 用途 |
|------|------|
| [Vimium](https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb) | Vim 风格键盘导航 |
| [MetaSuites - Builders' Swiss Army Knife](https://chrome.google.com/webstore/detail/metasuites/aobdjndhikmgjnkihifjdfkekjobcnja) | 开发者工具集合 |
| [Octotree](https://chrome.google.com/webstore/detail/octotree/ihlenndgcmojhcghmfjfneahoeklbjjh) | GitHub 代码树 |
| [Markdown Here](https://chrome.google.com/webstore/detail/markdown-here/elifhakcjgalahccnjkneoccemfahfoa) | Markdown 渲染 |
| [JSONView](https://chrome.google.com/webstore/detail/jsonview/) | JSON 格式化 |

## 更新维护

### 更新 Homebrew 软件

```bash
# 更新 Homebrew 本身
brew update

# 升级所有软件包
brew upgrade

# 升级指定软件包
brew upgrade <package>

# 重新安装软件包
brew reinstall <package>

# 清理旧版本
brew cleanup
```

### 更新 dotfiles

```bash
cd ~/.dotfiles
git pull origin master
./script/bootstrap
```

## 参考资料

- [First steps with Mac OS X as a Developer](http://carlosbecker.com/posts/first-steps-with-mac-os-x-as-a-developer/)
- [如何优雅地在 Mac 上使用 dotfiles?](https://segmentfault.com/a/1190000002713879)
- [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles)
- [GitHub does dotfiles](https://dotfiles.github.io/)
- [Holman's dotfiles](https://github.com/holman/dotfiles)
- [Mathias's dotfiles](https://github.com/mathiasbynens/dotfiles)
- [Mackup Documentation](https://github.com/lra/mackup/tree/master/doc)
- [Oh My Zsh](https://ohmyz.sh/)
- [Homebrew](https://brew.sh/)

## License

MIT License
