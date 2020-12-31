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
