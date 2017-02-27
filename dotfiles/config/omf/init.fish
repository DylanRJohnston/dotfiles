#!/usr/bin/env fish

#
# Stops this file being run multiple times
#

set -gx SHELL_NESTING "!$SHELL_NESTING"

if test $SHELL_NESTING != "!!!"
    exit 0
end

#
# UTILITY FUNCTIONS
#

function cd --description 'Change directory'
    set -l MAX_DIR_HIST 25

    if test (count $argv) -gt 1
        printf "%s\n" (_ "Too many args for cd command")
        return 1
    end

    # Skip history in subshells.
    if status --is-command-substitution
        builtin cd $argv
        return $status
    end

    # Avoid set completions
    set -l previous $PWD

    if test "$argv" = "-"
        if test "$__fish_cd_direction" = "next"
            nextd
        else
            prevd
        end
        return $status
    end

    set -l cd_status
    if test -d "$argv"
        builtin cd $argv
        set cd_status $status
        z --add (pwd)
    else
        z $argv
        set cd_status $status
    end

    if test $cd_status -eq 0 -a "$PWD" != "$previous"
        set -q dirprev[$MAX_DIR_HIST]
        and set -e dirprev[1]
        set -g dirprev $dirprev $previous
        set -e dirnext
        set -g __fish_cd_direction prev
    end

    return $cd_status
end

# Fuck steam locomotive
function sl
    ls $argv
end

# Sick of type this out
function flix
    peerflix --vlc $argv
end

# Hide the ffmpeg banner
function ffmpeg
    command ffmpeg -hide_banner $argv
end

# Commands to run when leaving work. Right now just unmounts the time machine backup
function leaving-work
    diskutil unmountDisk 'Time Machine'
end

# Better git log
function gitlog
    git log --oneline --graph --decorate --all $argv
end

function gitclear
    git reflog expire --expire=now --all ;and git gc --prune=now --aggressive
end

# Update all the vim packages
function vim-update-packages
    vim +BundleInstall +BundleClean +q $arv
end

# Startup the gpg agent. Why doesn't gpg-agent handle its own service?
function start-gpg-agent
    /usr/local/bin/gpg-agent ^/dev/null >/dev/null
    set -gx GPG_TTY (tty)
    for x in GPG_AGENT_INFO SSH_AUTH_SOCK SSH_AGENT_PID
        set -gx $x (sed -En "/"$x"/s/.*=(.*)/\1/p" <~/.gpg-agent-info)
    end
end

# Give highlighting to man pages
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

# Wrapper command for decrypting inline cipher text. See HOMEBREW_GITHUB_API_TOKEN
function decrypt-wrapper
    echo $argv[1] | sed -E 's/^ +(.*)/\1/' | gpg --batch --decrypt
end

# Mimics the free command on Linux
function free
    vm_stat | perl -ne '/page size of (\d+)/ and $size=$1; /Pages\s+([^:]+)[^\d]+(\d+)/ and printf("%-16s % 16.2f Mi\n", "$1:", $2 * $size / 1048576);'
end

# Like which but resolves sym links. Useful for homebrew
function where
    ll (which -a $argv)
end

# Tells you when long running commands have finished or crashed
function tellme
    eval $argv ;and say done ;or say failed
end

# Gives you the repl for purescript when not using pulp
function prepl
    psci 'bower_components/purescript-*/src/**/*.purs' 'src/**/*.purs' $argv
end
end

function decrypt-audible
    set -l activation_bytes (decrypt-wrapper ^/dev/null "
        -----BEGIN PGP MESSAGE-----
        Version: GnuPG v2

        hQIMA3X6OWk9Plj9AQ//U79zuiW1oJ0YanbAEZ9hRXJ7iBidrPzZuFM/kvnbq+0U
        CCy7OtMU4iYX1rx1jRfA3hCK53aDPpMhfFeVgQTNICpwbOQ9QJumfMPhKRnqs7ay
        le/RvH2giHWccQMF8u3f5Uef9B74iklbW5Y5ufrAyMj5ROukttlsEq1oSWZhC4qy
        zqlHXMk2x1O2uJ23S1DrRGb21H4bZiUG5FByHTQO2PAE6+kkl3vDH9Prw4p9EwEf
        oIY9/tR1gB4p4O+b6TtnMdHeT8D+7055Pfn6JbC42DNfdcvrrmtmJD9iAzTzES0h
        b3K5MNebg7eIbfEK2jMtkGAsQWIfGVxvpZfJiq0RbHVx/l2Be7g4aCU1RCjJ44Dz
        +60BQx02SdvWxGJN5Fyx1vBIIqe398H5HdS9xh03Pm1RucmX2Z5QUGlmvtbAaoip
        hBJcx2e7QF+Qwij6xNCCBZ4f49e2yjpYs2gcBdWJYKwVzDY8auJ7H/BFTwGJWlcZ
        esBW6Wk8/PrR1GcvZs+1KmnIFta/DHKaQYRBCCYQ5i1ubtPYZZ9uGygUSgOp4Iq6
        ud1LwHOYeceyDzgKTQ93AaiVFZ490mh1wXIhCpIsL/N/8YFFDV/SHUi5w2ZilVac
        T5ILMRylmIuQ3Q6hHms7hzoLIPHCkmoqVxRDNTKYB33HS5Zjg9rJjptncrhzSu7S
        QwGz5dAFOVz5XommVGeCBlZ7Dz85yRUAlqG3tqGZUYyY6i9FGIBnwl9pMBwIqzDE
        o51D2jJPWZZ9LOZH0cID7qRtgfo=
        =SU37
        -----END PGP MESSAGE-----
        "
    )
    ffmpeg -activation_bytes $activation_bytes -i $argv[1] -vn -c:a copy (basename $argv[1] .aax).m4a
end
#
# ENVIRONMENT VARIABLES
#
set -gx PATH /Users/dylanj/.local/bin $PATH
set -gx HOMEBREW_MAKE_JOBS (sysctl -n hw.logicalcpu)

set fish_greeting ""

# Startup the gpg agent
start-gpg-agent

# Decrypt the github api token
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
