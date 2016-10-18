# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
    xterm-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Stage TextMate Terminal environment
export EDITOR="/usr/local/bin/mate -w"
#export PS1="\e[0;32m\u@\h[\@]\e[m:\e[0;36m\W\e[m\$ "
export PS1="\[\e[0;32m\]\u@\h[\@]\[\e[m:\e[0;36m\]\W\[\e[m\]\$ "
export PATH="$PATH:/opt/local/bin:/opt/local/sbin"
source "/Users/ethan/Build/bash-wakatime/bash-wakatime.sh"

portpybin() {
args=( $@ );
if [[ $1 == "?" || $1 == "--help" || $1 == "help" || $# == 0 ]]; then
        echo -en 'portpybin:\n\tA shortcut to run from the macports python2.7 path.\n\n\t';
        tput smul; echo -en 'portpybin pydoc sys'; tput rmul; echo -en ' is the same as\n\t';
        tput smul; echo -en '/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin/pydoc sys'; tput rmul; echo -en '\n';
else
args[0]="/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin/${args[0]}";
${args[*]};
fi;
}


# Preserve bash history for simultaneous terminal windows
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

wbanner() {
        tput setaf 6; tput bold; figlet -c -w $(tput cols) "iJunkie22"; tput sgr0;
}

nlc() {
        grep --color -E "(^ *[0-9]*)" <(nl "$@");
}

pingc() {
        grep --color -E "(( )|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))" <(ping $@);
}

portc() {
        if [[ "$1" == "search" ]]; then
                (port search "$2" | perl -p0e "s/(\)\n)/\)\n    /g" | grep -i --color -E "(^$)| |$2")
                
        elif [[ "$1" == "info" ]]; then
                (port info "$2" | awk '{print "<"$0}' | fold -s -w $(( `tput cols` - 22 )) | perl -p0e 's/(^[^<])/                      $1/gm;s/^<//gm' | grep -E "(^[a-zA-Z][a-zA-Z ]{2,22}([sneh]:)?|^                    )")
        else
                (port $@;)
        fi;

}

find_hidden() {
        find $@ | while read line; do echo "$(GetFileInfo -av "$line") $line";done | grep -E "^1" | cut -d ' ' -f2-;
}

fast_find_hidden() {
         while read line; do echo "$(GetFileInfo -av "$line") $line";done | grep -E "^1" | cut -d ' ' -f2-;
        
}

alias gls='gls -a --color'
eval `gdircolors ~/.dir_colors`
alias pygrep='~/Developer/PycharmProjects/pygrep/pygrep.py'
alias pip3='pip-3.5'
alias django-admin='/opt/local/Library/Frameworks/Python.framework/Versions/3.5/bin/django-admin'
wbanner;
