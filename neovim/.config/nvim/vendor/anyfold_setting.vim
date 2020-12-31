"==================
"  anyfold
"==================
autocmd Filetype * AnyFoldActivate
set foldlevel=100
hi Folded term=underline ctermbg=none

" fold_cycle_config
let g:anyfold_fold_comments=0
let g:fold_cycle_default_mapping = 0 "disable default mappings

" ======== key binding =======================
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

nmap <Tab><Tab> <Plug>(fold-cycle-open)
nmap <S-Tab><S-Tab> <Plug>(fold-cycle-close)
