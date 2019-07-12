" ===================
" Vundle Plugin
" ===================
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=/usr/local/opt/fzf
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
" colors style
Plugin 'rainglow/vim'
" snips
Plugin 'sirver/ultisnips'
Plugin 'honza/vim-snippets'
" folder tree
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
" ruby-vim
Plugin 'vim-ruby/vim-ruby'
Plugin 'thoughtbot/vim-rspec'
" Add the fzf.vim plugin to wrap fzf:
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

" Add deoplete
 Plugin 'shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Add neocomplete
" Plugin 'shougo/neocomplete.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
"  settings
" =================

" theme
set autoread               " auto read when file is changed from outside
syntax on                  " Enable syntax highlighting.
filetype plugin indent on  " Enable file type based indentation.
colorscheme base16-onedark " Change a colorscheme.

" indent
set expandtab              " replace <TAB> with spaces
set softtabstop=2          " tab indent size
set shiftwidth=2           " auto indent size
set tabstop=2              " tab character size
set noswapfile

" gui setting
set termguicolors
set guifont=Fira\ Code\ Retina:h20     " only available for the GUI version
set linespace=3                       " only available for the GUI version
set guioptions-=l                     " remove gui scrollbar
set guioptions-=L
set guioptions-=r
set guioptions-=R

set nocompatible      " We're running Vim, not Vi!
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins

" visual
set number
set rnu
set numberwidth=4

" =================
"  plugin settings
" =================

" 256 colorspace
let base16colorspace=256  " Access colors present in 256 colorspace

" NERDTree
let NERDTreeQuitOnOpen = 1
let NERDTreeChDirMode = 2
let NERDTreeMouseMode = 2
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeShowHidden = 1
let NERDTreeShowBookmarks = 0
let NERDTreeHighlightCursorline = 0
let NERDTreeIgnore = ['\.git$', '\.DS_Store$']
let g:NERDTreeWinSize = 30
let g:nerdtree_tabs_focus_on_files = 1
let g:nerdtree_tabs_open_on_gui_startup = 0

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
let g:UltiSnipsSnippetsDir = $HOME."/.config/nvim/UltiSnips"
let g:UltiSnipsSnippetDirectories = ['UltiSnips', $HOME.'/.config/nvim/UltiSnips']
let g:UltiSnipsEnableSnipMate = 0

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" Auto save 
let g:auto_save = 1  " enable AutoSave on Vim startup
" let g:auto_save_silent = 1  " do not display the auto-save notification

" deoplete
let g:deoplete#enable_at_startup = 1

"normal mode map
"NERDTree
map <Leader>1 <ESC>:NERDTreeToggle<CR>

" fzf
command! -bang -nargs=* Commits call fzf#vim#commits({'options': '--no-reverse'})
command! -bang -nargs=* BTags call fzf#vim#buffer_tags('', {'options': '--no-reverse'})
command! -bang -nargs=* BCommits call fzf#vim#buffer_commits({'options': '--no-reverse'})
" Ag need install the_silver_searcher https://github.com/ggreer/the_silver_searcher
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, '--ignore=*.lock --ignore=.git --hidden', {'options': '--bind ctrl-a:select-all,ctrl-d:deselect-all'})
command! -bang -nargs=* Ah call fzf#vim#history({'options': '--no-sort'})
let g:fzf_colors={
  \ 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment']
  \ }

nmap <C-o> :Files<CR>
nmap <Leader>t :Tags<CR>
nmap <Leader>r :BTags<CR>
nmap <C-e> :Buffers<CR>
imap <C-X><C-K> <Plug>(fzf-complete-word)
imap <C-X><C-F> <Plug>(fzf-complete-path)
imap <C-X><C-J> <Plug>(fzf-complete-file-ag)
imap <C-X><C-L> <Plug>(fzf-complete-line)
imap <Tab> <C-n>

" RSpec.vim mappings
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

" Move line
nmap <C-j> :m .+1<CR>==
nmap <C-k> :m .-2<CR>==
imap <C-j> <Esc>:m .+1<CR>==gi
imap <C-k> <Esc>:m .-2<CR>==gi
vmap <C-j> :m '>+1<CR>gv=gv
vmap <C-k> :m '<-2<CR>gv=gv

" Copy
" xnoremap <c-c> "*y

" Search
 nmap <C-f> :Ag 
 imap <C-f> <Esc> :Ag
 vmap <C-f> <Esc> :Ag
" code style mapping
inoremap <A-k> <esc>YpAa<esc>0v$F.hr f.lC

" termguicolors
if (has("termguicolors"))
 set termguicolors
endif
