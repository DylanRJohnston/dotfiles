#!/usr/bin/env bash
set -o pipefail
set -o nounset
set -o errexit

# set -x

# cd /tmp
# git clone https://github.com/DylanRJohnston/dotfiles.git
# cd dotfiles

DIR="$(cd "$(dirname "$0")"; pwd)"
IFS=$'\n'
FILES=( $(ls -1 "${DIR}/dotfiles") )
# echo "${DIR}"
for FILE in "${FILES[@]}"; do
    echo "Installing ${FILE}"
    FILE_PATH="${HOME}/.$FILE"
    mkdir -p "$(dirname $FILE_PATH)" || true
    ln -sf "${DIR}/dotfiles/${FILE}" "${FILE_PATH}"
done

#./other/install.sh
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# error() {
#     #ANSI escape codes 5 blinking, 37 white text, 41 red background, 0 nothing.
#     printf "\e[5;37;41mError\e[0;37;41m: $@ \e[0m\n"
# }
#
# if [[ -z "${HOME}" ]]; then
#     error "HOME envrioment variable not set!"
#     exit 1
# fi
#
# for file in $(ls -1 "${DIR}" | grep -Ev "$(cat "${DIR}/.ignore" | paste -sd \| -)"); do
#
#     #TODO recursively merge directories like .ssh to not override keys
#     if [[ -d "${HOME}/.${file}" ]]; then
#         error "Cannot merge directory ${file}, please remove and/or manually merge"
#         continue
#     fi
#
#     ln -sf "${DIR}/${file}" "${HOME}/.${file}"
# done
