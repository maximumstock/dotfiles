# Aliases
#######################################################################################################

# alias sudo so I can use my aliases with the sudo command
alias sudo="sudo "

alias ll="ls -la"

# vim => nvim
alias vim="nvim"

# rebar3 => rebar
alias rebar="rebar3"
alias python="PYTHONPATH=$(pwd) python"

# Changing/making/removing directory
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
