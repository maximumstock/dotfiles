# Aliases
#######################################################################################################

# alias sudo so I can use my aliases with the sudo command
alias sudo="sudo "
alias ll="ls -lah"
alias vim="nvim"
alias gca="open -na Google\ Chrome --args --disable-web-security --user-data-dir=\"\""

# Changing/making/removing directory
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias gitlog="git log --graph --pretty=format:'%Cred%h %Cgreen(%cr) %Cblue%an%Creset: %s - %Creset%C(yellow)%ai%Creset' --abbrev-commit --date=relative"
