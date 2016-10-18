
##
# Your previous /Users/ethan/.profile file was backed up as /Users/ethan/.profile.macports-saved_2015-03-05_at_14:21:36
##

# MacPorts Installer addition on 2015-03-05_at_14:21:36: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

#export PS1="\e[0;32m\u@\h[\@]\e[m:\e[0;36m\W\e[m\$ "
green=$(tput setaf 2);blue=$(tput setaf 6);reset=$(tput sgr0);PS1='\[$green\]\u@\h[\@]\[$reset\]:\[$blue\]\W\[$reset\]\$ ';export PS1;
