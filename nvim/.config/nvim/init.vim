" enables syntax highlighting
syntax on
" case insensitive search unless capital letters are used
set ignorecase
set smartcase

let mapleader = ' '

if exists('g:vscode')
  " VSCode extension
  call plug#begin('~/.config/nvim/plugged')
  Plug 'asvetliakov/vim-easymotion', { 'as': 'vsc-easymotion' }
  call plug#end()
else
  " ordinary neovim
  set title

  set rtp+=/usr/local/opt/fzf

  " Better colors
  set termguicolors

  " number of spaces in a <Tab>
  set tabstop=2
  set softtabstop=2

  set expandtab

  " enable autoindents
  set smartindent

  " number of spaces used for autoindents
  set shiftwidth=2

  " adds line numbers
  set number

  " columns used for the line number
  set numberwidth=3

  " highlights the matched text pattern when searching
  set incsearch
  " set nohlsearch

  " open splits intuitively
  set splitbelow
  set splitright

  " navigate buffers without losing unsaved work
  set hidden

  " start scrolling when 8 lines from top or bottom
  set scrolloff=8

  " Save undo history
  set undofile

  " Enable mouse support
  set mouse=a

  " no bottom show mode since using lightline
  set noshowmode

  call plug#begin('~/.config/nvim/plugged')
  " plugins will go here
  Plug 'nvim-lua/plenary.nvim'
  " The main Telescope plugin
  Plug 'nvim-telescope/telescope.nvim'
  " An optional plugin recommended by Telescope docs
  Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do': 'make' }
  " Lightline
  Plug 'itchyny/lightline.vim'
  " vim-fugitive
  Plug 'tpope/vim-fugitive'

  Plug 'lewis6991/gitsigns.nvim'

  Plug 'dracula/vim', { 'as': 'dracula' }

  Plug 'easymotion/vim-easymotion'
  " LSP
  Plug 'neovim/nvim-lspconfig'
  " For jump to source definition
  Plug 'jose-elias-alvarez/typescript.nvim'
  " Autocompletion
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'L3MON4D3/LuaSnip'
  Plug 'saadparwaiz1/cmp_luasnip'
  Plug 'onsails/lspkind-nvim'
  " Treesitter
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'nvim-lua/plenary.nvim'
  " chat gpt
  Plug 'MunifTanjim/nui.nvim'
  Plug 'dpayne/CodeGPT.nvim'
  call plug#end()

  noremap dfs <cmd>diffthis
  noremap <leader>g <cmd>Git
  noremap <leader>p <cmd>:Telescope find_files<CR>
  noremap <leader>f <cmd>Telescope live_grep<CR>
  noremap <leader>b <cmd>Telescope buffers<CR>
  noremap <leader>nh <cmd>noh<CR>
  tnoremap <ESC> <C-\><C-n>

  lua require('kc_neo')
  " declare your color scheme
  " colorscheme gruvbox
  " Use this for dark color schemes
  " set background=dark
  colorscheme dracula
  " Set color for search highlight
  highlight Search guibg=#FFFFF0 guifg=NONE

  set signcolumn=number
endif

