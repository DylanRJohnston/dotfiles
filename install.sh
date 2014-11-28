#!/bin/bash
set -o pipefail
set -o nounset
set -e

IFS=$'\n'
DIR="$(cd "$(dirname "$0")"; pwd)"

function error()
{
    #ANSI escape codes 5 blinking, 37 white text, 41 red background, 0 nothing.
    printf "\e[5;37;41mError\e[0;37;41m: $@ \n\e[0m"
}

if [[ -z "${HOME}" ]]; then
    error "HOME envrioment variable not set!"
    exit 1
fi

for file in $(ls -1 "${DIR}" | grep -Ev "$(cat "${DIR}/.ignore" | paste -sd \| -)"); do

    #TODO recursively merge directories like .ssh to not override keys
    if [[ -d "${HOME}/.${file}" ]]; then
        error "Cannot merge directory ${file}, please remove and/or manually merge"
    fi

    ln -sf "${DIR}/${file}" "${HOME}/.${file}"
done
