set nocompatible

"----------------------------------------
"文字コードの自動認識
"----------------------------------------
let &termencoding = &encoding
set encoding=utf-8

" 文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif

"let &fileencodings = substitute(&fileencodings, 'utf-8', '_utf-8', 'g')
"let &fileencodings = substitute(&fileencodings, 'cp932', 'utf-8', 'g')
"let &fileencodings = substitute(&fileencodings, '_utf-8', 'cp932', 'g')

" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
      if has('win32')
        let &fileencoding='cp932'
      endif
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □や○の文字があってもカーソル位置がずれないようにする。
if exists('&ambiwidth')
  set ambiwidth=double
endif

"----------------------------------------
"メッセージの日本語化
"----------------------------------------
if has('unix')&&has('gui_running')
  let $LANG='ja'
endif


"----------------------------------------
" create directory automatically
"----------------------------------------
augroup vimrc-auto-mkdir
    autocmd!
    autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
    function! s:auto_mkdir(dir, force)
        if !isdirectory(a:dir) && (a:force ||
            \ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
            call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
        endif
    endfunction
augroup END


"---------------------------------------
" Plugin Setting Managed by Vundle
"---------------------------------------
filetype off

set rtp+=~/.vim/vundle.git/
call vundle#rc()

Bundle 'clones/vim-l9'
Bundle 'FuzzyFinder'
Bundle 'Shougo/neocomplcache'
Bundle 'thinca/vim-quickrun'
Bundle "scrooloose/nerdtree"
Bundle "kana/vim-fakeclip"
Bundle "fuenor/qfixhowm"
Bundle "kakkyz81/evervim"

" Python
Bundle "lambdalisue/vim-python-virtualenv"
Bundle "mitechie/pyflakes-pathogen"

" js
Bundle 'JavaScript-syntax'
Bundle 'itspriddle/vim-javascript-indent'

" 引数無しで vim を開いたら NERDTree 起動
let file_name = expand("%")
if has('vim_starting') &&  file_name == ""
    autocmd VimEnter * NERDTree ./
endif

" NERDTree {{{
    nnoremap <Space>tr :<C-u>NERDTreeToggle<Enter>
    let NERDTreeShowHidden = 1
" }}}

" QFixHowm {{{
    " qfixappにruntimepathを通す(パスは環境に合わせてください)
    set runtimepath+=~/.vim/bundle/qfixhowm
    " キーマップリーダー
    let QFixHowm_Key = 'g'
    " howm_dirはファイルを保存したいディレクトリを設定
    let howm_dir             = '~/howm'
    let howm_filename        = '%Y/%m/%Y-%m-%d-%H%M%S.txt'
    let howm_fileencoding    = 'utf-8'
    let howm_fileformat      = 'unix'
" }}}


""
" FILETYPE
"-------------------------------------------------------------------------

filetype plugin indent on


""
" GUI
"-------------------------------------------------------------------------

" Low-Contrast    - http://www.vim.org/scripts/script.php?script_id=1448
" rdark           - http://www.vim.org/scripts/script.php?script_id=1732
" ChocolateLiquor - http://www.vim.org/scripts/script.php?script_id=592
" ctermbg   コンソールの背景色
" guibg     Gvimの背景色
" ctermfg   コンソールのテキストの色
" guifg     Gvimのテキストの色
" gui       Gvimのフォントフォーマット
" term      コンソールのフォントフォーマット（太字など）

if has('gui_macvim')
    winpos 70 70                   " ウィンドウの左上隅の位置をピクセル単位で指定で表示
    set columns=180                " window横
    set lines=60                   " window縦
endif
set autoindent                 " インデント
set backspace=indent,eol,start " BSでなんでも消せるように
set cmdheight=2                " コマンドラインの高さ(GUI使用時)
"set cursorline                 " カーソル行を強調表示
set t_Co=256                   " カーソルライン用色設定
hi CursorLine   term=reverse cterm=none ctermbg=242 " カーソルライン反転
set display=lastline
set expandtab                  " タブ入力がスペースに変換 :retab でタブ・スペースの変換
set formatoptions+=mM          " 整形オプションにマルチバイト系を追加
set hlsearch                   " 検索結果文字列のハイライトを有効にする
set ignorecase
set incsearch
set laststatus=2               " ステータスラインを常に表示
set list
set listchars=tab:\ \          " タブの左側にカーソル表示
set lsp=3                      " 行間
set mouse=a                    " マウスモード有効
set mousehide                  " 入力時にマウスポインタを隠す (nomousehide:隠さない)
set nowrap                     " 行折り返しをしない
set nomousefocus               " マウスの移動でフォーカスを自動的に切替えない (mousefocus:切替る)
set number                     " 行番号表示
set ruler					   " ルーラー表示
set shellslash
set shiftwidth=4               " 自動的に挿入される量
set showcmd                    " 入力中のコマンドをステータスに表示する
set showmatch                  " 括弧入力時の対応する括弧を表示
set smartindent
set smartcase
set softtabstop=0              " <Tab>キーを押した時に挿入される空白の量
set tabstop=4                  " タブスペース数設定
set title                      " タイトルをウィンドウ枠に表示
set whichwrap=b,s,[,],<,>
set wildmenu
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif


" 入力モード時、ステータスラインのカラーを変更
augroup InsertHook
    autocmd!
    autocmd InsertEnter * highlight StatusLine ctermfg=black ctermbg=white guifg=#2E4340 guibg=#ccdc90
    autocmd InsertLeave * highlight StatusLine ctermfg=black ctermbg=lightgray guifg=black guibg=#c2bfa5
augroup END

" ステータスラインに文字コードと改行文字を表示する
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

" ノーマルモードでIME OFF
"augroup InsModeAu
"    autocmd!
"    autocmd InsertEnter,CmdwinEnter * set noimdisable
"    autocmd InsertLeave,CmdwinLeave * set imdisable
"augroup END

" 特殊文字(SpecialKey)の見える化。listcharsはlcsでも設定可能。trailは行末スペース。
set list
set listchars=tab:>.,trail:_,nbsp:%,extends:>,precedes:<
highlight SpecialKey term=underline ctermfg=darkgray guifg=darkgray

"set list
"set listchars=tab:\ \ ,extends:<,trail:_

"highlight SpecialKey guibg=#222222 cterm=underline ctermfg=darkgrey

" 81桁目以降を強調表示
" hi over80column guibg=dimgray
" match over80column /.\%>81v/

" シンタックスハイライトを有効にする
if has("syntax")
    syntax on
endif

" ポップアップカラー
hi Pmenu ctermbg=darkgray guibg=darkgray
hi PmenuSel ctermbg=brown ctermfg=white guibg=brown guifg=white
hi PmenuSbar ctermbg=black guibg=black

" カーソル行をハイライト（重い）
"highlight CursorLine guibg=lightblue ctermbg=lightgray ctermfg=blue

" MAC
if has('gui_macvim')
    set showtabline=2         " タブを常に表示
    set imdisable             " IMを無効化
    set transparency=10       " 透明度
    set antialias             " アンチエイリアス
    set guifont=VL_Gothic:h12 " フォント
endif

" WINDOWS
if has('win32')
    set guifont=VL_Gothic:h10:cSHIFTJIS       " フォント
    set printoptions=wrap:y,number:y,header:0 " 印刷
    set printfont=VL_Gothic:h10:cSHIFTJIS     " 印刷時のフォント
endif


""
" EDIT
" -------------------------------------------------------------------------

"コメントが連続で挿入されるのを停止 
autocmd FileType * setlocal formatoptions-=ro 

"バイナリ編集(xxd)モード（vim -b での起動、もしくは *.bin で発動します）
augroup BinaryXXD
    autocmd!
    autocmd BufReadPre  *.bin let &binary =1
    autocmd BufReadPost * if &binary | silent %!xxd -g 1
    autocmd BufReadPost * set ft=xxd | endif
    autocmd BufWritePre * if &binary | %!xxd -r | endif
    autocmd BufWritePost * if &binary | silent %!xxd -g 1
    autocmd BufWritePost * set nomod | endif
augroup END

""
" PHP
" -------------------------------------------------------------------------
autocmd FileType php  :set dictionary=~/.vim/dict/php.dict

""
" Python
" -------------------------------------------------------------------------
"filetype on
"filetype plugin on
autocmd FileType python let g:pydiction_location = '~/.vim/pydiction/complete-dict'
"autocmd FileType python setl autoindent
"autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
"autocmd FileType python setl tabstop=8 expandtab shiftwidth=4 softtabstop=4

""
" pyflakes suntax-color setting
" -------------------------------------------------------------------------
if has("gui_running")
    highlight SpellBad term=underline gui=undercurl guisp=Orange
endif

""
" Python 実行設定 <C-P>
" -------------------------------------------------------------------------
function! s:ExecPy()
    exe "!" . &ft . " %"
:endfunction
command! Exec call <SID>ExecPy()
autocmd FileType python map <silent> <C-P> :call <SID>ExecPy()<CR>



""
" SEARCH
" -------------------------------------------------------------------------

set ignorecase  " 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set smartcase   " 検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan    " 検索時に最後まで行ったら最初に戻る
set noincsearch " 検索文字列入力時に順次対象文字列にヒットさせない


""
" REMAP
" -------------------------------------------------------------------------

nnoremap <Space>. :<C-u>edit $MYVIMRC<Enter>
nnoremap <Space>s. :<C-u>source $MYVIMRC<Enter>
nnoremap <Space>j <C-f>
nnoremap <Space>k <C-b>
nnoremap <Space>w :<C-u>set ff=dos fenc=shift_jis<Enter>
nnoremap <Space>u :<C-u>set ff=unix fenc=utf-8<Enter>
nnoremap <Space>sc :<C-u>edit $HOME/Sites/scrapture/<Enter>
nnoremap <Space>t :<C-u>tabnew<Enter>
nnoremap <Space>h :<C-u>tabp<Enter>
nnoremap <Space>l :<C-u>tabn<Enter>
nnoremap <Esc><Esc> :<C-u>nohlsearch<Enter>
nnoremap 0 :<C-u>call append(expand('.'), '')<Cr>j " 空行を挿入

" GIT
"let g:git_no_map_default = 1
"let g:git_command_edit = 'rightbelow vnew'
"nnoremap <Space>gd :<C-u>GitDiff --cached<Enter>
"nnoremap <Space>gD :<C-u>GitDiff<Enter>
"nnoremap <Space>gs :<C-u>GitStatus<Enter>
"nnoremap <Space>gl :<C-u>GitLog<Enter>
"nnoremap <Space>gL :<C-u>GitLog -u \| head -10000<Enter>
"nnoremap <Space>ga :<C-u>GitAdd<Enter>
"nnoremap <Space>gA :<C-u>GitAdd <cfile><Enter>
"nnoremap <Space>gc :<C-u>GitCommit<Enter>
"nnoremap <Space>gC :<C-u>GitCommit --amend<Enter>
"nnoremap <Space>gp :<C-u>Git push

""
" PLUGIN
" -------------------------------------------------------------------------

" Align
" 整形
let g:Align_xstrlen = 3
vmap <Space>s <Leader>tsp
smap <Space>s <Leader>tsp
vmap <Space>a : Align
smap <Space>a : Align

"フレームサイズを怠惰に変更する
map <kPlus> <C-W>+
map <kMinus> <C-W>-

" Taglist
" 関数一覧
set tags=tags
"let Tlist_Ctags_Cmd = '/Users/enfar/Sites/.ctags/tags'    " ctagsのパス
let Tlist_Show_One_File = 1               " 現在編集中のソースのタグしか表示しない
let Tlist_Exit_OnlyWindow = 1             " taglistのウィンドーが最後のウィンドーならばVimを閉じる
let Tlist_Use_Right_Window = 1            " 右側でtaglistのウィンドーを表示
let Tlist_Enable_Fold_Column = 1          " 折りたたみ
let Tlist_Auto_Open = 1                   " 自動表示
"map <silent> <leader>tl :Tlist<CR>        " taglistを開くショットカットキー

" Srcexpl
" tagsを利用したソースコード閲覧・移動補助機能
let g:SrcExpl_UpdateTags    = 1         " tagsをsrcexpl起動時に自動で作成（更新）
let g:SrcExpl_RefreshTime   = 0         " 自動表示するまでの時間(0:off)
let g:SrcExpl_WinHeight     = 9         " プレビューウインドウの高さ
let g:SrcExpl_RefreshMapKey = "<Space>" " 手動表示のMAP
let g:SrcExpl_GoBackMapKey  = "<C-b>"   " 戻る機能のMAP
nmap <F8> :SrcExplToggle<CR>            " Source Explorerの機能ON/OFF

""
" IME
"
if has('multi_byte_ime') || has('xim')
    " カーソル上の文字色は文字の背景色にする。
    " IME が無効なとき Green
    " IME が有効なとき Purple にする。
    "hi Cursor guifg=bg guibg=Green gui=NONE
    hi CursorIM guifg=NONE guibg=Purple gui=NONE
    " IME ON時のカーソルの色を設定
    highlight CursorIM guibg=lightgreen guifg=NONE
    " 挿入モード・検索モードでのデフォルトのIME状態設定
    set iminsert=0 imsearch=0
endif

""
" URLをブラウザで開く
"
" let BrowserPath = 'C:\Program Files\Mozilla Firefox\firefox.exe'
function! AL_execute(cmd)
  if 0 && exists('g:AL_option_nosilent') && g:AL_option_nosilent != 0
    execute a:cmd
  else
    silent! execute a:cmd
  endif
endfunction

function! s:AL_open_url_win32(url)
  let url = substitute(a:url, '%', '%25', 'g')
  if url =~# ' '
    let url = substitute(url, ' ', '%20', 'g')
    let url = substitute(url, '^file://', 'file:/', '')
  endif
  " If 'url' has % or #, all of those characters are expanded to buffer name
  " by execute().  Below escape() suppress this.  system() does not expand
  " those characters.
  let url = escape(url, '%#')
  " Start system related URL browser
  if !has('win95') && url !~ '[&!]'
    " for Win NT/2K/XP
    call AL_execute('!start /min cmd /c start ' . url)
    " MEMO: "cmd" causes some side effects.  Some strings like "%CD%" is
    " expanded (may be environment variable?) by cmd.
  else
    " It is known this rundll32 method has a problem when opening URL that
    " matches http://*.html.  It is better to use ShellExecute() API for
    " this purpose, open some URL.  Command "cmd" and "start" on NT/2K?XP
    " does this.
    call AL_execute("!start rundll32 url.dll,FileProtocolHandler " . url)
  endif
endfunction


""
" LINK BROWSER
"
function! Browser()
    let line0 = getline(".")
    let line = matchstr(line0, "http[^ ]*")
    if line==""
      let line = matchstr(line0, "ftp[^ ]*")
    endif
    if line==""
      let line = matchstr(line0, "file[^ ]*")
    endif
"    exec ":silent !start \"" . g:BrowserPath . "\" \"" . line . "\""
    call s:AL_open_url_win32(line)
endfunction
map <Leader>w :call Browser()<CR>


""
" Set skip input time
"
" 勝手にオムニ補完しない時間を設定
let g:NeoComplCache_SkipInputTime = '1.5'


""
" OMNI MAPPING
"
function! InsertTabWrapper()
    if pumvisible()
        return "\<c-n>"
    endif
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k\|<\|/'
        return "\<tab>"
    elseif exists('&omnifunc') && &omnifunc == ''
        return "\<c-n>"
    else
        return "\<c-x>\<c-o>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<CR>


""
" OMNIFUNC
"
" 注意: この内容は:filetype onよりも後に記述すること。
autocmd FileType *
\   if &l:omnifunc == ''
\ |   setlocal omnifunc=syntaxcomplete#Complete
\ | endif
