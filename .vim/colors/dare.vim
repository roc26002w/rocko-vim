"########################################
"########################################
" Dare (rainglow)
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

let g:colors_name = "dare"

"########################################
"# Base Colors.                         #
"########################################

hi Cursor         guifg=#32373d guibg=#ffffff gui=NONE
hi Visual         guifg=#ffffff guibg=#5da892 gui=NONE
hi CursorLine     guifg=NONE guibg=#393f45 gui=NONE
hi CursorLineNr   guifg=#788390 guibg=#222529 gui=NONE
hi CursorColumn   guifg=NONE guibg=#222529 gui=NONE
hi ColorColumn    guifg=NONE guibg=#1b1e21 gui=NONE
hi LineNr         guifg=#495059 guibg=#272a2f gui=NONE
hi VertSplit      guifg=#495059 guibg=#495059 gui=NONE
hi MatchParen     guifg=#d15736 guibg=NONE gui=underline
hi StatusLine     guifg=#c0ccdb guibg=#272a2f gui=bold
hi StatusLineNC   guifg=#c0ccdb guibg=#272a2f gui=NONE
hi Pmenu          guifg=#c0ccdb guibg=#272a2f gui=NONE
hi PmenuSel       guifg=NONE guibg=#3a8881 gui=NONE
hi IncSearch      guifg=#c0ccdb guibg=#a5bab3 gui=NONE
hi Search         guifg=NONE guibg=NONE gui=underline
hi Directory      guifg=#3a8881 guibg=NONE gui=NONE
hi Folded         guifg=#b0bfd2 guibg=#1b1e21 gui=NONE
hi Normal         guifg=#ffffff guibg=#32373d gui=NONE
hi Boolean        guifg=#ffffff guibg=NONE gui=NONE
hi Character      guifg=#a5bab3 guibg=NONE gui=NONE
hi Comment        guifg=#76818e guibg=NONE gui=NONE
hi Conditional    guifg=#3a8881 guibg=NONE gui=NONE
hi Constant       guifg=NONE guibg=NONE gui=NONE
hi Define         guifg=#3A8881 guibg=NONE gui=NONE
hi DiffAdd        guifg=#545d67 guibg=#a7da1e gui=bold
hi DiffDelete     guifg=#545d67 guibg=#e61f44 gui=NONE
hi DiffChange     guifg=#545d67 guibg=#f7b83d gui=NONE
hi DiffText       guifg=#545d67 guibg=#f7b83d gui=bold
hi ErrorMsg       guifg=#545d67 guibg=#e61f44 gui=NONE
hi WarningMsg     guifg=#545d67 guibg=#f7b83d gui=NONE
hi Float          guifg=#a5bab3 guibg=NONE gui=NONE
hi Function       guifg=#3a8881 guibg=NONE gui=NONE
hi Identifier     guifg=#ffffff guibg=NONE gui=NONE
hi Keyword        guifg=#3a8881 guibg=NONE gui=NONE
hi Label          guifg=#a5bab3 guibg=NONE gui=NONE
hi NonText        guifg=#4b6484 guibg=#2d3237 gui=NONE
hi Number         guifg=#a5bab3 guibg=NONE gui=NONE
hi Operator       guifg=#c0ccdb guibg=NONE gui=NONE
hi PreProc        guifg=#a0a8b1 guibg=NONE gui=NONE
hi Special        guifg=#c0ccdb guibg=NONE gui=NONE
hi SpecialKey     guifg=#c0ccdb guibg=#3a8881 gui=NONE
hi Statement      guifg=#3a8881 guibg=NONE gui=NONE
hi StorageClass   guifg=#d15736 guibg=NONE gui=NONE
hi String         guifg=#a5bab3 guibg=NONE gui=NONE
hi Tag            guifg=#3a8881 guibg=NONE gui=NONE
hi Title          guifg=#3a8881 guibg=NONE gui=bold
hi Todo           guifg=#a0a8b1 guibg=NONE gui=inverse,bold
hi Type           guifg=NONE guibg=NONE gui=NONE
hi Underlined     guifg=NONE guibg=NONE gui=underline

"########################################
"# Language Overrides                   #
"########################################

hi phpIdentifier     guifg=#ffffff
hi phpMethodsVar     guifg=#e8eaec
hi xmlTag            guifg=#3a8881 guibg=NONE gui=NONE
hi xmlTagName        guifg=#3a8881 guibg=NONE gui=NONE
hi xmlEndTag         guifg=#3a8881 guibg=NONE gui=NONE

"########################################
"# Light Theme Overrides                #
"########################################

