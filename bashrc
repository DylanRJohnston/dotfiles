#!/bin/env bash
# If we're not already in a TMUX session attatch to the existing one or spawn a new one
[ -z ${TMUX+x} ] && ( tmux attach-session || tmux )

#
# Environment
#
export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/opt/X11/bin:/usr/texbin"
export PS1=$'\\[\e[1;36m\\]$? \\[\e[1;33m\\]\u2192 \\[\e[0m\\]'
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
alias sl="ls"
alias ll="ls -l"
alias la="ls -la"

alias v="vagrant"
alias xargs="gxargs"
alias flix="peerflix --vlc"
alias htop="TERM=screen htop"
alias cast="DEBUG=castnow* castnow --address=192.168.1.114"
alias gitlog="git log --pretty=oneline --graph --decorate --all"
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

if [ -f "${HOME}/.gpg-agent-info" ] && kill -0 "$(head -n 1 < "${HOME}/.gpg-agent-info" | awk 'BEGIN { FS = ":" }; {print $2}')"; then
    . "${HOME}/.gpg-agent-info"
    export GPG_AGENT_INFO
else
    eval "$(/usr/local/bin/gpg-agent)"
fi

GPG_TTY=$(tty)
export GPG_TTY

#
# MISC FUNCTIONS
#

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
    LDAP_BIND_DN_AND_PW=$(
        2>/dev/null gpg2 --batch --decrypt <(
            sed -E 's/^ +(.*)/\1/' \
<<EOL
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
EOL
        );
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

# Creates a new meteor project with safe and sane defaults
# function meteor_new_safe() {
#     REMOVE=( autopublish insecure )
#     ADD=( check audit-argument-checks aldeed:collection2 service-configuration meteorhacks:kadira )
#     meteor create . && meteor remove autopublish insecure && meteor add check audit-argument-checks
# }
