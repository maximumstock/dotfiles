" =============================================================================
" # PLUGINS
" =============================================================================
" Load vundle
set nocompatible
call plug#begin()

Plug 'lewis6991/impatient.nvim' " makes Lua faster

Plug 'numToStr/Comment.nvim' " comment toggling -- gc[c]/gb[c]
Plug 'windwp/nvim-autopairs'
Plug 'tpope/vim-surround' " cs[old][new]

" GUI enhancements
Plug 'RRethy/vim-illuminate' " highlight uses of words
" Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'nvim-tree/nvim-tree.lua'
" :NvimTreeToggle Open or close the tree. Takes an optional path argument.
" :NvimTreeFocus Open the tree if it is closed, and then focus on the tree.
" :NvimTreeFindFile Move the cursor in the tree for the current buffer, opening folders if needed.
" :NvimTreeCollapse Collapses the nvim-tree recursively.
Plug 'folke/trouble.nvim'

Plug 'folke/todo-comments.nvim'
Plug 'nvim-lua/plenary.nvim' " dep for todo-comments

Plug 'nvim-telescope/telescope.nvim'


" Plug 'itchyny/lightline.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-fugitive' " git wrapper for vim
Plug 'airblade/vim-gitgutter' " show git diffs in editor

" Fuzzy finder
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'morhetz/gruvbox'

" LSP
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig' " Configurations for Nvim LSP
Plug 'simrat39/rust-tools.nvim'
" Completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" Snippets
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'


call plug#end()

let mapleader = ","

" deal with colors
if !has('gui_running')
  set t_Co=256
endif

" Colors
colorscheme gruvbox
syntax on

let g:gitgutter_max_signs = 500
let g:gitgutter_map_keys = 0
let g:gitgutter_override_sign_column_highlight = 0
hi clear SignColumn
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
" map <C-p> :Files<CR>
nnoremap <C-p> :GFiles<CR>
nmap <C-b> :Buffers<CR>

" Completion
" autocmd BufEnter * call ncm2#enable_for_buffer()
" set completeopt=noinsert,menuone,noselect
" tab to select
" and don't hijack my enter key
" inoremap <expr><Tab> (pumvisible()?(empty(v:completed_item)?"\<C-n>":"\<C-y>"):"\<Tab>")
" inoremap <expr><Tab> "\<C-n>"
" inoremap <expr><CR> (pumvisible()?(empty(v:completed_item)?"\<CR>\<CR>":"\<C-y>"):"\<CR>")

" =============================================================================
" # Editor settings
" =============================================================================
filetype plugin indent on
set guifont=*
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
set relativenumber " Relative line numbers
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

set clipboard=unnamed "sets the default copy register to be *
set clipboard=unnamedplus "sets the default copy register to be +

set iskeyword-=_
set iskeyword-=-

" =============================================================================
" # Autocommands
" =============================================================================

" Leave paste mode when leaving insert mode
autocmd InsertLeave * set nopaste

lua <<EOF

local cmp = require "cmp"

require("mason").setup({
    ui = {
        icons = {
            package_installed = "1",
            package_pending = "2",
            package_uninstalled = "3",
        },
    }
})
-- require("mason-lspconfig").setup({
--     ensure_installed = { "rust_analyzer", "tsserver", "dockerls", "clangd" }
-- })


local rt = require("rust-tools")
rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<Leader>h", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
--
local lsp = require "lspconfig"
--
lsp.clangd.setup({ capabilities = capabilities })
-- lsp.rust_analyzer.setup({ capabilities = capabilities })
lsp.dockerls.setup({ capabilities = capabilities })
lsp.tsserver.setup({ capabilities = capabilities })
lsp.nixd.setup({ capabilities = capabilities })
--
-- lsp.util.default_config.on_attach = function()
--   vim.call('LspAttached')
-- end
-- lsp.clangd.setup(coq.lsp_ensure_capabilities({}))
-- lsp.rust_analyzer.setup(coq.lsp_ensure_capabilities({}))
-- lsp.dockerls.setup(coq.lsp_ensure_capabilities({}))



cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
-- cmp.setup.filetype('gitcommit', {
--     sources = cmp.config.sources({
--       { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
--     }, {
--       { name = 'buffer' },
--     })
-- })

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline({ '/', '?' }, {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = {
--       { name = 'buffer' }
--     }
-- })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = cmp.config.sources({
--       { name = 'path' }
--     }, {
--       { name = 'cmdline' }
--     })
-- })

require('illuminate').configure()
require('impatient')
require('Comment').setup()
-- require("indent_blankline").setup()
require("nvim-autopairs").setup()
require("nvim-tree").setup()
require("trouble").setup()
require("todo-comments").setup()
require('telescope').setup()

-- LSP Diagnostics Options Setup
local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

vim.keymap.set('n', '<leader>f', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>')
vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')

sign({name = 'DiagnosticSignError', text = ''})
sign({name = 'DiagnosticSignWarn', text = ''})
sign({name = 'DiagnosticSignHint', text = ''})
sign({name = 'DiagnosticSignInfo', text = ''})

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})


vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])
EOF

function! LspAttached() abort
  " LSP actions
  nnoremap <buffer> K <cmd>lua vim.lsp.buf.hover()<cr>
  nnoremap <buffer> gd <cmd>lua vim.lsp.buf.definition()<cr>
  nnoremap <buffer> gD <cmd>lua vim.lsp.buf.declaration()<cr>
  nnoremap <buffer> gi <cmd>lua vim.lsp.buf.implementation()<cr>
  nnoremap <buffer> go <cmd>lua vim.lsp.buf.type_definition()<cr>
  nnoremap <buffer> gr <cmd>lua vim.lsp.buf.references()<cr>
  nnoremap <buffer> <C-k> <cmd>lua vim.lsp.buf.signature_help()<cr>
  nnoremap <buffer> <F2> <cmd>lua vim.lsp.buf.rename()<cr>
  nnoremap <buffer> <F4> <cmd>lua vim.lsp.buf.code_action()<cr>
  xnoremap <buffer> <F4> <cmd>lua vim.lsp.buf.range_code_action()<cr>

  " Diagnostics
  nnoremap <buffer> gl <cmd>lua vim.diagnostic.open_float()<cr>
  nnoremap <buffer> [d <cmd>lua vim.diagnostic.goto_prev()<cr>
  nnoremap <buffer> ]d <cmd>lua vim.diagnostic.goto_next()<cr>

endfunction
