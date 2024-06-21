# ZSH colors for files, folders, etc.
#############################################################################

typeset -Ag FX FG BG

LS_COLORS="di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:"

FX=(
    reset     "%{%}"
    bold      "%{%}" no-bold      "%{%}"
    italic    "%{%}" no-italic    "%{%}"
    underline "%{%}" no-underline "%{%}"
    blink     "%{%}" no-blink     "%{%}"
    reverse   "%{%}" no-reverse   "%{%}"
)

for color in {000..255}; do
    FG[$color]="%{color}m%}"
    BG[$color]="%{color}m%}"
done

# Show all 256 colors with color number
function spectrum_ls() {
  for code in {000..255}; do
    print -P -- "$code: %F{$code}Test%f"
  done
}
