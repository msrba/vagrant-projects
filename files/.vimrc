syntax on
set ts=4
set shiftwidth=4
set expandtab                   " Expand tabs to spaces
set formatoptions=ql            " Disable auto comments

set ruler                       " show the line number on the bar
set showcmd                     " Show (partial) command in status line
set autoread                    " watch for file changes
" set number                      " line numbers
set nocompatible                " vim, not vi
" set list                        " show invisible characters
"set autoindent smartindent      " auto/smart indent
set smarttab                    " tab and backspace are smart
set scrolloff=5                 " keep at least 5 lines above/below
set sidescrolloff=5             " keep at least 5 lines left/right
set history=200
set undolevels=1000             " 1000 undos
set complete=.,w,b,u,U,t,i,d    " do lots of scanning on tab completion
set ttyfast                     " we have a fast terminal
set shell=bash
set fileformats=unix
set ff=unix
filetype on                     " Enable filetype detection
filetype indent on              " Enable filetype-specific indenting
filetype plugin on              " Enable filetype-specific plugins
set wildmode=longest:full
set wildmenu                    " menu has tab completion

" Searching
set incsearch                   " incremental search
set smartcase                   " Do smart case matching
set ignorecase                  " search ignoring case
set hlsearch                    " highlight the search
set showmatch                   " show matching bracket
set diffopt=filler,iwhite       " ignore all whitespace and sync

" Backup
set nobackup
"set backupdir=~/.vim_backup
set viminfo=%100,'100,/100,h,\"500,:100,n~/.viminfo
"set viminfo='100,f1

" Spelling
if v:version >= 700
    " Enable spell check for text files
    autocmd BufNewFile,BufRead *.txt setlocal spell spelllang=en
endif

" Turn off annoying error bells
set noerrorbells
set visualbell
set t_vb=