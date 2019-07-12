"########################################
"########################################
" Goldfish Light (rainglow)
"
" https://github.com/rainglow/vim
"
" Copyright (c) Dayle Rees.
"########################################
"########################################


"########################################
"# Settings.                            #
"########################################

set background=light
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "goldfish-light"

"########################################
"# Base Colors.                         #
"########################################

hi Cursor         guifg=#ffffff guibg=#222222 gui=NONE
hi Visual         guifg=#ffffff guibg=#f38630 gui=NONE
hi CursorLine     guifg=NONE guibg=#ffffff gui=NONE
hi CursorLineNr   guifg=#ffffff guibg=#ededed gui=NONE
hi CursorColumn   guifg=NONE guibg=#ededed gui=NONE
hi ColorColumn    guifg=NONE guibg=#e6e6e6 gui=NONE
hi LineNr         guifg=#ffffff guibg=#f2f2f2 gui=NONE
hi VertSplit      guifg=#ffffff guibg=#ffffff gui=NONE
hi MatchParen     guifg=#fa6900 guibg=NONE gui=underline
hi StatusLine     guifg=#2e3336 guibg=#f2f2f2 gui=bold
hi StatusLineNC   guifg=#2e3336 guibg=#f2f2f2 gui=NONE
hi Pmenu          guifg=#2e3336 guibg=#f2f2f2 gui=NONE
hi PmenuSel       guifg=NONE guibg=#f38630 gui=NONE
hi IncSearch      guifg=#2e3336 guibg=#f25619 gui=NONE
hi Search         guifg=NONE guibg=NONE gui=underline
hi Directory      guifg=#f38630 guibg=NONE gui=NONE
hi Folded         guifg=#222628 guibg=#e6e6e6 gui=NONE
hi Normal         guifg=#69d2e7 guibg=#ffffff gui=NONE
hi Boolean        guifg=#69d2e7 guibg=NONE gui=NONE
hi Character      guifg=#f36e3a guibg=NONE gui=NONE
hi Comment        guifg=#869aa5 guibg=NONE gui=NONE
hi Conditional    guifg=#91bfbc guibg=NONE gui=NONE
hi Constant       guifg=NONE guibg=NONE gui=NONE
hi Define         guifg=#f38630 guibg=NONE gui=NONE
hi DiffAdd        guifg=#ffffff guibg=#a7da1e gui=bold
hi DiffDelete     guifg=#ffffff guibg=#e61f44 gui=NONE
hi DiffChange     guifg=#ffffff guibg=#f7b83d gui=NONE
hi DiffText       guifg=#ffffff guibg=#f7b83d gui=bold
hi ErrorMsg       guifg=#ffffff guibg=#e61f44 gui=NONE
hi WarningMsg     guifg=#ffffff guibg=#f7b83d gui=NONE
hi Float          guifg=#f25619 guibg=NONE gui=NONE
hi Function       guifg=#f38630 guibg=NONE gui=NONE
hi Identifier     guifg=#2e3336 guibg=NONE gui=NONE
hi Keyword        guifg=#f38630 guibg=NONE gui=NONE
hi Label          guifg=#f36e3a guibg=NONE gui=NONE
hi NonText        guifg=#000000 guibg=#fafafa gui=NONE
hi Number         guifg=#f25619 guibg=NONE gui=NONE
hi Operator       guifg=#2e3336 guibg=NONE gui=NONE
hi PreProc        guifg=#b2bfc6 guibg=NONE gui=NONE
hi Special        guifg=#2e3336 guibg=NONE gui=NONE
hi SpecialKey     guifg=#2e3336 guibg=#f38630 gui=NONE
hi Statement      guifg=#91bfbc guibg=NONE gui=NONE
hi StorageClass   guifg=#fa6900 guibg=NONE gui=NONE
hi String         guifg=#f36e3a guibg=NONE gui=NONE
hi Tag            guifg=#f38630 guibg=NONE gui=NONE
hi Title          guifg=#f38630 guibg=NONE gui=bold
hi Todo           guifg=#b2bfc6 guibg=NONE gui=inverse,bold
hi Type           guifg=NONE guibg=NONE gui=NONE
hi Underlined     guifg=NONE guibg=NONE gui=underline

"########################################
"# Language Overrides                   #
"########################################

hi phpIdentifier     guifg=#2e3336
hi phpMethodsVar     guifg=#ffffff
hi xmlTag            guifg=#f38630 guibg=NONE gui=NONE
hi xmlTagName        guifg=#f38630 guibg=NONE gui=NONE
hi xmlEndTag         guifg=#f38630 guibg=NONE gui=NONE

"########################################
"# Light Theme Overrides                #
"########################################

hi CursorLineNr   guifg=#808080 guibg=#cccccc gui=NONE
hi ColorColumn    guifg=NONE guibg=#ffffff gui=NONE
hi LineNr         guifg=#b3b3b3 guibg=#f2f2f2 gui=NONE
hi phpMethodsVar  guifg=#000000
hi DiffAdd        guifg=#d9d9d9 guibg=#59a50b gui=bold
hi DiffDelete     guifg=#d9d9d9 guibg=#a30e29 gui=NONE
hi DiffChange     guifg=#d9d9d9 guibg=#c48405 gui=NONE
hi DiffText       guifg=#d9d9d9 guibg=#c48405 gui=bold
hi ErrorMsg       guifg=#d9d9d9 guibg=#a30e29 gui=NONE
hi WarningMsg     guifg=#d9d9d9 guibg=#c48405 gui=NONE
hi Folded         guifg=#3a4044 guibg=#e6e6e6 gui=NONE
