# !/bin/sh
# 存放公共插件，业务插件自行 npm install 对应项目安装

plugins=(
	istanbul
	autocannon
	# hexo
	hexo-cli
	# docsify-cli
	docsify-cli
	# yo generator
	generator-generator
	# leetcode
	leetcode-cli
)

if test ! $(which plugins[@])
then
	npm install ${plugins[@]} -g
fi