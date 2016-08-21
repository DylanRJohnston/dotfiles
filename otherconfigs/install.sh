#!/usr/bin/env bash

set -o pipefail
set -o nounset
set -o errexit

readInFile() {
    < $1 grep -oE '^[^#]+' | tr '\n' ' '
}

brew tap $(readInFile ./Tapfile)
brew install $(readInFile ./Brewfile)
brew cask install $(readInFile ./Caskfile)
#npm i -g $(readInFile ./Nodefile)
apm install $(readInFile ./Atomfile)


for APP in $(readInFile ./Masfile); do
    mas install $APP
done
