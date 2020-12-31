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
 Plug 'StanAngeloff/php.vim'
 Plug 'arnaud-lb/vim-php-namespace'
 Plug 'stephpy/vim-php-cs-fixer'
 Plug 'phpactor/phpactor', {'for': 'php', 'do': 'composer install --no-dev -o'}

 " Require ncm2 and this plugin from phpactor plugin
 Plug 'ncm2/ncm2'
 Plug 'phpactor/ncm2-phpactor'

 " Phpactor integration for deoplete.nvim
 Plug 'kristijanhusak/deoplete-phpactor'

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

 " deoplete
 " Plug 'shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugs' }

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

" php cs fixe
let g:php_cs_fixer_rules = '@PSR12,no_unused_imports,ordered_imports'
let g:php_cs_fixer_enable_default_mapping = 0

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

" php.vim setting
function! PhpSyntaxOverride()
  " Put snippet overrides in this function.
  hi! link phpDocTags phpDefine
  hi! link phpDocParam phpType
  hi phpUseNamespaceSeparator guifg=#808080 guibg=NONE gui=NONE
  hi phpClassNamespaceSeparator guifg=#808080 guibg=NONE gui=NONE
  syn match phpParentOnly "[()]" contained containedin=phpParent
  hi phpParentOnly guifg=#f08080 guibg=NONE gui=NONE
endfunction

augroup phpSyntaxOverride
  autocmd!
  autocmd FileType php call PhpSyntaxOverride()
augroup END

" php-vim-namespace setting
function! NPhpactorInsertUse()
  call phpactor#UseAdd()
endfunction

function! IPhpactorInsertUse()
  call NPhpactorInsertUse()
  call feedkeys('a', 'n')
endfunction

function! NPhpactorExpandClass()
  call phpactor#ClassExpand()
endfunction

function! IPhpactorExpandClass()
  call NPhpactorExpandClass()
  call feedkeys('a', 'n')
endfunction

function! PhpactorGotoDefinition()
  if !exists('s:phpactor_trace_stack')
    let s:phpactor_trace_stack = []
  endif

  call add(s:phpactor_trace_stack, [expand('%:p'), line('.'), col('.')])
  call phpactor#GotoDefinition()
endfunction

function! PhpactorTraceBack()
  if !exists('s:phpactor_trace_stack') || empty(s:phpactor_trace_stack)
    return
  endif

  let l:position = remove(s:phpactor_trace_stack, -1)

  silent execute 'e ' . l:position[0]
  call cursor(l:position[1], l:position[2])
endfunction

autocmd FileType php command! ClassNew call phpactor#ClassNew()
autocmd FileType php command! Transform call phpactor#Transform()
autocmd FileType php command! References call phpactor#FindReferences()
autocmd FileType php nmap <C-]> :call PhpactorGotoDefinition()<CR>
autocmd FileType php nmap <C-t> :call PhpactorTraceBack()<CR>
autocmd FileType php nmap <Leader>l :call phpactor#ClassNew()<CR>
autocmd FileType php nmap <Leader>m :call phpactor#ContextMenu()<CR>
autocmd FileType php nmap <Leader>a :call phpactor#Navigate()<CR>
autocmd FileType php nmap <Leader>i :call NPhpactorInsertUse()<CR>
autocmd FileType php imap <Leader>i <ESC>:call IPhpactorInsertUse()<CR>
autocmd FileType php nmap <Leader>e :call NPhpactorExpandClass()<CR>
autocmd FileType php imap <Leader>e <ESC>:call IPhpactorExpandClass()<CR>
autocmd FileType php nmap <silent><Leader>v :call phpactor#ChangeVisibility()<CR>
autocmd FileType php nmap <silent><Leader>x :call phpactor#ExtractExpression(v:false)<CR>
autocmd FileType php vmap <silent><Leader>x :<C-U>call phpactor#ExtractExpression(v:true)<CR>
autocmd FileType php vmap <silent><Leader>m :<C-U>call phpactor#ExtractMethod()<CR>

" PHPUnit test map key
autocmd FileType php nnoremap <leader>ru :call RunPHPUnitTest(0)<cr>
autocmd FileType php nnoremap <leader>ruu :call RunPHPUnitTest(1)<cr>
autocmd FileType php nnoremap <leader>uu :call RunAllPHPUnitTest()<cr>
autocmd FileType php nnoremap <leader>rt :call RunMakeTest()<cr>
autocmd FileType php nnoremap <leader>rcs :call RunPHPCSCheck()<cr>
autocmd FileType php nnoremap <leader>rfs :call RunPHPCSFixer()<cr>
autocmd FileType php nnoremap <leader>jq :call RunJsonFormat()<cr>

" php indent
autocmd FileType php setlocal iskeyword-=$
autocmd FileType php setlocal sw=4 sts=4 ts=4

" php commentstring
autocmd FileType php setlocal commentstring=\/\/\ %s

" php unit test
function! RunPHPUnitTest(filter)
  if a:filter
    normal! T yw
    execute "!./vendor/bin/phpunit --filter " . @" . " " . bufname("%")
  else
    execute "!./vendor/bin/phpunit " . bufname("%")
  endif
endfunction

function! RunAllPHPUnitTest()
  execute "!./vendor/bin/phpunit --stop-on-failure"
endfunction

function! RunPHPCSCheck()
  execute "!./vendor/bin/phpcs --standard=PSR12 --exclude=PSR12.Properties.ConstantVisibility app tests"
endfunction

function! RunMakeTest()
  execute "!make test"
endfunction

function! RunPHPCSFixer()
  execute "!./vendor/bin/php-cs-fixer fix --verbose"
endfunction

function! RunJsonFormat()
  execute "!jq '.'"
endfunction

"==================
"  anyfold
"==================
autocmd Filetype * AnyFoldActivate
let g:anyfold_fold_comments=0
set foldlevel=100

hi Folded term=underline ctermbg=none
nmap <Leader>k1 :set foldlevel=1<CR>
nmap <Leader>k2 :set foldlevel=2<CR>
nmap <Leader>k3 :set foldlevel=3<CR>
nmap <Leader>k4 :set foldlevel=4<CR>
nmap <Leader>k5 :set foldlevel=5<CR>
nmap <Leader>k6 :set foldlevel=6<CR>
nmap <Leader>k7 :set foldlevel=7<CR>
nmap <Leader>k8 :set foldlevel=8<CR>
nmap <Leader>k9 :set foldlevel=9<CR>
nmap <Leader>k0 :set foldlevel=0<CR>

" fold_cycle_config
let g:fold_cycle_default_mapping = 0 "disable default mappings
nmap <Tab><Tab> <Plug>(fold-cycle-open)
nmap <S-Tab><S-Tab> <Plug>(fold-cycle-close)

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

