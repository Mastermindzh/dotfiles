#
# ~/.bash_profile
#

export GOBIN="/home/mastermindzh/.go"
export PATH="$PATH:$(go env GOBIN):$(go env GOPATH)/bin"

[[ -f ~/.bashrc ]] && . ~/.bashrc
