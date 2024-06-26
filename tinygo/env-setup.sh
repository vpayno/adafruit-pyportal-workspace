# source this file

# shellcheck disable=SC2155
export GOROOT="$(tinygo info pyportal | awk '/GOROOT:/ {print $NF}')"
export GOPATH="${HOME}/go:/usr/local/lib/tinygo"
export GOFLAGS="-tags=$(tinygo info pyportal | grep "build tags" | awk -F" {1,}" '{ for(i=3;i<NF;i++) printf $i","; print $NF }')"
