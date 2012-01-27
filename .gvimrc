if has('kaoriya')
  if has('win32')
    scriptencoding utf-8
    set guifont=Consolas:h11
    "set guifontwide=MS_Gothic
    let &guifontwide = iconv('Osaka－等幅:h10:cSHIFTJIS', &encoding, 'cp932')
    set ambiwidth=double
  endif
  if has('mac')
    set guifont=Menlo:h13
    set guifontwide=Osaka-Mono:h13
    set noimdisableactivate
    " set transparency=12
  endif
endif
if has('gui_gtk2')
  " set guifont=Monospace\\ 11
  set gfn=Takaoゴシック\ 11
endif
set bg=dark
set nobackup
" set lines=48
" set columns=96

" enable toolbar and menu
set guioptions-=T
set guioptions-=m

" 行末強調表示
highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/
autocmd WinEnter * match WhitespaceEOL /\s\+$/

"Note background set to dark in .vimrc
"highlight Normal guifg=grey guibg=black
"highlight NonText guifg=grey guibg=black
"highlight Search guifg=black guibg=yellow
