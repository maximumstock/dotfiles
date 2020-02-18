# Aliases
#######################################################################################################

# alias sudo so I can use my aliases with the sudo command
alias sudo="sudo "
alias ll="ls -la"
alias vim="nvim"
alias gca="open -a Google\ Chrome --args --disable-web-security --user-data-dir=\"\""

# Changing/making/removing directory
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias gitlog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"

