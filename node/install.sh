# !/bin/sh

plugins=(
	istanbul,
	autocannon
)

if test ! $(which plugins[@])
then
	npm install ${plugins[@]} -g
fi