# Aliases
#######################################################################################################

alias sudo="sudo " # alias sudo so I can use my aliases with the sudo command
alias ll="ls -lah"
alias vim="nvim"
alias gca="open -na Google\ Chrome --args --disable-web-security --user-data-dir=\"\""

alias gch="git checkout "
alias gs="git status"
alias gap="git add -p"
alias gco="git commit"
alias gcm="git commit -m"

# Changing/making/removing directory
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias gitlog="git log --graph --pretty=format:'%Cred%h %Cgreen(%cr) %Cblue%an%Creset: %s - %Creset%C(yellow)%ai%Creset' --abbrev-commit --date=relative"
alias dockerbash="docker run --rm -it --entrypoint bash $1"

alias nixf="nix --extra-experimental-features nix-command --extra-experimental-features flakes"

function senv() {
    echo "Sourcing $1"
    set -o allexport && source $1 && set +o allexport
}
