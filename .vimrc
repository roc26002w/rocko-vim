" =================
"  settings
" =================

" theme
set autoread               " auto read when file is changed from outside
syntax on                  " Enable syntax highlighting.
filetype plugin indent on  " Enable file type based indentation.
colorscheme laravel-contrast  " Change a colorscheme.

" indent
set expandtab              " replace <TAB> with spaces
set softtabstop=2          " tab indent size
set shiftwidth=2           " auto indent size
set tabstop=2              " tab character size

" gui setting
set termguicolors
set nomacligatures
set guifont=Fira\ Code\ Retina:h20     " only available for the GUI version
set linespace=3                       " only available for the GUI version
set guioptions-=l                     " remove gui scrollbar
set guioptions-=L
set guioptions-=r
set guioptions-=R

" visual
set number
set numberwidth=4

" ===================
" Vundle Plugin
" ===================
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'daylerees/colour-schemes', { 'rtp': 'vim' }
" colors style
Plugin 'rainglow/vim'
"Base16 shell
Plugin 'chriskempson/base16-vim'
" All of your Plugins must be added before the following line
call vundle#end()            " required
