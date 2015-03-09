inoremap jk <ESC>
let mapleader = ","

execute pathogen#infect()

filetype plugin indent on
syntax on
set background=dark
set encoding=utf-8
set tabstop=4
set shiftwidth=4

" make "tab" insert indents instead of tabs at the beginning of a line
set smarttab
" always uses spaces instead of tab characters
set expandtab
