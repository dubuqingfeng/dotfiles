# !/bin/sh

plugins=(
	istanbul
	autocannon
	# hexo
	hexo-cli
)

if test ! $(which plugins[@])
then
	npm install ${plugins[@]} -g
fi