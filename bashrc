#!/bin/bash

OS="$(uname)"
case $OS in
    "Darwin" )
        export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/opt/X11/bin:/usr/texbin"
        alias ls="gls --color"
        alias xargs="gxargs"

        eval "$(gdircolors ~/.dircolors)"

        if [ -f "${HOME}/.gpg-agent-info" ] && kill -0 "$(awk 'BEGIN { FS = ":" }; {print $2}' < "${HOME}/.gpg-agent-info")" &>/dev/null; then
            export "$(cat "${HOME}/.gpg-agent-info")"
        else
            eval "$(/usr/local/bin/gpg-agent --daemon --write-env-file)"
        fi

        function free() {
            vm_stat | perl -ne '/page size of (\d+)/ and $size=$1; /Pages\s+([^:]+)[^\d]+(\d+)/ and printf("%-16s % 16.2f Mi\n", "$1:", $2 * $size / 1048576);'
        }

        if [ -f $(brew --prefix)/etc/bash_completion ]; then
            . $(brew --prefix)/etc/bash_completion
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

                module add slurm

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
alias lsearch="ldapsearch -o ldif-wrap=no -xZZ"
alias cast="DEBUG=castnow* castnow --address=192.168.0.21"

function man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}
