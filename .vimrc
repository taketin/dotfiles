""""""""""""""""""""""""""""""""""""""""""""""""""""""
" taketin's .vimrc                                   "
"            _                                       "
"  _   __   (_)  ____ ___     _____   _____          "
" | | / /  / /  / __ `__ \   / ___/  / ___/          "
" | |/ /  / /  / / / / / /  / /     / /__            "
" |___/  /_/  /_/ /_/ /_/  /_/      \___/            "
"                                                    "
""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible
let plugin_cmdex_disable = 1
let $MYVIMRC = '$HOME/.vimrc'
let $MYDOTVIM = '$HOME/.vim'
let mapleader = ','

" see https://github.com/suan/vim-instant-markdown
set shell=bash\ -i

"-----------------------------------------------------
" 文字コードの自動認識
"-----------------------------------------------------
let &termencoding = &encoding
set encoding=utf-8
source $MYDOTVIM/recognize_charcode.vim

" IME
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

"-----------------------------------------------------
"  メッセージの日本語化
"-----------------------------------------------------
if has('unix')&&has('gui_running')
  let $LANG='ja'
endif

"-----------------------------------------------------
"  auto paste
"-----------------------------------------------------
if &term =~ "xterm"
    let &t_ti .= "\e[?2004h"
    let &t_te .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    noremap <special> <expr> <Esc>[200~ XTermPasteBegin("0i")
    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
    cnoremap <special> <Esc>[200~ <nop>
    cnoremap <special> <Esc>[201~ <nop>
endif

"-----------------------------------------------------
"  ディレクトリ自動生成
"-----------------------------------------------------
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


"-----------------------------------------------------
"  NeoBundle
"-----------------------------------------------------
filetype off

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim
    call neobundle#rc(expand('~/.vim/bundle/'))
endif

NeoBundle "Shougo/neobundle"
NeoBundle "Shougo/unite.vim"
NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/neocomplcache-rsense'
NeoBundle 'Shougo/vimproc', {'build': {'mac': 'make -f make_mac.mak'}}
NeoBundle 'Shougo/vimshell'
NeoBundle "clones/vim-l9"
NeoBundle "thinca/vim-localrc"
NeoBundle "thinca/vim-quickrun"
NeoBundle "thinca/vim-qfreplace"
" NeoBundle "scrooloose/nerdtree"
NeoBundle "kana/vim-fakeclip"
NeoBundle "fuenor/qfixhowm"
NeoBundle "fuenor/qfixgrep"
" NeoBundle "sjl/gundo.vim"
NeoBundle "tomtom/tcomment_vim"
NeoBundle "scrooloose/syntastic"
NeoBundle "Lokaltog/vim-powerline"
NeoBundle "mattn/gist-vim"
NeoBundle "mattn/webapi-vim"
NeoBundle 'glidenote/memolist.vim'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'tyru/open-browser-github.vim'
NeoBundle 'rking/ag.vim'
" NeoBundle "scottstvnsn/autoclose.vim"
" NeoBundle "kakkyz81/evervim"
" NeoBundle "taglist.vim"
NeoBundle "ref.vim"
NeoBundle "lepture/vim-jinja"
NeoBundle 'taichouchou2/vim-endwise.git'
" NeoBundle "Source-Explorer-srcexpl.vim"
NeoBundle 'osyo-manga/vim-over'
" NeoBundle "vim-scripts/YankRing.vim"
NeoBundle 'LeafCage/yankround.vim'
NeoBundle 'tpope/vim-fugitive'

NeoBundle "mattn/emmet-vim"
NeoBundle "othree/html5.vim"
NeoBundle "tmhedberg/matchit"
" NeoBundle "ruby-matchit"
NeoBundle "surround.vim"
NeoBundle 'str2numchar.vim'
" NeoBundle "vim-scripts/css.vim"
NeoBundle "hail2u/vim-css3-syntax"
" NeoBundle "css_color.vim"
NeoBundle "cakebaker/scss-syntax.vim"
NeoBundle "aklt/plantuml-syntax"

" Markdown
NeoBundle 'Markdown'
NeoBundle 'suan/vim-instant-markdown'

" Swift
NeoBundle 'toyamarinyon/vim-swift'

" Ruby
" NeoBundle "tpope/vim-rails"

" Python
" NeoBundle "lambdalisue/vim-python-virtualenv"
" NeoBundle "mitechie/pyflakes-pathogen"

" js
NeoBundle 'JavaScript-syntax'
NeoBundle 'itspriddle/vim-javascript-indent'

" CoffeeScript
NeoBundle 'kchmck/vim-coffee-script'

" Golang
NeoBundle 'fatih/vim-go'

" Slim
NeoBundle 'slim-template/vim-slim'

" Color Scheme
NeoBundle "altercation/vim-colors-solarized"

" Unite {{{
    " 入力モードで開始
    let g:unite_enable_start_insert=1
    " バッファ一覧
    nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
    " ファイル一覧
    nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
    " レジスタ一覧
    nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
    " 最近使用したファイル一覧
    nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
    " 常用セット
    nnoremap <silent> ,uu :<C-u>Unite buffer file_mru<CR>
    " 全部乗せ
    nnoremap <silent> ,ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
    " ウィンドウを分割して開く
    au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
    au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
    " ウィンドウを縦に分割して開く
    au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
    au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
    " ESCキーを2回押すと終了
    au FileType unite nnoremap <silent> <buffer> <ESC><ESC> q
    au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>q
" }}}

" endwise {{{
    let g:endwise_no_mappings=1
" }}}

" quickrun {{{
    let g:quickrun_config = {}
    let g:quickrun_config['coffee'] = {'command' : 'coffee', 'exec' : ['%c -cbp %s']}
    " see http://vim-users.jp/2011/09/hack230/
    let g:quickrun_config['markdown'] = {'outputter': 'browser'}
    let g:quickrun_config['swift'] = {
                \ 'command': '/Applications/Xcode-Beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift',
                \ 'cmdopt': '-target x86_64-apple-macosx10.9 -sdk /Applications/Xcode-Beta.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk',
                \ 'exec': '%c %o %s',
                \ }
" }}}

" taglist {{{
    set tags+=~/.tags
    let Tlist_Ctags_Cmd = "/usr/bin/ctags"
    let Tlist_Show_One_File = 1 " 現在編集中のソースのタグしか表示しない
    let Tlist_Exit_OnlyWindow = 1 " taglistのウィンドーが最後のウィンドーならばVimを閉じる
    let Tlist_Use_Right_Window = 1 " 右側でtaglistのウィンドーを表示
    let g:tlist_php_settings = 'php;c:class;d:constant;f:function' " 表示する項目
    map <silent> <leader>tl :TlistToggle<cr> " taglistを開くショットカットキー
" }}}

" SourceExplorer {{{
    let g:SrcExpl_RefreshTime = 1
    let g:SrcExpl_UpdateTags = 1
    let g:SrcExpl_RefreshMapKey = "<Space>"
    let g:SrcExpl_GoBackMapKey = "<C-b>"
    nmap <F8> :SrcExplToggle<CR>
" }}}

" vim-colors-solarized {{{
    syntax enable
    set background=dark
    " colorscheme solarized
" }}}

" NERDTree {{{
	" 引数無しで vim を開いたら NERDTree 起動
	" let file_name = expand("%")
	" if has('vim_starting') &&  file_name == ""
    " 	autocmd VimEnter * NERDTree ./
	" endif
	"
    " nnoremap <Space>tr :<C-u>NERDTreeToggle<Enter>
    " let NERDTreeShowHidden = 1
" }}}

" Powerline {{{
    let g:Powerline_symbols = 'fancy'
" }}}

" syntastic {{{
    let g:syntastic_enable_signs=1
    let g:syntastic_auto_loc_list=2
    let g:syntastic_enable_perl_checker = 1
    let g:syntastic_perl_checkers = ['perl', 'podchecker']
    let g:syntastic_mode_map = { 'mode': 'active',
                               \ 'passive_filetypes': ['css'] }
" }}}

" QFixHowm {{{
    " qfixappにruntimepathを通す(パスは環境に合わせてください)
    set runtimepath+=~/.vim/qfixhowm/
    " キーマップリーダー
    let QFixHowm_Key = 'g'
    " howm_dirはファイルを保存したいディレクトリを設定
    let howm_dir             = '~/howm'
    let howm_filename        = '%Y/%m/%Y-%m-%d-%H%M%S.txt'
    let howm_fileencoding    = 'utf-8'
    let howm_fileformat      = 'unix'
" }}}

" surround.vim {{{
    "for surround.vim
    " [key map]
    " 1 : <h1>|</h1>
    " 2 : <h2>|</h2>
    " 3 : <h3>|</h3>
    " 4 : <h4>|</h4>
    " 5 : <h5>|</h5>
    " 6 : <h6>|</h6>
    "
    " p : <p>|</p>
    " u : <ul>|</ul>
    " o : <ol>|</ol>
    " l : <li>|</li>
    " a : <a href="">|</a>
    " A : <a href="|"></a>
    " i : <img src="|" alt="" />
    " I : <img src="" alt"|" />
    " d : <div>|</div>
    " D : <div class="section">|</div>

    autocmd FileType html let b:surround_49  = "<h1>\r</h1>"
    autocmd FileType html let b:surround_50  = "<h2>\r</h2>"
    autocmd FileType html let b:surround_51  = "<h3>\r</h3>"
    autocmd FileType html let b:surround_52  = "<h4>\r</h4>"
    autocmd FileType html let b:surround_53  = "<h5>\r</h5>"
    autocmd FileType html let b:surround_54  = "<h6>\r</h6>"
    autocmd FileType html let b:surround_112 = "<p>\r</p>"
	autocmd FileType html let b:surround_117 = "<ul>\r</ul>"
	autocmd FileType html let b:surround_111 = "<ol>\r</ol>"
	autocmd FileType html let b:surround_108 = "<li>\r</li>"
	autocmd FileType html let b:surround_97  = "<a href=\"\">\r</a>"
	autocmd FileType html let b:surround_65  = "<a href=\"\r\"></a>"
	autocmd FileType html let b:surround_105 = "<img src=\"\r\" alt=\"\" />"
	autocmd FileType html let b:surround_73  = "<img src=\"\" alt=\"\r\" />"
	autocmd FileType html let b:surround_100 = "<div>\r</div>"
" }}}

" neocomplete {{{
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    " Use neocomplete.
    let g:neocomplete#enable_at_startup = 1
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = {
        \ 'default' : '',
        \ 'vimshell' : $HOME.'/.vimshell_hist',
        \ 'scheme' : $HOME.'/.gosh_completions'
            \ }

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " Plugin key-mappings.
    inoremap <expr><C-g>     neocomplete#undo_completion()
    inoremap <expr><C-l>     neocomplete#complete_common_string()

    " Recommended key-mappings.
    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
      return neocomplete#close_popup() . "\<CR>"
      " For no inserting <CR> key.
      "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
    endfunction
    " <TAB>: completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y>  neocomplete#close_popup()
    inoremap <expr><C-e>  neocomplete#cancel_popup()
    " Close popup by <Space>.
    "inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

    " Enable omni completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
      let g:neocomplete#sources#omni#input_patterns = {}
    endif
    "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

    " For perlomni.vim setting.
    " https://github.com/c9s/perlomni.vim
    let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
" }}}

" neosnippet {{{
    " Plugin key-mappings.
    imap <C-k>     <Plug>(neosnippet_expand_or_jump)
    smap <C-k>     <Plug>(neosnippet_expand_or_jump)
    xmap <C-k>     <Plug>(neosnippet_expand_target)

    " SuperTab like snippets behavior.
    imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)"
    \: pumvisible() ? "\<C-n>" : "\<TAB>"
    smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)"
    \: "\<TAB>"

    " For snippet_complete marker.
    if has('conceal')
      set conceallevel=2 concealcursor=i
    endif
" }}}

" str2numchar.vim {{{
	vmap <silent> sn :Str2NumChar<CR> 
	vmap <silent> sh :Str2HexLiteral<CR> 
" }}}

" memolist {{{
    let g:memolist_qfixgrep = 1
    let g:memolist_path = "~/Dropbox/memolist"
    map <Leader>ml  :MemoList<CR>
    map <Leader>mn  :MemoNew<CR>
    map <Leader>mg  :MemoGrep<CR>
" }}}

" ctrlp {{{
    set runtimepath^=~/.vim/ctrlp.vim
    let g:ctrlp_map = '<C-p><C-o>'
    let g:ctrlp_cmd = 'CtrlP'
    helptags ~/.vim/bundle/ctrlp.vim/doc
" }}}

"" over.vim {{{
    " over.vimの起動
    nnoremap <silent> <Leader>m :OverCommandLine<CR>
    " カーソル下の単語をハイライト付きで置換
    nnoremap sub :OverCommandLine<CR>%s/<C-r><C-w>//g<Left><Left>
    " コピーした文字列をハイライト付きで置換
    nnoremap subp y:OverCommandLine<CR>%s!<C-r>=substitute(@0, '!', '\\!', 'g')<CR>!!gI<Left><Left><Left>
" }}}

" yankround.vim {{{
    nmap p <Plug>(yankround-p)
    nmap P <Plug>(yankround-P)
    nmap <C-p> <Plug>(yankround-prev)
    nmap <C-n> <Plug>(yankround-next)
    let g:yankround_max_history = 50
    nnoremap <silent>g<C-p> :<C-u>CtrlPYankRound<CR>
" }}}

" open-github-files {{{
    map <Leader>ogf :OpenGithubFile<CR>
" }}}

"-----------------------------------------------------
"  FILETYPE
"-----------------------------------------------------
filetype plugin indent on


"-----------------------------------------------------
"  表示系設定
"-----------------------------------------------------
set autoindent                 " インデント
set backspace=indent,eol,start " BSでなんでも消せるように
set cmdheight=2                " コマンドラインの高さ(GUI使用時)
"set cursorline                 " カーソル行を強調表示
set t_Co=256                   " カーソルライン用色設定
hi CursorLine   term=reverse cterm=none ctermbg=242 " カーソルライン反転
set display=lastline
set expandtab                  " タブ入力がスペースに変換 :retab でタブ・スペースの変換
set formatoptions+=mM          " 整形オプションにマルチバイト系を追加
set laststatus=2               " ステータスラインを常に表示
set list                       " 不過視文字表示
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
set softtabstop=0              " <Tab>キーを押した時に挿入される空白の量
set tabstop=4                  " タブスペース数設定
set title                      " タイトルをウィンドウ枠に表示
set whichwrap=b,s,[,],<,>
set wildmenu
" ステータスラインに文字コードと改行文字を表示する
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" 特殊文字(SpecialKey)の見える化。listcharsはlcsでも設定可能。trailは行末スペース。
set list
set listchars=tab:>.,trail:_,nbsp:%,extends:>,precedes:<
highlight SpecialKey term=underline ctermfg=darkgray guifg=darkgray

" シンタックスハイライトを有効にする
if has("syntax")
    syntax on
endif

" ポップアップカラー
hi Pmenu ctermbg=grey guibg=darkgray
hi PmenuSel ctermbg=yellow guibg=brown guifg=white
hi PmenuSbar ctermbg=yellow guibg=black

" 入力モード時、ステータスラインのカラーを変更
augroup InsertHook
    autocmd!
    autocmd InsertEnter * highlight StatusLine ctermfg=Blue ctermbg=LightYellow guifg=#2E4340 guibg=#ccdc90
    autocmd InsertLeave * highlight StatusLine ctermfg=black ctermbg=LightGrey guifg=black guibg=#c2bfa5
augroup END

" カーソル行をハイライト（重い）
"highlight CursorLine guibg=lightblue ctermbg=lightgray ctermfg=blue


"-----------------------------------------------------
"  検索系設定
"-----------------------------------------------------
set hlsearch                 " 検索結果文字列のハイライトを有効にする
set incsearch                " インクリメンタルサーチ
set ignorecase  			 " 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set smartcase  				 " 検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan   				 " 検索時に最後まで行ったら最初に戻る
set noincsearch				 " 検索文字列入力時に順次対象文字列にヒットさせない
set grepprg=pt


"-----------------------------------------------------
"  編集系設定
"-----------------------------------------------------
"yankした文字列をクリップボードに追加
set clipboard=unnamed,autoselect

"crontab 対策
set backupskip=/tmp/*,/private/tmp/*

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

"-----------------------------------------------------
"  HTML (and more template engine)
"-----------------------------------------------------
autocmd FileType html set noexpandtab
au BufNewFile,BufRead *.html   set tabstop=8 expandtab shiftwidth=4 softtabstop=4
au BufNewFile,BufRead *.rhtml  set tabstop=4 expandtab shiftwidth=2 softtabstop=2
au BufNewFile,BufRead *.erb    set tabstop=4 expandtab shiftwidth=2 softtabstop=2
au BufNewFile,BufRead *.haml   set tabstop=4 expandtab shiftwidth=2 softtabstop=2
au BufNewFile,BufRead *.slim   set tabstop=4 expandtab shiftwidth=2 softtabstop=2

"-----------------------------------------------------
"  CoffeeScript
"-----------------------------------------------------
au BufNewFile,BufReadPost *.coffee setl tabstop=2 shiftwidth=2 expandtab softtabstop=2

"-----------------------------------------------------
"  PHP
"-----------------------------------------------------
autocmd FileType php  :set dictionary=~/.vim/dict/php.dict

"-----------------------------------------------------
"  Ruby
"-----------------------------------------------------
autocmd FileType ruby setl autoindent
autocmd FileType ruby setl smartindent cinwords=if,elsif,else,unless,for,while,begin,rescue,module,def,class
autocmd FileType ruby setl tabstop=4 expandtab shiftwidth=2 softtabstop=2

"-----------------------------------------------------
"  Python
"-----------------------------------------------------
autocmd FileType python let g:pydiction_location = '~/.vim/pydiction/complete-dict'
autocmd FileType python setl autoindent
autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setl tabstop=8 expandtab shiftwidth=4 softtabstop=4

"-----------------------------------------------------
" pyflakes syntax-color setting
"-----------------------------------------------------
if has("gui_running")
    highlight SpellBad term=underline gui=undercurl guisp=Orange
endif

"-----------------------------------------------------
" Python 実行設定 <C-P>
"-----------------------------------------------------
function! s:ExecPy()
    exe "!" . &ft . " %"
:endfunction
command! Exec call <SID>ExecPy()
autocmd FileType python map <silent> <C-P> :call <SID>ExecPy()<CR>

"-----------------------------------------------------
" PecoOpen
"-----------------------------------------------------
function! PecoOpen()
  for filename in split(system("find . -type f | peco"), "\n")
    execute "e" filename
  endfor
endfunction
nnoremap <Leader>op :call PecoOpen()<CR>

"-----------------------------------------------------
" REMAP
"-----------------------------------------------------
nnoremap <Space>. :<C-u>edit $MYVIMRC<Enter>
nnoremap <Space>s. :<C-u>source $MYVIMRC<Enter>
nnoremap <Space>j <C-f>
nnoremap <Space>k <C-b>
nnoremap <Space>w :<C-u>set ff=dos fenc=shift_jis<Enter>
nnoremap <Space>u :<C-u>set ff=unix fenc=utf-8<Enter>
nnoremap <Space>t :<C-u>tabnew<Enter>
nnoremap <Space>h :<C-u>tabp<Enter>
nnoremap <Space>l :<C-u>tabn<Enter>
nnoremap <Esc><Esc> :<C-u>nohlsearch<Enter>
nnoremap 0 :<C-u>call append(expand('.'), '')<Cr>j " 空行を挿入
noremap <C-o> :!open -a "Google Chrome" %<CR>   " 現在開いているファイルを Chrome で開く

" Align 整形
let g:Align_xstrlen = 3
vmap <Space>s <Leader>tsp
smap <Space>s <Leader>tsp
vmap <Space>a : Align
smap <Space>a : Align

"フレームサイズを怠惰に変更する
map <kPlus> <C-W>+
map <kMinus> <C-W>-


"-----------------------------------------------------
" Taglist
"-----------------------------------------------------
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


"-----------------------------------------------------
" Open Link Browser
"-----------------------------------------------------
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


"-----------------------------------------------------
" Link Browser
"-----------------------------------------------------
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


"-----------------------------------------------------
" OMNI Mapping
"-----------------------------------------------------
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


"-----------------------------------------------------
" OMNI FUNC
"-----------------------------------------------------
" 注意: この内容は:filetype onよりも後に記述すること。
autocmd FileType *
\   if &l:omnifunc == ''
\ |   setlocal omnifunc=syntaxcomplete#Complete
\ | endif


"-----------------------------------------------------
" for Windows
"-----------------------------------------------------
" WINDOWS
if has('win32')
    set guifont=VL_Gothic:h10:cSHIFTJIS       " フォント
    set printoptions=wrap:y,number:y,header:0 " 印刷
    set printfont=VL_Gothic:h10:cSHIFTJIS     " 印刷時のフォント
endif
