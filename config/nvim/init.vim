" Plugins
call plug#begin('~/.config/nvim/plugged')
 
" Language Support
Plug 'othree/html5.vim'
Plug 'elixir-lang/vim-elixir'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'gregsexton/MatchTag' " HTML tag matching
Plug 'elzr/vim-json' " JSON support
Plug 'tpope/vim-ragtag' " endings for html, xml, etc. - ehances surround
Plug 'ap/vim-css-color', { 'for': ['css','stylus','scss'] } " set the background of hex color values to the color
Plug 'tpope/vim-markdown', { 'for': 'markdown' } " markdown support
Plug 'hail2u/vim-css3-syntax', { 'for': 'css' } " CSS3 syntax support
Plug 'tpope/vim-surround' " mappings to easily delete, change and add such surroundings in pairs, such as quotes, parens, etc.

" UI Stuff
Plug 'powerline/powerline' " statusline base tool
Plug 'tpope/vim-fugitive' " git wrapper for vim
Plug 'vim-airline/vim-airline' " vim statusline
Plug 'vim-airline/vim-airline-themes'

" General
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " fuzzy file finder
Plug 'tmux-plugins/vim-tmux-focus-events' " needed for vim-tmux-clipboard

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set history=1000
set backupcopy=yes
set mouse=a " enable mouse support
syntax on
set encoding=utf8
set number
set relativenumber
set cursorline

" Timeouts
set ttimeout
set ttimeoutlen=0
set notimeout

" faster redrawing
set ttyfast
set lazyredraw


" Styling 
colorscheme smyck 

let g:airline_powerline_fonts = 1
let g:airline_theme = 'luna'
" always display full file path in status line
let g:airline_section_c = '%<%F%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
