# alias
alias dos2mac="dos2unix -c mac"
alias gbk2utf8="iconv -f GBK -t UTF-8"
alias utf82gbk="iconv -f UTF-8 -t GBK"
alias tailf="tail -f"
# python versions
alias ve="pyenv local"
alias rm="trash"
alias g++="g++-4.8"
alias gcc="gcc-4.8"
# 
# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if $(gls &>/dev/null)
then
  alias ls="gls -F --color"
  alias l="gls -lAh --color"
  alias ll="gls -l --color"
  alias la='gls -A --color'
fi
