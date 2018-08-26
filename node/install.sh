# !/bin/sh

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
	# wormhole
	wormholecash
	wormhole
)

if test ! $(which plugins[@])
then
	npm install ${plugins[@]} -g
fi