filetype plugin indent on
set number
set autoindent
set expandtab
set softtabstop=4
set shiftwidth=4
set incsearch
set wrap
set linebreak
set nolist
set formatoptions+=1
set wrap linebreak textwidth=0
set textwidth=0
set hlsearch
set backspace=indent,eol,start

syntax enable
set background=dark
colorscheme solarized

command W w !sudo tee % > /dev/null
