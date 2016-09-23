#!/usr/bin/env bash

#
# Environment
#
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/opt/X11/bin:/usr/texbin"
export PS1=$'\\[\e[1;36m\\]$? \\[\e[1;33m\\]-> \\[\e[0m\\]'
export PDSH_SSH_ARGS_APPEND="-o StrictHostKeyChecking=no"
export HOMEBREW_MAKE_JOBS="$(sysctl -n hw.logicalcpu)"
export FLEETCTL_TUNNEL=172.17.8.101
export WINEDEBUG="-all"
export CLICOLOR=1

eval "$(gdircolors ~/.dircolors)"

# Eternal bash history.
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
export HISTCONTROL=erasedups
export HISTFILE=~/.bash_eternal_history
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# Aliases
alias ls="gls --color"
alias sl="ls" # Fuck steam locomotive
alias ll="ls -l"
alias la="ls -la"

alias v="vagrant"
alias xargs="gxargs"
alias flix="peerflix --vlc"
alias htop="TERM=screen htop"
alias ffmpeg="ffmpeg -hide_banner"
alias cast="DEBUG=castnow* castnow --address=192.168.1.114"
alias gitlog="git log --oneline --graph --decorate --all"
alias gitclear="git reflog expire --expire=now --all && git gc --prune=now --aggressive"
alias mango="mongod --setParameter textSearchEnabled=true --config /usr/local/etc/mongod.conf"
alias fleetctl-destroy-all-units='fleetctl destroy $(fleetctl list-units -fields=unit -no-legend)'
alias fleetctl-destroy-all-unit-files='fleetctl destroy $(fleetctl list-unit-files -fields=unit -no-legend)'

#
# Bash Completion
#

if [ -f $(brew --prefix)/share/bash-completion/bash_completion ]; then
    . $(brew --prefix)/share/bash-completion/bash_completion
fi

#
# GPG AGENT
#

AGENT_INFO_PATH="${HOME}/.gpg-agent-info"
if \
    # If the gpg-agent-info file exists
    [ -f "${AGENT_INFO_PATH}" ] && \
    # And the process running at the specified PID is gpg-agent
    [ \
        "/usr/local/bin/gpg-agent" == \
        "$(ps -o command= -p "$(
            IFS=':'
            INFO=($(< "${AGENT_INFO_PATH}"))
            echo "${INFO[1]}"
        )")" \
    ]
then
    . "${AGENT_INFO_PATH}"
    export GPG_AGENT_INFO
else
    eval "$(/usr/local/bin/gpg-agent)"
fi

GPG_TTY=$(tty)
export GPG_TTY

#
# MISC FUNCTIONS
#

# Strips the preceding whitespace and decrypts the input string using gpg-agent
function decrypt-wrapper() {
    gpg --batch --decrypt <(sed -E 's/^ +(.*)/\1/' <<< "$1")
}

# Mimics the free command from Linux
function free() {
    vm_stat | perl -ne '/page size of (\d+)/ and $size=$1; /Pages\s+([^:]+)[^\d]+(\d+)/ and printf("%-16s % 16.2f Mi\n", "$1:", $2 * $size / 1048576);'
}

# Work around for the mongo meteor command
mmongo() {
    eval "$(meteor mongo -U $1 | sed -E 's#.+//([^:]+):([^@]+)@(.+)#mongo -u \1 -p \2 \3#')"
}

# Gives highlighting of key terms to man pages
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;016m\E[48;5;220m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

# Initialises a spare git repository. Would typically use `git remote add` and `git pull` after this.
sparseGitInit() {
    git init
    git config core.sparsecheckout true
    echo $@ >> .git/info/sparse-checkout
}

# LDAP server search, the username and password are enecrypted.
# Example usage: `lsearch cname="dylanj"`
function lsearch() {
    LDAP_BIND_DN_AND_PW=$(decrypt-wrapper "
        -----BEGIN PGP MESSAGE-----
        Version: GnuPG v2

        hQIMAzM1XH36g+InAQ/5AWB5/iHyjjE5oiw7niW4kYsMnQadzMbvttTQoTWNsLlb
        F3APJXPvCyil09aqeWlp63n5uJlxOpGveEWi4s2o+q3XYcOBgHqpkSeYldiPVCfI
        DfiuGRAoMBDYdfMyBSwFswSOTjB6dGwQldfMuIaxLv0Du85J7+YobAG9tvTQaT7D
        1EifjwCCXWYazREw0Yb7Es/1TUTf/tVrfxwo1GHa6mhpcDG0/eqIntmOEFaPtAVk
        Ddtdg5CF70jhhl2orECkUk8Dz5CYCBJsYoVAoCkM9AD764oXBIjVdoe8Hrou0+W0
        AEDRs5UAcfDRtOLEKYjbRZvZ1fcjgcbKm3VOH+Nrk5E1Tc03Rc5bnt67KDBV9ijP
        li18ToV5T6TGuEUyoNkTjCrkcs2LXaMVodD41KLX3SmBOz7XraEpdIqvOx5j6Ncs
        NNYkK3qptiFe0uVWvOGnfuMXq7vJOzdzdm65uQjsVGlDZYRO80bvn5VOUB44vdRh
        EN6+ucuxPTbYub6cWSM3yaOXOE9rEocGwnL1iIDLtzuT+g6PgPu61L1F5Y6NXVuG
        OCX40wgiZaetSrFdVotFrBqmrymFrpxGBmKm32fkg3W6XrG4On2mfTAO/eucRmys
        rM/56sEsE9n1+9QZWnbcq5wOFNCYF3rsVgaTSe1geP+9vgVg2Wvj2HUHdcHvJfLS
        ZAEg3SyQDh8AdxeZSQpYawaXrpFW9l9GLMm2H8QpGfCtx83UoRYOmsz3OZ072Eja
        X3B7ow2rfaN99Tgif/5uxfJL60tWC47kB1wQmILSXZ4QrrFjFNKag582MQrPnxAq
        sYpQbe4=
        =h0Xt
        -----END PGP MESSAGE-----
        "
    );
    ldapsearch -o ldif-wrap=no -xLLLZZ ${LDAP_BIND_DN_AND_PW} ${@}
}

# Decompresses streams in pdf files for easier inspection / parsing
# Using dpdf $INPUT_FILE $OUTPUT_FILE
function dpdf() {
    qpdf --qdf --object-streams=disable "$1" "$2"
}

# Livescript inspector. Useful for debugging, opens up on the transpiled javascript of a livescript file.
# Warning: If you background vim with ^Z, the file will not be removed properly and cause problems.
# Example usage: li $LIVESCRIPT_FILE
function li() {
    OUT="${1%.ls}.js"
    lsc -c "$1" && vim "$OUT" && rm "$OUT"
}

# Sets the exit code, useful for some werid things.
bexit() { return $1; }

function where {
    ll $(which "${@}")
}

#
# HOMEBREW GITHUB API TOKEN
#

export HOMEBREW_GITHUB_API_TOKEN="$(decrypt-wrapper "
    -----BEGIN PGP MESSAGE-----
    Version: GnuPG v2

    hQIMA3X6OWk9Plj9AQ//fKG/avgnLSdkiNfLDjSQ073Befw9+SPrMy87WkLteMfs
    MLRGSoYOCu1zoaP067aAi20XT1v+SVyBbKdZGbWuzwjWnaQwNzDp6dd9Xa0S8IWQ
    oWfLgOUyBgtPP2++CxQU6o7YfmYv4QzX0nDaZ5O/1OpkNZVkVQnv64LTB89QtvXm
    EVdqWMVCe79K+eq50zWgSQlBBCiySmIuz3V3rfyNDkmvTBwbsvF/FXx9cb7BZCaX
    AOfTnL1zOwzle5a66ffsBBPuAL3Gpfmg3+A/8r0Ey3JpTsAqqwSAphd7uw7sSZzE
    K9TXwT7IEHClkQJeV3bswGC9wy4LbKuwW87DXMBND022zIgpZkyRA+Zfkw14FAZR
    icKlc3mYFkcs0cmXlYdSj68YRFKV3z5RabSfakcJjdPqSFBbhigOQUTAeDcr+Fq3
    LA6iX6xxuOzVgJPtIYXY77viWaLItCdKkePhxZl3x5UYAnzGNimvt+t85NTrKFcJ
    LfJoeDyPEKUcwF1zNA0FDK9sQ8ydhKZqsA7Ru9t0+9o2jRf/0bswULAWGlbYFhlV
    dYCjcBHKM4Vlm1f6d6YMqjmj5tTaJ0e4XBDoqDPk2190SAE/wgr4vCx86qBnF2OQ
    MdjGLHxu+Z3rmaGzERuYG6X352dj2aSl0HweUZKXRQn+eQRBwqZVkFDk51mgI87S
    YwF536I8525Fy3v9x4HkjPek9eXCcz1zSHxST3Hrm0YG0rWWOL0QtqOjywtH2/aa
    zFvYr0dpKD697GK9CBwCeomMgLg5PoaN2pKBy4/a/+16FXs9dxQkqOHerkexWtm7
    m6QTRQ==
    =XTRU
    -----END PGP MESSAGE-----
    " 2>/dev/null
)"

