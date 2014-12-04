"{{{Auto Commands
"Automactially cd into the directory that the file is in
autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

"Remove any trailing whitespace
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

"Restore cursor to where it was before
augroup JumpCursorOnEdit
   au!
   autocmd BufReadPost *
            \ if expand("<afile>:p:h") !=? $TEMP |
            \   if line("'\"") > 1 && line("'\"") <= line("$") |
            \     let JumpCursorOnEdit_foo = line("'\"") |
            \     let b:doopenfold = 1 |
            \     if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
            \        let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
            \        let b:doopenfold = 2 |
            \     endif |
            \     exe JumpCursorOnEdit_foo |
            \   endif |
            \ endif
" Need to postpone using "zv" until after reading the modelines.
   autocmd BufWinEnter *
            \ if exists("b:doopenfold") |
            \   exe "normal zv" |
            \   if(b:doopenfold > 1) |
            \       exe  "+".1 |
            \   endif |
            \   unlet b:doopenfold |
            \ endif
augroup END
"}}}

"{{{Misc Settings
set nocompatible
set showcmd
set foldmethod=marker

filetype on
filetype plugin on
filetype plugin indent on

set autoindent
set expandtab
set smarttab

set shiftwidth=4
set softtabstop=4

if version >= 700
    set spl=en spell
    set nospell
endif

set wrap
set linebreak
set nolist
set formatoptions+=1
set textwidth=0
set backspace=indent,eol,start

set mouse=a
set number
set ignorecase
set smartcase
set incsearch
set hlsearch
set nohidden
highlight MatchParen ctermbg=4

set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp

"}}}

"{{{Look and Feel

syntax enable
set background=dark
set grepprg=grep\ -nH\ $*
colorscheme solarized

set laststatus=2
set statusline=%F%m%r%h%w\ (%{&ff}){%Y}\ [%l,%v][%p%%]

"}}}

command W w !sudo tee % > /dev/null
