set nocompatible " use vim settings instead of vi settings

" Get our vim directory. 
let s:vim_home = expand("<sfile>:h")

" Plugins
call plug#begin('~/.config/nvim/plugged')
 
Plug 'ludovicchabant/vim-gutentags'
  let g:gutentags_cache_dir = s:vim_home.'/tags'
  let g:gutentags_ctags_exclude = ['venv', 'build', 'static', 'node_modules']

" Auto-Completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  let g:deoplete#enable_at_startup = 1
  " use tab for completion
  inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

Plug 'neomake/neomake'
  " Run Neomake when I save any buffer
  autocmd! BufWritePost * Neomake
  let g:neomake_elixir_enabled_makers = ['credo']

" Language Support
Plug 'sheerun/vim-polyglot'

" Elixir
Plug 'elixir-lang/vim-elixir'
Plug 'slashmili/alchemist.vim'

Plug 'c-brenn/phoenix.vim'
Plug 'tpope/vim-projectionist'

" Language Support
Plug 'othree/html5.vim'
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
Plug 'airblade/vim-gitgutter' " show git diffs in editor
Plug 'powerman/vim-plugin-AnsiEsc'

" General
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " fuzzy file finder

" Color Schemes
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
colorscheme smyck
set tabstop=2 " tab size in spaces
set softtabstop=2
set shiftwidth=2 " indentation size in spaces 
set expandtab " expand tabs to spaces
set smarttab " only insert as many spaces as necessary to get to the next tab width
set backupcopy=yes
syntax on
set mouse=a
set cursorline
set encoding=utf8
set number
set incsearch " search as you type
set ignorecase smartcase " ignore case when searching
set title


if has('mac')
  set clipboard=unnamed
else
  set clipboard=unnamedplus
end

" Timeouts
set ttimeout
set ttimeoutlen=0
set notimeout
 
" faster redrawing
set ttyfast
set lazyredraw
 
let g:airline_powerline_fonts = 1
let g:airline_theme = 'luna'
" always display full file path in status line
let g:airline_section_c = '%<%F%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
