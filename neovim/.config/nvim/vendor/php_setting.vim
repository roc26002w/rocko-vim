" php cs fixe
let g:php_cs_fixer_rules = '@PSR12,no_unused_imports,ordered_imports'
let g:php_cs_fixer_enable_default_mapping = 0

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

" php indent
autocmd FileType php setlocal iskeyword-=$
autocmd FileType php setlocal sw=4 sts=4 ts=4

" php commentstring
autocmd FileType php setlocal commentstring=\/\/\ %s

" phpactor ncm2
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect

" ================== key binding =============================
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
