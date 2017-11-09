# Aliases
#######################################################################################################

# alias sudo so I can use my aliases with the sudo command
alias sudo="sudo "

alias ll="ls -la"

# vim => nvim
alias vim="nvim"
# alias vi="nvim"

# rebar3 => rebar
alias rebar="rebar3"

# Changing/making/removing directory
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
