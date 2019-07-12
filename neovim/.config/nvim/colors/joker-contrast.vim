"########################################
"########################################
" Joker Contrast (rainglow)
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

let g:colors_name = "joker-contrast"

"########################################
"# Base Colors.                         #
"########################################

hi Cursor         guifg=#141619 guibg=#ffffff gui=NONE
hi Visual         guifg=#ffffff guibg=#00b27d gui=NONE
hi CursorLine     guifg=NONE guibg=#1b1d21 gui=NONE
hi CursorLineNr   guifg=#58616e guibg=#040505 gui=NONE
hi CursorColumn   guifg=NONE guibg=#040505 gui=NONE
hi ColorColumn    guifg=NONE guibg=#000000 gui=NONE
hi LineNr         guifg=#2b2f35 guibg=#090a0b gui=NONE
hi VertSplit      guifg=#2b2f35 guibg=#2b2f35 gui=NONE
hi MatchParen     guifg=#9a6fc4 guibg=NONE gui=underline
hi StatusLine     guifg=#c0ccdb guibg=#090a0b gui=bold
hi StatusLineNC   guifg=#c0ccdb guibg=#090a0b gui=NONE
hi Pmenu          guifg=#c0ccdb guibg=#090a0b gui=NONE
hi PmenuSel       guifg=NONE guibg=#00b27d gui=NONE
hi IncSearch      guifg=#c0ccdb guibg=#aaaaaa gui=NONE
hi Search         guifg=NONE guibg=NONE gui=underline
hi Directory      guifg=#00b27d guibg=NONE gui=NONE
hi Folded         guifg=#b0bfd2 guibg=#000000 gui=NONE
hi Normal         guifg=#ffffff guibg=#141619 gui=NONE
hi Boolean        guifg=#ffffff guibg=NONE gui=NONE
hi Character      guifg=#cccccc guibg=NONE gui=NONE
hi Comment        guifg=#76818e guibg=NONE gui=NONE
hi Conditional    guifg=#00b27d guibg=NONE gui=NONE
hi Constant       guifg=NONE guibg=NONE gui=NONE
hi Define         guifg=#00b27d guibg=NONE gui=NONE
hi DiffAdd        guifg=#363b43 guibg=#a7da1e gui=bold
hi DiffDelete     guifg=#363b43 guibg=#e61f44 gui=NONE
hi DiffChange     guifg=#363b43 guibg=#f7b83d gui=NONE
hi DiffText       guifg=#363b43 guibg=#f7b83d gui=bold
hi ErrorMsg       guifg=#363b43 guibg=#e61f44 gui=NONE
hi WarningMsg     guifg=#363b43 guibg=#f7b83d gui=NONE
hi Float          guifg=#aaaaaa guibg=NONE gui=NONE
hi Function       guifg=#00b27d guibg=NONE gui=NONE
hi Identifier     guifg=#ffffff guibg=NONE gui=NONE
hi Keyword        guifg=#00b27d guibg=NONE gui=NONE
hi Label          guifg=#cccccc guibg=NONE gui=NONE
hi NonText        guifg=#4b6484 guibg=#0f1113 gui=NONE
hi Number         guifg=#aaaaaa guibg=NONE gui=NONE
hi Operator       guifg=#c0ccdb guibg=NONE gui=NONE
hi PreProc        guifg=#a0a8b1 guibg=NONE gui=NONE
hi Special        guifg=#c0ccdb guibg=NONE gui=NONE
hi SpecialKey     guifg=#c0ccdb guibg=#00b27d gui=NONE
hi Statement      guifg=#00b27d guibg=NONE gui=NONE
hi StorageClass   guifg=#9a6fc4 guibg=NONE gui=NONE
hi String         guifg=#cccccc guibg=NONE gui=NONE
hi Tag            guifg=#00b27d guibg=NONE gui=NONE
hi Title          guifg=#00b27d guibg=NONE gui=bold
hi Todo           guifg=#a0a8b1 guibg=NONE gui=inverse,bold
hi Type           guifg=NONE guibg=NONE gui=NONE
hi Underlined     guifg=NONE guibg=NONE gui=underline

"########################################
"# Language Overrides                   #
"########################################

hi phpIdentifier     guifg=#ffffff
hi phpMethodsVar     guifg=#c3c8cf
hi xmlTag            guifg=#00b27d guibg=NONE gui=NONE
hi xmlTagName        guifg=#00b27d guibg=NONE gui=NONE
hi xmlEndTag         guifg=#00b27d guibg=NONE gui=NONE

"########################################
"# Light Theme Overrides                #
"########################################

