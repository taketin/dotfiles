""
" PHP Lint
"
function! PHPLint()
    let result = system(&ft . ' -l ' . bufname(""))
    echo result
endfunction
nmap ,l :call PHPLint()<CR>

""
" ShebangExecut
" @see http://subtech.g.hatena.ne.jp/secondlife/20060727/1153990447
"
function! ShebangExecute()
    let m = matchlist(getline(1), '#!\(.*\)')
    if (len(m) > 2)
        execute '!' . m[1] . ' %'
    else
        execute '!' &ft ' %'
    endif
endfunction
nmap ,e :call ShebangExecute()<CR>

""
" PHP-DOC
"
inoremap <C-P> <ESC>:call PhpDocSingle()<CR>i
nnoremap <C-P> :call PhpDocSingle()<CR>
vnoremap <C-P> :call PhpDocRange()<CR>

""
" REMAP
"
nmap ,r :let @b=expand("<cWORD>")<CR>oecho '<pre>'; var_dump(<ESC>"bpA); echo '</pre>'; die;<ESC> " 変数の上で,rでDump
nmap ,R :let @b=expand("<cword>")<CR>oecho '<pre>'; var_dump(<ESC>"bpA); echo '</pre>'; die;<ESC> " 変数の上で,RでDump
nmap ,m :let @b=expand("<cWORD>")<CR>o@mb_send_mail('t-oda@paperboy.co.jp', 'Debug', print_r(<ESC>"bpA, true));<ESC> " 変数の上で,mでMailDebug
nmap ,t :let @b=expand("")<CR>o$this-><ESC>
nmap ,T :let @b=expand("")<CR>o$this->_<ESC>
" winの場合最後に0追加
"nmap ,r :let @b=expand("<cWORD>")<CR>oecho '<pre>'; var_dump(<ESC>"bpA); echo '</pre>'; die;<ESC>0 " 変数の上で,rでDump
"nmap ,R :let @b=expand("<cword>")<CR>oecho '<pre>'; var_dump(<ESC>"bpA); echo '</pre>'; die;<ESC>0 " 変数の上で,RでDump
"nmap ,m :let @b=expand("<cWORD>")<CR>o@mb_send_mail('t-oda@paperboy.co.jp', 'Debug', print_r(<ESC>"bpA, true));<ESC>0 " 変数の上で,mでMailDebug
"nmap ,t :let @b=expand("")<CR>o$this-><ESC>0
"nmap ,T :let @b=expand("")<CR>o$this->_<ESC>0
