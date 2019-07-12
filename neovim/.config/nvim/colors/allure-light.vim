"########################################
"########################################
" Allure Light (rainglow)
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

let g:colors_name = "allure-light"

"########################################
"# Base Colors.                         #
"########################################

hi Cursor         guifg=#ffffff guibg=#333333 gui=NONE
hi Visual         guifg=#ffffff guibg=#5da892 gui=NONE
hi CursorLine     guifg=NONE guibg=#ffffff gui=NONE
hi CursorLineNr   guifg=#ffffff guibg=#ededed gui=NONE
hi CursorColumn   guifg=NONE guibg=#ededed gui=NONE
hi ColorColumn    guifg=NONE guibg=#e6e6e6 gui=NONE
hi LineNr         guifg=#ffffff guibg=#f2f2f2 gui=NONE
hi VertSplit      guifg=#ffffff guibg=#ffffff gui=NONE
hi MatchParen     guifg=#e4d294 guibg=NONE gui=underline
hi StatusLine     guifg=#555e68 guibg=#f2f2f2 gui=bold
hi StatusLineNC   guifg=#555e68 guibg=#f2f2f2 gui=NONE
hi Pmenu          guifg=#555e68 guibg=#f2f2f2 gui=NONE
hi PmenuSel       guifg=NONE guibg=#5da892 gui=NONE
hi IncSearch      guifg=#555e68 guibg=#cea36f gui=NONE
hi Search         guifg=NONE guibg=NONE gui=underline
hi Directory      guifg=#5da892 guibg=NONE gui=NONE
hi Folded         guifg=#4a515a guibg=#e6e6e6 gui=NONE
hi Normal         guifg=#555e68 guibg=#ffffff gui=NONE
hi Boolean        guifg=#555e68 guibg=NONE gui=NONE
hi Character      guifg=#cec86f guibg=NONE gui=NONE
hi Comment        guifg=#b5c0cc guibg=NONE gui=NONE
hi Conditional    guifg=#5da892 guibg=NONE gui=NONE
hi Constant       guifg=NONE guibg=NONE gui=NONE
hi Define         guifg=#5DA892 guibg=NONE gui=NONE
hi DiffAdd        guifg=#ffffff guibg=#a7da1e gui=bold
hi DiffDelete     guifg=#ffffff guibg=#e61f44 gui=NONE
hi DiffChange     guifg=#ffffff guibg=#f7b83d gui=NONE
hi DiffText       guifg=#ffffff guibg=#f7b83d gui=bold
hi ErrorMsg       guifg=#ffffff guibg=#e61f44 gui=NONE
hi WarningMsg     guifg=#ffffff guibg=#f7b83d gui=NONE
hi Float          guifg=#cea36f guibg=NONE gui=NONE
hi Function       guifg=#5da892 guibg=NONE gui=NONE
hi Identifier     guifg=#3c4249 guibg=NONE gui=NONE
hi Keyword        guifg=#5da892 guibg=NONE gui=NONE
hi Label          guifg=#cec86f guibg=NONE gui=NONE
hi NonText        guifg=#000000 guibg=#fafafa gui=NONE
hi Number         guifg=#cea36f guibg=NONE gui=NONE
hi Operator       guifg=#555e68 guibg=NONE gui=NONE
hi PreProc        guifg=#e2e7eb guibg=NONE gui=NONE
hi Special        guifg=#555e68 guibg=NONE gui=NONE
hi SpecialKey     guifg=#555e68 guibg=#5da892 gui=NONE
hi Statement      guifg=#5da892 guibg=NONE gui=NONE
hi StorageClass   guifg=#e4d294 guibg=NONE gui=NONE
hi String         guifg=#cec86f guibg=NONE gui=NONE
hi Tag            guifg=#5da892 guibg=NONE gui=NONE
hi Title          guifg=#5da892 guibg=NONE gui=bold
hi Todo           guifg=#e2e7eb guibg=NONE gui=inverse,bold
hi Type           guifg=NONE guibg=NONE gui=NONE
hi Underlined     guifg=NONE guibg=NONE gui=underline

"########################################
"# Language Overrides                   #
"########################################

hi phpIdentifier     guifg=#3c4249
hi phpMethodsVar     guifg=#ffffff
hi xmlTag            guifg=#5da892 guibg=NONE gui=NONE
hi xmlTagName        guifg=#5da892 guibg=NONE gui=NONE
hi xmlEndTag         guifg=#5da892 guibg=NONE gui=NONE

"########################################
"# Light Theme Overrides                #
"########################################

hi CursorLineNr   guifg=#808080 guibg=#cccccc gui=NONE
hi ColorColumn    guifg=NONE guibg=#ffffff gui=NONE
hi LineNr         guifg=#b3b3b3 guibg=#f2f2f2 gui=NONE
hi phpMethodsVar  guifg=#272b30
hi DiffAdd        guifg=#d9d9d9 guibg=#59a50b gui=bold
hi DiffDelete     guifg=#d9d9d9 guibg=#a30e29 gui=NONE
hi DiffChange     guifg=#d9d9d9 guibg=#c48405 gui=NONE
hi DiffText       guifg=#d9d9d9 guibg=#c48405 gui=bold
hi ErrorMsg       guifg=#d9d9d9 guibg=#a30e29 gui=NONE
hi WarningMsg     guifg=#d9d9d9 guibg=#c48405 gui=NONE
hi Folded         guifg=#606b76 guibg=#e6e6e6 gui=NONE
