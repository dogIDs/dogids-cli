# Aliases useful for Codelation development
alias desktop="cd ~/Desktop"
alias downloads="cd ~/Downloads"
alias fixopenwith="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain user"
alias gg="git status -s"
alias gitclean='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'
alias ll="ls -lah"
alias railsclean="RAILS_ENV=development rake assets:clean; RAILS_ENV=development rake tmp:clear; RAILS_ENV=test rake assets:clean; RAILS_ENV=test rake tmp:clear"
alias ss="bundle exec rake start"
alias sshdogids="ssh -R 52698:localhost:52698 -p 22711 root@dogids.com"

# Add Postgres commands from Postgres.app
PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.4/bin

# Add Ruby binary to PATH first, overriding the system Ruby
PATH=~/.codelation/ruby/bin:$PATH

# Git Completion & Repo State
# http://neverstopbuilding.com/gitpro
source ~/.codelation/bash/.git-completion.bash
source ~/.codelation/bash/.git-prompt.sh

MAGENTA="\[\033[0;35m\]"
YELLOW="\[\033[0;33m\]"
BLUE="\[\033[34m\]"
LIGHT_GRAY="\[\033[0;37m\]"
CYAN="\[\033[0;36m\]"
GREEN="\[\033[0;32m\]"
GIT_PS1_SHOWDIRTYSTATE=true
export LS_OPTIONS='--color=auto'
export CLICOLOR='Yes'
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

export PS1=$LIGHT_GRAY"\u@\h"'$(
    if [[ $(__git_ps1) =~ \*\)$ ]]
    # a file has been modified but not added
    then echo "'$YELLOW'"$(__git_ps1 " (%s)")
    elif [[ $(__git_ps1) =~ \+\)$ ]]
    # a file has been added, but not commited
    then echo "'$MAGENTA'"$(__git_ps1 " (%s)")
    # the state is clean, changes are commited
    else echo "'$CYAN'"$(__git_ps1 " (%s)")
    fi)'$BLUE" \w"$GREEN": "
