# General zsh settings
#############################################################################################

# smart urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# Set Apple Terminal.app resume directory
# Lets you open new tabs with the same directory with CMD + T
# Source: http://superuser.com/questions/313650/resume-zsh-terminal-os-x-lion
if [[ $TERM_PROGRAM == "Alacritty" ]] && [[ -z "$INSIDE_EMACS" ]] {
  function chpwd {
    local SEARCH=' '
    local REPLACE='%20'
    local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
    printf '\e]7;%s\a' "$PWD_URL"
  }

  chpwd
}

