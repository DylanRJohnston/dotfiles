#!/bin/env bash

case "$(uname)" in
    "Darwin" )
        export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/opt/X11/bin:/usr/texbin"
        export HOMEBREW_MAKE_JOBS="$(sysctl -n hw.logicalcpu)"
        alias ls="gls --color"
        alias xargs="gxargs"
        alias mango="mongod --setParameter textSearchEnabled=true --config /usr/local/etc/mongod.conf"
        alias gitclear="git reflog expire --expire=now --all && git gc --prune=now --aggressive"

        [[ -e /opt/intel/bin/iccvars.sh ]] && source /opt/intel/bin/iccvars.sh -arch intel64 -platform mac

        eval "$(gdircolors ~/.dircolors)"

        if [ -f "${HOME}/.gpg-agent-info" ] && kill -0 "$(head -n 1 < "${HOME}/.gpg-agent-info" | awk 'BEGIN { FS = ":" }; {print $2}')" &>/dev/null; then
            . "${HOME}/.gpg-agent-info"
            export GPG_AGENT_INFO
            #export SSH_AUTH_SOCK
            #export SSH_AGENT_PID
        else
            eval "$(/usr/local/bin/gpg-agent)"
        fi

        GPG_TTY=$(tty)
        export GPG_TTY


        function free() {
            vm_stat | perl -ne '/page size of (\d+)/ and $size=$1; /Pages\s+([^:]+)[^\d]+(\d+)/ and printf("%-16s % 16.2f Mi\n", "$1:", $2 * $size / 1048576);'
        }

        if [ -f $(brew --prefix)/share/bash-completion/bash_completion ]; then
            . $(brew --prefix)/share/bash-completion/bash_completion
        fi

    ;;

    "Linux" )
        eval "$(dircolors ~/.dircolors)"
        case $(hostname -i) in
            172.16.* )
                ##At Work
                export PATH="$PATH:/d/sw/bin"
                export MODULE_VERSION=3.2.7
                export DUGEO_SOFTWARE="/d/sw"

                source "$DUGEO_SOFTWARE/Modules/$MODULE_VERSION/init/bash"
                umask 0002

                module add intel-rt/2015.0.090
                module add intel-composer/2015.0.090
                module add libcurl
                module add glib2
                module add openmpi
                module add dugio
                module add java64
                module add openssl
                module add cwp.su

                module add slurm
                module add git

                function jobInfo() {
                    sacct --format=JobID,JobName,Partition,NodeList,State,ExitCode,Elapsed,CPUTime,AllocCPUS -j $@
                }
            ;;
        esac
    ;;
esac

export PDSH_SSH_ARGS_APPEND="-o StrictHostKeyChecking=no"
export CLICOLOR=1
export WINEDEBUG="-all"
export PS1="[\u@\h \${?}]:$ "
export FLEETCTL_TUNNEL=172.17.8.101

alias sl="ls"
alias ll="ls -l"
alias gitlog="git log --pretty=oneline --graph --decorate --all"
alias htop="TERM=screen htop"
alias v="vagrant"
alias fleetctl-destroy-all-units='fleetctl destroy $(fleetctl list-units -fields=unit -no-legend)'
alias fleetctl-destroy-all-unit-files='fleetctl destroy $(fleetctl list-unit-files -fields=unit -no-legend)'
alias cast="DEBUG=castnow* castnow --address=192.168.1.114"
alias flix="peerflix --vlc"

# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
export HISTCONTROL=erasedups
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

function mmongo() {

eval "$(meteor mongo -U $1 | sed -E 's#.+//([^:]+):([^@]+)@(.+)#mongo -u \1 -p \2 \3#')"

}

function man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;016m\E[48;5;220m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

function sparseGitInit()
{
    git init
    git config core.sparsecheckout true
    echo $@ >> .git/info/sparse-checkout
}

function lsearch()
{
    #Created with `gpg2 --batch --encrypt --armor --recipient %gpg_key_id% <<< "-D %binddn% -w %password%"`
    LDAP_BIND_DN_AND_PW=$(
        2>/dev/null gpg2 --batch --decrypt <<EOL
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
EOL)

    ldapsearch -o ldif-wrap=no -xLLLZZ ${LDAP_BIND_DN_AND_PW} ${@}
}
