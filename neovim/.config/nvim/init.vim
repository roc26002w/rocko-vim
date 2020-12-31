" ===================
" Plug Manager
" ===================
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
" https://github.com/junegunn/vim-plug
call plug#begin()
" The following are examples of different formats supported.
set rtp+=~/.fzf

" 檔案搜尋
 Plug 'wincent/command-t'

 " colors style
 Plug 'chriskempson/base16-vim'

 " tab
 Plug 'ervandew/supertab'

 " snips
 Plug 'sirver/ultisnips'
 Plug 'honza/vim-snippets'

 " syntastic
 Plug 'scrooloose/syntastic'

 " folder tree
 Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
 Plug 'scrooloose/nerdcommenter', { 'on':  'NERDTreeToggle' }
 Plug 'Xuyuanp/nerdtree-git-plugin', { 'on':  'NERDTreeToggle' }
 Plug 'tiagofumo/vim-nerdtree-syntax-highlight', { 'on':  'NERDTreeToggle' }

 " ruby-vim
 Plug 'vim-ruby/vim-ruby', { 'for' : 'ru' }
 Plug 'thoughtbot/vim-rspec', { 'for' : 'ru' }

 " Add the fzf.vim plugin to wrap fzf:
 Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
 Plug 'junegunn/fzf.vim'
 Plug 'ctrlpvim/ctrlp.vim'

 " Tagbar
 Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle', 'for' : ['php', 'rb', 'java'] }

 Plug 'vim-airline/vim-airline'
 Plug 'vim-airline/vim-airline-themes'

 " auto gen
 Plug 'jiangmiao/auto-pairs'

 " quick block edit
 Plug 'terryma/vim-multiple-cursors'
 Plug 'matze/vim-move'

 " language server
 Plug 'neoclide/coc.nvim', {'branch': 'release'}

 " Themes
 Plug 'arcticicestudio/nord-vim'

 " Flod
 Plug 'pseewald/vim-anyfold'
 Plug 'michaeljsmith/vim-indent-object'

 " Git
 Plug 'airblade/vim-gitgutter'
 Plug 'tpope/vim-fugitive'
 Plug 'tveskag/nvim-blame-line'

 " Python
 Plug 'roxma/nvim-yarp', { 'for': 'py'}

 " PHP
 Plug 'StanAngeloff/php.vim', {'for': 'php'}
 Plug 'arnaud-lb/vim-php-namespace', {'for': 'php'}
 Plug 'stephpy/vim-php-cs-fixer', {'for': 'php'}
 Plug 'phpactor/phpactor', {'for': 'php', 'do': 'composer install --no-dev -o'}

 " Require ncm2 and this plugin from phpactor plugin
 Plug 'ncm2/ncm2', {'for': 'php'}
 Plug 'phpactor/ncm2-phpactor', {'for': 'php'}

 " deoplete
 " Plug 'shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugs' }
 " Phpactor integration for deoplete.nvim
 " Plug 'kristijanhusak/deoplete-phpactor', {'for': 'php'}

 " JS
 " mark
 Plug 'tpope/vim-commentary'

 " join '' to word
 Plug 'tpope/vim-surround'

 " html
 Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
 Plug 'mattn/emmet-vim'
 Plug 'othree/html5.vim'
 Plug 'alvan/vim-closetag'

 " css
 Plug 'ap/vim-css-color'

 " icon
 Plug 'ryanoasis/vim-devicons'

 " neocomplete
 Plug 'shougo/neocomplete.vim'

 " error word highlight
 Plug 'kamykn/spelunker.vim'

 " All of your Plugs must be added before the following line
call plug#end()

"  settings
" =================
" language en_US
set tags=tags,tags.vendor

" theme
set autoread               " auto read when file is changed from outside
syntax on                  " Enable syntax highlighting.
colorscheme base16-onedark " Change a colorscheme.

" 256 colorspace
let base16colorspace=256  " Access colors present in 256 colorspace

" indent
set autoindent
set copyindent
set smarttab
set expandtab              " replace <TAB> with spaces
set softtabstop=2          " tab indent size
set shiftwidth=2           " auto indent size
set tabstop=2              " tab character size
set noswapfile
set clipboard+=unnamedplus " enable clipboard
set mmp=5000


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

" python3_host

let g:python3_host_prog = $HOME.'/.env/python/bin/python3'
" let g:ruby_host_prog = '/home/ubuntu/.rbenv/versions/2.7.1'

" syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 1
let g:syntastic_aggregate_errors = 1
let g:syntastic_php_checkers = ['php', 'phpcs']
let g:syntastic_php_phpcs_args = '--standard=psr12'
let g:syntastic_javascript_checkers = ['eslint']
noremap <leader>n :ll<cr>


" =================
"  plugin settings
" =================

" NERDTree
source $HOME/.config/nvim/vendor/nerdtree_setting.vim
" UltiSnips
source $HOME/.config/nvim/vendor/ulti_snips_setting.vim
" fzf
source $HOME/.config/nvim/vendor/fzf_setting.vim
" ctag
source $HOME/.config/nvim/vendor/ctag_setting.vim
" spelunker
source $HOME/.config/nvim/vendor/spelunker_setting.vim
" anyfold
source $HOME/.config/nvim/vendor/anyfold_setting.vim
" string case
source $HOME/.config/nvim/vendor/php_setting.vim
" string case
source $HOME/.config/nvim/vendor/string_case_setting.vim

" Auto save
" let g:auto_save = 1  " enable AutoSave on Vim startup
" let g:auto_save_silent = 1  " do not display the auto-save notification

" deoplete
let g:deoplete#enable_at_startup = 1

" Tagbar
map <Leader>2 <ESC>:TagbarToggle<CR>

nmap <Leader>t :Tags<CR>
nmap <Leader>r :BTags<CR>
" map <Tab> <C-n>

" git
set diffopt+=vertical
noremap <leader>gl :Git log<cr>
noremap <leader>gb :Gblame<cr>
noremap <leader>gs :Gstatus<cr>
noremap <leader>gd :Gdiffsplit!<cr>
noremap gdh :diffget //2<CR>
noremap gdl :diffget //3<CR>

" BlameLine config
nnoremap <silent> <leader>b :ToggleBlameLine<CR>
" Show blame info below the statusline instead of using virtual text
let g:blameLineUseVirtualText = 1

" Specify the highlight group used for the virtual text ('Comment' by default)
let g:blameLineVirtualTextHighlight = 'Question'

" Add a prefix to the virtual text (empty by default)
let g:blameLineVirtualTextPrefix = '// '

" Customize format for git blame (Default format: '%an | %ar | %s')
let g:blameLineGitFormat = '%an - %s'
" Refer to 'git-show --format=' man pages for format options)

" ===================

" vim-rspec mappings
autocmd FileType rb map <Leader>rt :call RunCurrentSpecFile()<CR>
autocmd FileType rb map <Leader>rs :call RunNearestSpec()<CR>
autocmd FileType rb map <Leader>rl :call RunLastSpec()<CR>
autocmd FileType rb map <Leader>ra :call RunAllSpecs()<CR>
autocmd FileType rb nmap <Leader>rr :call RunRspecTest()<cr>

function! RunRspecTest()
  execute '!bin/bundle exec spring rspec ' . expand('%:p') . ':' . line('.')
endfunction

" Move line
nmap <C-j> :m .+1<CR>==
nmap <C-k> :m .-2<CR>==
imap <C-j> <Esc>:m .+1<CR>==gi
imap <C-k> <Esc>:m .-2<CR>==gi
vmap <C-j> :m '>+1<CR>gv=gv
vmap <C-k> :m '<-2<CR>gv=gv

" Copy
" xnoremap <c-c> "*y

" cancel search
nmap <Leader><space> :nohlsearch<cr>

" code style mapping
inoremap <A-k> <esc>YpAa<esc>0v$F.hr f.lC

" termguicolors
if (has("termguicolors"))
 set termguicolors
endif


" phpactor ncm2
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect

" coc setting
" autocmd FileType * :call coc#config("suggest.autoTrigger", "aways")

" omni complete
imap <Leader><TAB> <C-X><C-O>

" supertab
let g:SuperTabCrMapping = 1
let g:SuperTabDefaultCompletionType = "<c-n>"

" Fix Cursor in TMUX
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" style
hi Pmenu ctermfg=254 ctermbg=237 cterm=NONE guifg=#e1e1e1 guibg=#383838 gui=NONE
hi PmenuSel ctermfg=135 ctermbg=239 cterm=NONE guifg=#b26eff guibg=#4e4e4e gui=NONE
