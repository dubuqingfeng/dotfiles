if [ -d /usr/local/opt/go/libexec ]; then
    export GOROOT=/usr/local/opt/go/libexec
fi
if [ -d /usr/local/go ]; then
    export GOROOT=/usr/local/go
fi
export GOPATH=$HOME/.go
export PATH="$PATH:${GOROOT}/bin:${GOPATH}/bin"
