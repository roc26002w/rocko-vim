" ===================
" Plug Manager
" ===================
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
" https://github.com/junegunn/vim-plug
call plug#begin()
" The following are examples of different formats supported.

Plug 'wincent/command-t'
" Pass the path to set the runtimepath properly.
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
" colors style
Plug 'rainglow/vim'
Plug 'chriskempson/base16-vim'
" tab
Plug 'ervandew/supertab'
" snips
Plug 'sirver/ultisnips'
Plug 'honza/vim-snippets'
" folder tree
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/syntastic'
Plug 'Xuyuanp/nerdtree-git-plugin'
" ruby-vim
Plug 'vim-ruby/vim-ruby'
Plug 'thoughtbot/vim-rspec'
" Add the fzf.vim plugin to wrap fzf:
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jiangmiao/auto-pairs'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ervandew/supertab'
Plug 'terryma/vim-multiple-cursors'
Plug 'matze/vim-move'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
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
Plug 'roxma/nvim-yarp'

" PHP
Plug 'StanAngeloff/php.vim'
Plug 'arnaud-lb/vim-php-namespace'
Plug 'phpactor/phpactor', {'for': 'php', 'do': 'composer install'}
Plug 'stephpy/vim-php-cs-fixer'

" Require ncm2 and this plugin from phpactor plugin
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'phpactor/ncm2-phpactor'

" JS
" mark
Plug 'tpope/vim-commentary'

" join '' to word
Plug 'tpope/vim-surround'

" HTML
Plug 'mattn/emmet-vim'
Plug 'othree/html5.vim'
Plug 'alvan/vim-closetag'

" CSS
Plug 'ap/vim-css-color'

" Add deoplete
Plug 'shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugs' }

" Add Icon
Plug 'ryanoasis/vim-devicons'

" Add neocomplete
Plug 'shougo/neocomplete.vim'

" All of your Plugs must be added before the following line
call plug#end()

"  settings
" =================
" language en_US
set tags=tags,tags.vendor

" theme
set autoread               " auto read when file is changed from outside
syntax on                  " Enable syntax highlighting.
filetype plugin indent on  " Enable file type based indentation.
colorscheme base16-onedark " Change a colorscheme.

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

" syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 1
let g:syntastic_aggregate_errors = 1
let g:syntastic_php_checkers = ['php', 'phpcs']
let g:syntastic_php_phpcs_args = '--standard=psr12'
let g:syntastic_javascript_checkers = ['eslint']

" php cs fixer
let g:php_cs_fixer_rules = '@PSR12,no_unused_imports,ordered_imports'
let g:php_cs_fixer_enable_default_mapping = 0

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
let NERDTreeShowHidden = 3
let NERDTreeShowBookmarks = 0
let NERDTreeHighlightCursorline = 0
let NERDTreeIgnore = ['\.git$', '\.DS_Store$']
let g:NERDTreeWinSize = 30
let g:nerdtree_tabs_focus_on_files = 1
let g:nerdtree_tabs_open_on_gui_startup = 0

" NERDTrees File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')
call NERDTreeHighlightFile('ds_store', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('gitconfig', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('gitignore', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('bashrc', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('bashprofile', 'Gray', 'none', '#686868', '#151515')

" NERDTrees File highlighting only the glyph/icon
" test highlight just the glyph (icons) in nerdtree:
autocmd filetype nerdtree highlight haskell_icon ctermbg=none ctermfg=Red guifg=#ffa500
autocmd filetype nerdtree highlight html_icon ctermbg=none ctermfg=Red guifg=#ffa500
autocmd filetype nerdtree highlight go_icon ctermbg=none ctermfg=Red guifg=#ffa500

autocmd filetype nerdtree syn match haskell_icon ## containedin=NERDTreeFile
" if you are using another syn highlight for a given line (e.g.
" NERDTreeHighlightFile) need to give that name in the 'containedin' for this
" other highlight to work with it
autocmd filetype nerdtree syn match html_icon ## containedin=NERDTreeFile,html
autocmd filetype nerdtree syn match go_icon ## containedin=NERDTreeFile

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsSnippetsDir = $HOME."/.config/nvim/UltiSnips"
let g:UltiSnipsSnippetDirectories = ['UltiSnips', $HOME.'/.config/nvim/UltiSnips']
let g:UltiSnipsEnableSnipMate = 0

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" Auto save
" let g:auto_save = 1  " enable AutoSave on Vim startup
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
" command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, '--ignore=*.lock --ignore=.git --hidden', {'options': '--bind ctrl-a:select-all,ctrl-d:deselect-all'})
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--bind ctrl-a:select-all,ctrl-d:deselect-all'})
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

" git
set diffopt+=vertical
noremap <leader>gl :Git log<cr>
noremap <leader>gb :Gblame<cr>
noremap <leader>gs :Gstatus<cr>
noremap <leader>gd :Gdiffsplit!<cr>
noremap gdh :diffget //2<CR>
noremap gdl :diffget //3<CR>

" tig
" nmap <Leader>B :exec '!tig blame % +'.line('.')<CR>
nnoremap <silent> <leader>b :ToggleBlameLine<CR>

" RSpec.vim mappings
map <Leader>rt :call RunCurrentSpecFile()<CR>
map <Leader>rs :call RunNearestSpec()<CR>
map <Leader>rl :call RunLastSpec()<CR>
map <Leader>ra :call RunAllSpecs()<CR>
nmap <Leader>rr :call RunRspecTest()<cr>

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

" Search
 imap <C-f> <Esc> :Ag<space>
 nmap <C-f> :Ag<space>
 vmap <C-f> <Esc> :Ag<space>

" code style mapping
inoremap <A-k> <esc>YpAa<esc>0v$F.hr f.lC

" termguicolors
if (has("termguicolors"))
 set termguicolors
endif

" remove tailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" ctags
function! UpdateTags()
  let tags = 'tags'

  if filereadable(tags)
    let file = substitute(expand('%:p'), getcwd() . '/', '', '')

    " remove tags of file
    call system('sed -ri "/\s+' . escape(file, './') . '/d"' . tags)

    " append tags of file
    call system('ctags -a "' . file . '"')
  endif
endfunction

function! RunRspecTest()
  execute '!bin/bundle exec spring rspec ' . expand('%:p') . ':' . line('.')
endfunction

autocmd BufWritePost *.rb call UpdateTags()
autocmd BufWritePost *.php call UpdateTags()
" autocmd BufEnter * lcd %:p:h
command! Ctags call system('ctags --recurse --exclude=vendor --exclude=node_modules --exclude=public --exclude="*.json" --exclude="*.min.*" && ctags --recurse -f tags.vendor vendor node_modules &')

" phpactor ncm2
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect

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
let g:anyfold_fold_comments=1
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
nmap <Leader>k0 :set foldlevel=100<CR>

" fold_cycle_config
let g:fold_cycle_default_mapping = 0 "disable default mappings
nmap <Tab><Tab> <Plug>(fold-cycle-open)
nmap <S-Tab><S-Tab> <Plug>(fold-cycle-close)

" omni complete
imap <Leader><TAB> <C-X><C-O>

" supertab
let g:SuperTabCrMapping = 1
let g:SuperTabDefaultCompletionType = "<c-n>"

" =================
"  custom
" =================

" coercion
function! CheckCaseType(string)
  " abc abc
  if a:string =~ ' '
    return 0
  endif

  " abc-abc
  if a:string =~ '-'
    return 1
  endif

  " abc.abc
  if a:string =~ '\.'
    return 2
  endif

  " abc_abc
  if a:string =~# '_' && a:string !~# '[A-Z]'
    return 3
  endif

  " ABC_ABC
  if a:string =~# '_' && a:string !~# '[a-z]'
    return 4
  endif

  " abcAbc
  if a:string =~# '^[a-z0-9]\+\([A-Z0-9][a-z0-9]*\)*$'
    return 5
  endif

  " AbcAbc
  if a:string =~# '^\([A-Z0-9][a-z0-9]*\)\+$'
    return 6
  endif

  return -1
endfunction

function! CoerceString()
  normal! gv"zy

  let l:string = @z
  let l:origin_type = CheckCaseType(l:string)
  let l:target_type = (l:origin_type + 1) % 7

  if l:origin_type >= 5
    let l:string = substitute(l:string, '\([a-z0-9]\)\([A-Z0-9]\)\C', '\1 \2', 'g')
  endif

  let l:mapping = [' ', '-', '.', '_', '_', '_', '_']
  let l:words = split(l:string, '[ -._]')
  let l:string = join(l:words, l:mapping[l:target_type])

  if l:target_type == 4
    let l:string = toupper(l:string)
  else
    let l:string = tolower(l:string)
  endif

  if l:target_type >= 5
    let l:string = substitute(l:string, '_\([A-Za-z0-9]\)', '\U\1', 'g')
  endif

  if l:target_type == 6
    let l:string = substitute(l:string, '^[A-Za-z]', '\U\0', '')
  end

  let @z = l:string

  normal! gv"zpgv
endfunction

" Change String Case
nnoremap <C-u> viw:call CoerceString()<CR>
vnoremap <C-u> :call CoerceString()<CR>

" Fix Cursor in TMUX
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
