#!/usr/bin/env bash

set -o pipefail
set -o nounset
set -o errexit

readInFile() {
    < $1 grep -oE '^[^#]+' | tr '\n' ' '
}

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap $(readInFile ./Tapfile)
brew install $(readInFile ./Brewfile)
brew cask install $(readInFile ./Caskfile)
apm install $(readInFile ./Atomfile)

for APP in $(readInFile ./Masfile); do
    mas install $APP
done

curl -L http://get.oh-my.fish | fish

omf install agnoster
omf install z-cd
omf theme agnoster

curl http://j.mp/spf13-vim3 -L -o - | sh
vim +BundleInstall! +BundleClean +q

./settings.sh
