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


autocmd BufWritePost *.rb call UpdateTags()
autocmd BufWritePost *.php call UpdateTags()

" autocmd BufEnter * lcd %:p:h
command! Ctags call system('ctags --recurse --exclude=vendor --exclude=node_modules --exclude=public --exclude="*.json" --exclude="*.min.*" && ctags --recurse -f tags.vendor vendor node_modules &')

