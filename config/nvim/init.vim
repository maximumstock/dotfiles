" =============================================================================
" # PLUGINS
" =============================================================================
" Load vundle
set nocompatible
call plug#begin()

" Load plugins

" GUI enhancements
Plug 'itchyny/lightline.vim'
"Plug 'w0rp/ale'
Plug 'machakann/vim-highlightedyank'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-fugitive' " git wrapper for vim
Plug 'airblade/vim-gitgutter' " show git diffs in editor

" Fuzzy finder
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf.vim'

" Semantic language support
"Plug 'ncm2/ncm2'

" Completion plugins
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-tmux'
Plug 'ncm2/ncm2-path'

" Syntactic language support
Plug 'cespare/vim-toml'
Plug 'rust-lang/rust.vim'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'HerringtonDarkholme/yats.vim'

call plug#end()

" deal with colors
if !has('gui_running')
  set t_Co=256
endif
" if (match($TERM, "-256color") != -1) && (match($TERM, "screen-256color") == -1)
"   " screen does not (yet) support truecolor
"   set termguicolors
" endif
" " Colors
set background=dark
colorscheme smyck
hi Normal ctermbg=NONE
" Get syntax
syntax on
hi GitGutterAdd    guifg=#009900 guibg=<X> ctermfg=2
hi GitGutterChange guifg=#bbbb00 guibg=<X> ctermfg=3
hi GitGutterDelete guifg=#ff2222 guibg=<X> ctermfg=1
set updatetime=100

" from http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
if executable('ag')
	set grepprg=ag\ --nogroup\ --nocolor
endif
if executable('rg')
	set grepprg=rg\ --no-heading\ --vimgrep
	set grepformat=%f:%l:%c:%m
endif

" Open hotkeys
map <C-p> :Files<CR>
nmap <C-b> :Buffers<CR>

" Completion
" autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect
" tab to select
" and don't hijack my enter key
inoremap <expr><Tab> (pumvisible()?(empty(v:completed_item)?"\<C-n>":"\<C-y>"):"\<Tab>")
inoremap <expr><CR> (pumvisible()?(empty(v:completed_item)?"\<CR>\<CR>":"\<C-y>"):"\<CR>")

" =============================================================================
" # Editor settings
" =============================================================================
filetype plugin indent on
set autoindent
set timeoutlen=300 " http://stackoverflow.com/questions/2158516/delay-before-o-opens-a-new-line
set encoding=utf-8
set scrolloff=2
set noshowmode
set hidden
set nowrap
set nojoinspaces
let g:sneak#s_next = 1
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_frontmatter = 1
set printfont=:h10
set printencoding=utf-8
set printoptions=paper:letter
" Always draw sign column. Prevent buffer moving when adding/deleting sign.
set signcolumn=yes

" Sane splits
set splitright
set splitbelow
 
" Permanent undo
set undodir=~/.vimdid
set undofile

" Wrapping options
set formatoptions=tc " wrap text and comments using textwidth
set formatoptions+=r " continue comments when pressing ENTER in I mode
set formatoptions+=q " enable formatting of comments with gq
set formatoptions+=n " detect lists for formatting
set formatoptions+=b " auto-wrap in insert mode, and do not wrap old long lines

" Proper search
set incsearch
set ignorecase
set smartcase
set gdefault

" Search results centered please
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" Very magic by default
nnoremap ? ?\v
nnoremap / /\v
cnoremap %s/ %sm/

" =============================================================================
" # GUI settings
" =============================================================================
set guioptions-=T " Remove toolbar
set vb t_vb= " No more beeps
set backspace=2 " Backspace over newlines
set nofoldenable
set ruler " Where am I?
set ttyfast
" https://github.com/vim/vim/issues/1735#issuecomment-383353563
set lazyredraw
set synmaxcol=500
set laststatus=2
" set relativenumber " Relative line numbers
set number " Also show current absolute line
set diffopt+=iwhite " No whitespace in vimdiff
" Make diffing better: https://vimways.org/2018/the-power-of-diff/
set diffopt+=algorithm:patience
set diffopt+=indent-heuristic
"set colorcolumn=80 " and give me a colored column
set showcmd " Show (partial) command in status line.
set mouse=a " Enable mouse usage (all modes) in terminals
set shortmess+=c " don't give |ins-completion-menu| messages.

" Show those damn hidden characters
set listchars=nbsp:¬,eol:¶,extends:»,precedes:«,trail:•
set nolist
set listchars=nbsp:¬,extends:»,precedes:«,trail:•

" =============================================================================
" # Keyboard shortcuts
" =============================================================================

" Ctrl+c and Ctrl+j as Esc
inoremap <C-j> <Esc>
vnoremap <C-j> <Esc>
inoremap <C-c> <Esc>
vnoremap <C-c> <Esc>

set clipboard=unnamed "sets the default copy register to be *
set clipboard=unnamedplus "sets the default copy register to be +

" No arrow keys --- force yourself to use the home row
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

set iskeyword-=_
set iskeyword-=-

" I can type :help on my own, thanks.
map <F1> <Esc>
imap <F1> <Esc>


" =============================================================================
" # Autocommands
" =============================================================================

" Leave paste mode when leaving insert mode
autocmd InsertLeave * set nopaste
