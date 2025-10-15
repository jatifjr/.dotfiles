" ===============================================================
" ANSI
" 16-color terminal colorscheme with transparent background
" ===============================================================

" Setup
set background=dark
if version > 580
	hi clear
	if exists("syntax_on")
		syntax reset
	endif
endif

set t_Co=16
set notermguicolors

let g:colors_name = "ansi"

" ANSI color mappings (cterm values 0-15):
" 0  = Black
" 1  = Red
" 2  = Green
" 3  = Yellow
" 4  = Blue
" 5  = Magenta
" 6  = Cyan
" 7  = White
" 8  = BrightBlack
" 9  = BrightRed
" 10 = BrightGreen
" 11 = BrightYellow
" 12 = BrightBlue
" 13 = BrightMagenta
" 14 = BrightCyan
" 15 = BrightWhite

highlight Normal              ctermfg=7     ctermbg=NONE  cterm=NONE
highlight IncSearch           ctermfg=0     ctermbg=11    cterm=NONE
highlight WildMenu            ctermfg=NONE  ctermbg=8     cterm=NONE
highlight SignColumn          ctermfg=8     ctermbg=NONE  cterm=NONE
highlight SpecialComment      ctermfg=11    ctermbg=NONE  cterm=NONE
highlight Typedef             ctermfg=4     ctermbg=NONE  cterm=bold
highlight Title               ctermfg=11    ctermbg=NONE  cterm=bold
highlight Folded              ctermfg=8     ctermbg=NONE  cterm=NONE
highlight PreCondit           ctermfg=11    ctermbg=NONE  cterm=NONE
highlight Include             ctermfg=11    ctermbg=NONE  cterm=NONE
highlight Float               ctermfg=3     ctermbg=NONE  cterm=NONE
highlight StatusLineNC        ctermfg=7     ctermbg=8     cterm=bold
highlight NonText             ctermfg=8     ctermbg=NONE  cterm=NONE
highlight DiffText            ctermfg=1     ctermbg=NONE  cterm=NONE
highlight ErrorMsg            ctermfg=1     ctermbg=NONE  cterm=NONE
highlight Debug               ctermfg=11    ctermbg=NONE  cterm=NONE
highlight PMenuSbar           ctermfg=NONE  ctermbg=8     cterm=NONE
highlight Identifier          ctermfg=6     ctermbg=NONE  cterm=NONE
highlight SpecialChar         ctermfg=11    ctermbg=NONE  cterm=NONE
highlight Conditional         ctermfg=11    ctermbg=NONE  cterm=bold
highlight StorageClass        ctermfg=4     ctermbg=NONE  cterm=bold
highlight Todo                ctermfg=11    ctermbg=NONE  cterm=NONE
highlight Special             ctermfg=11    ctermbg=NONE  cterm=NONE
highlight LineNr              ctermfg=8     ctermbg=NONE  cterm=NONE
highlight StatusLine          ctermfg=7     ctermbg=8     cterm=bold
highlight Label               ctermfg=11    ctermbg=NONE  cterm=bold
highlight PMenuSel            ctermfg=2     ctermbg=8     cterm=NONE
highlight Search              ctermfg=0     ctermbg=11    cterm=NONE
highlight Delimiter           ctermfg=11    ctermbg=NONE  cterm=NONE
highlight Statement           ctermfg=5     ctermbg=NONE  cterm=bold
highlight SpellRare           ctermfg=7     ctermbg=NONE  cterm=underline
highlight Comment             ctermfg=8     ctermbg=NONE  cterm=NONE
highlight Character           ctermfg=7     ctermbg=NONE  cterm=NONE
highlight TabLineSel          ctermfg=7     ctermbg=NONE  cterm=bold
highlight Number              ctermfg=11    ctermbg=NONE  cterm=NONE
highlight Boolean             ctermfg=7     ctermbg=NONE  cterm=NONE
highlight Operator            ctermfg=5     ctermbg=NONE  cterm=bold
highlight CursorLine          ctermfg=NONE  ctermbg=NONE  cterm=NONE
highlight ColorColumn         ctermfg=NONE  ctermbg=NONE  cterm=NONE
highlight CursorLineNR        ctermfg=11    ctermbg=NONE  cterm=NONE
highlight TabLineFill         ctermfg=8     ctermbg=8     cterm=bold
highlight WarningMsg          ctermfg=1     ctermbg=NONE  cterm=NONE
highlight VisualNOS           ctermfg=0     ctermbg=7     cterm=underline
highlight DiffDelete          ctermfg=5     ctermbg=NONE  cterm=NONE
highlight ModeMsg             ctermfg=15    ctermbg=NONE  cterm=bold
highlight CursorColumn        ctermfg=7     ctermbg=NONE  cterm=NONE
highlight Define              ctermfg=11    ctermbg=NONE  cterm=NONE
highlight Function            ctermfg=4     ctermbg=NONE  cterm=bold
highlight FoldColumn          ctermfg=8     ctermbg=NONE  cterm=NONE
highlight PreProc             ctermfg=1     ctermbg=NONE  cterm=NONE
highlight Visual              ctermfg=0     ctermbg=7     cterm=NONE
highlight MoreMsg             ctermfg=11    ctermbg=NONE  cterm=bold
highlight SpellCap            ctermfg=7     ctermbg=NONE  cterm=underline
highlight VertSplit           ctermfg=8     ctermbg=NONE  cterm=bold
highlight Exception           ctermfg=1     ctermbg=NONE  cterm=bold
highlight Keyword             ctermfg=5     ctermbg=NONE  cterm=bold
highlight Type                ctermfg=6     ctermbg=NONE  cterm=bold
highlight DiffChange          ctermfg=7     ctermbg=NONE  cterm=NONE
highlight Cursor              ctermfg=0     ctermbg=15    cterm=NONE
highlight SpellLocal          ctermfg=7     ctermbg=NONE  cterm=underline
highlight Error               ctermfg=1     ctermbg=NONE  cterm=NONE
highlight PMenu               ctermfg=7     ctermbg=8     cterm=NONE
highlight SpecialKey          ctermfg=8     ctermbg=NONE  cterm=NONE
highlight Constant            ctermfg=2     ctermbg=NONE  cterm=NONE
highlight Tag                 ctermfg=11    ctermbg=NONE  cterm=NONE
highlight String              ctermfg=11    ctermbg=NONE  cterm=NONE
highlight PMenuThumb          ctermfg=NONE  ctermbg=7     cterm=NONE
highlight MatchParen          ctermfg=11    ctermbg=NONE  cterm=bold
highlight Repeat              ctermfg=2     ctermbg=NONE  cterm=bold
highlight SpellBad            ctermfg=7     ctermbg=NONE  cterm=underline
highlight Directory           ctermfg=4     ctermbg=NONE  cterm=bold
highlight Structure           ctermfg=4     ctermbg=NONE  cterm=bold
highlight Macro               ctermfg=11    ctermbg=NONE  cterm=NONE
highlight Underlined          ctermfg=7     ctermbg=NONE  cterm=underline
highlight DiffAdd             ctermfg=2     ctermbg=NONE  cterm=NONE
highlight TabLine             ctermfg=7     ctermbg=8     cterm=bold
