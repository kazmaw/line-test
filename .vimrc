set encoding=utf-8
set nobackup
set noswapfile
set autoread
set showcmd

set number
set tabstop=2
set shiftwidth=2
set expandtab
set smartindent
set visualbell
set showmatch
set laststatus=2
set wildmode=list:longest
set ruler
set showmode
set title

let mapleader = "\<Space>"
map <Leader>i gg=<S-g><C-o><C-o>zz
inoremap <silent> jj <esc>
nnoremap <Leader>w :w<CR>

set clipboard=unnamed,autoselect
