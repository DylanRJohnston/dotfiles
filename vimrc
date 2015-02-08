autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

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
   autocmd BufWinEnter *
            \ if exists("b:doopenfold") |
            \   exe "normal zv" |
            \   if(b:doopenfold > 1) |
            \       exe  "+".1 |
            \   endif |
            \   unlet b:doopenfold |
            \ endif
augroup END


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

syntax enable
set background=dark
set grepprg=grep\ -nH\ $*
colorscheme solarized

set laststatus=2
set statusline=%F%m%r%h%w\ (%{&ff}){%Y}\ [%l,%v][%p%%]
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

command W w !sudo tee % > /dev/null

