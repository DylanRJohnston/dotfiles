set -gx PATH /Users/dylanj/.local/bin $PATH
set fish_greeting ""

set -gx HOMEBREW_MAKE_JOBS (sysctl -n hw.logicalcpu)

alias sl "ls"
alias flix "peerflix --vlc"
alias ffmpeg "ffmpeg -hide_banner"
alias leaving-work "diskutil unmountDisk 'Time Machine'"
alias gitlog "git log --oneline --grpah --decorate --all"

function start-gpg-agent
    /usr/local/bin/gpg-agent ^/dev/null
    set -gx GPG_AGENT_INFO (sed -E 's/.*=(.*)/\1/' <~/.gpg-agent-info)
    set -gx GPG_TTY (tty)
end
start-gpg-agent

function man
    set -x LESS_TERMCAP_mb (printf "\e[01;31m")
    set -x LESS_TERMCAP_md (printf "\e[01;31m")
    set -x LESS_TERMCAP_me (printf "\e[0m")
    set -x LESS_TERMCAP_se (printf "\e[0m")
    set -x LESS_TERMCAP_so (printf "\e[01;44;33m")
    set -x LESS_TERMCAP_ue (printf "\e[0m")
    set -x LESS_TERMCAP_us (printf "\e[01;32m")
    env man $argv
end

function decrypt-wrapper
    echo $argv[1] | sed -E 's/^ +(.*)/\1/' | gpg --batch --decrypt
end

function where
    ll (which -a $argv)
end

set -gx HOMEBREW_GITHUB_API_TOKEN (decrypt-wrapper ^/dev/null "
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
    "
)
