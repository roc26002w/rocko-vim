"########################################
"########################################
" Kiwi (rainglow)
"
" https://github.com/rainglow/vim
"
" Copyright (c) Dayle Rees.
"########################################
"########################################


"########################################
"# Settings.                            #
"########################################

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "kiwi"

"########################################
"# Base Colors.                         #
"########################################

hi Cursor         guifg=#2a3330 guibg=#f8f8f0 gui=NONE
hi Visual         guifg=#ffffff guibg=#0b6d5c gui=NONE
hi CursorLine     guifg=NONE guibg=#313b38 gui=NONE
hi CursorLineNr   guifg=#6f877f guibg=#1a1f1e gui=NONE
hi CursorColumn   guifg=NONE guibg=#1a1f1e gui=NONE
hi ColorColumn    guifg=NONE guibg=#131716 gui=NONE
hi LineNr         guifg=#414f4a guibg=#1e2523 gui=NONE
hi VertSplit      guifg=#414f4a guibg=#414f4a gui=NONE
hi MatchParen     guifg=#95c72a guibg=NONE gui=underline
hi StatusLine     guifg=#edebe6 guibg=#1e2523 gui=bold
hi StatusLineNC   guifg=#edebe6 guibg=#1e2523 gui=NONE
hi Pmenu          guifg=#edebe6 guibg=#1e2523 gui=NONE
hi PmenuSel       guifg=NONE guibg=#229986 gui=NONE
hi IncSearch      guifg=#edebe6 guibg=#a1e6c1 gui=NONE
hi Search         guifg=NONE guibg=NONE gui=underline
hi Directory      guifg=#229986 guibg=NONE gui=NONE
hi Folded         guifg=#e2dfd7 guibg=#131716 gui=NONE
hi Normal         guifg=#0b6d5c guibg=#2a3330 gui=NONE
hi Boolean        guifg=#0b6d5c guibg=NONE gui=NONE
hi Character      guifg=#a1e6c1 guibg=NONE gui=NONE
hi Comment        guifg=#576d6a guibg=NONE gui=NONE
hi Conditional    guifg=#229986 guibg=NONE gui=NONE
hi Constant       guifg=NONE guibg=NONE gui=NONE
hi Define         guifg=#229986 guibg=NONE gui=NONE
hi DiffAdd        guifg=#4d5d57 guibg=#a7da1e gui=bold
hi DiffDelete     guifg=#4d5d57 guibg=#e61f44 gui=NONE
hi DiffChange     guifg=#4d5d57 guibg=#f7b83d gui=NONE
hi DiffText       guifg=#4d5d57 guibg=#f7b83d gui=bold
hi ErrorMsg       guifg=#4d5d57 guibg=#e61f44 gui=NONE
hi WarningMsg     guifg=#4d5d57 guibg=#f7b83d gui=NONE
hi Float          guifg=#a1e6c1 guibg=NONE gui=NONE
hi Function       guifg=#229986 guibg=NONE gui=NONE
hi Identifier     guifg=#edebe6 guibg=NONE gui=NONE
hi Keyword        guifg=#229986 guibg=NONE gui=NONE
hi Label          guifg=#a1e6c1 guibg=NONE gui=NONE
hi NonText        guifg=#988c6f guibg=#252d2b gui=NONE
hi Number         guifg=#a1e6c1 guibg=NONE gui=NONE
hi Operator       guifg=#edebe6 guibg=NONE gui=NONE
hi PreProc        guifg=#7b9692 guibg=NONE gui=NONE
hi Special        guifg=#edebe6 guibg=NONE gui=NONE
hi SpecialKey     guifg=#edebe6 guibg=#229986 gui=NONE
hi Statement      guifg=#229986 guibg=NONE gui=NONE
hi StorageClass   guifg=#95c72a guibg=NONE gui=NONE
hi String         guifg=#a1e6c1 guibg=NONE gui=NONE
hi Tag            guifg=#229986 guibg=NONE gui=NONE
hi Title          guifg=#229986 guibg=NONE gui=bold
hi Todo           guifg=#7b9692 guibg=NONE gui=inverse,bold
hi Type           guifg=NONE guibg=NONE gui=NONE
hi Underlined     guifg=NONE guibg=NONE gui=underline

"########################################
"# Language Overrides                   #
"########################################

hi phpIdentifier     guifg=#edebe6
hi phpMethodsVar     guifg=#dee4e2
hi xmlTag            guifg=#229986 guibg=NONE gui=NONE
hi xmlTagName        guifg=#229986 guibg=NONE gui=NONE
hi xmlEndTag         guifg=#229986 guibg=NONE gui=NONE

"########################################
"# Light Theme Overrides                #
"########################################

