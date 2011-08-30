;;-------------------------------------------------------------------------
;; load-path を追加する関数を定義
;;-------------------------------------------------------------------------
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;;-------------------------------------------------------------------------
;; elispとconfディレクトリをサブディレクトリごと load-path に追加
;;-------------------------------------------------------------------------
(add-to-load-path "elisp" "conf" "elisp/apel" "elisp/emu" "elisp/color-theme-6.6.0")

;;-------------------------------------------------------------------------
;; カラーテーマ
;;-------------------------------------------------------------------------
(when (require 'color-theme nil t)
  (color-theme-initialize))
(load "color-theme")
(color-theme-clarity)

;;-------------------------------------------------------------------------
;; 表示回り
;;-------------------------------------------------------------------------
;; ツール類非表示
(setq inhibit-startup-screen t)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(menu-bar-mode 0)
;; メニューバーへファイルパス表示
(setq frame-title-format
  (format "%%f - Emacs@%s" (system-name)))
;; 括弧強調
(setq show-paren-delay 0)
(show-paren-mode t)
(setq show-paren-style 'expression)
(set-face-background 'show-paren-match-face nil)
(set-face-underline-p 'show-paren-match-face "yellow")
;; 行番号
(global-linum-mode)
;; 透過設定
(modify-frame-parameters nil (list (cons 'alpha 85)))
(defun modify-frame-alpha (arg)
    (interactive "Nalpha parameter: ")
    (modify-frame-parameters nil (list (cons 'alpha arg))))


;;-------------------------------------------------------------------------
;; インデント
;;-------------------------------------------------------------------------
(setq js-indent-level 4)
;;(setq-default indent-tabs-mode nil)

;;-------------------------------------------------------------------------
;; Mac環境設定
;;-------------------------------------------------------------------------
(set-language-environment "Japanese")
(require 'ucs-normalize)
(prefer-coding-system 'utf-8-hfs)
(setq file-name-coding-system 'utf-8-hfs)
(setq locale-coding-system 'utf-8-hfs)

;;-------------------------------------------------------------------------
;; wdired
;;-------------------------------------------------------------------------
(require 'wdired)
(define-key dired-mode-map "r"
  'wdired-change-to-wdired-mode)

;;-------------------------------------------------------------------------
;; auto-complete
;; (http://cx4a.org/software/auto-complete/index.ja.html)
;;-------------------------------------------------------------------------
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories
    "~/.emacs.d/elisp/ac-dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default))

;;-------------------------------------------------------------------------
;; Elscreen
;; (http://www.morishima.net/~naoto/software/elscreen/index.php.ja)
;;-------------------------------------------------------------------------
(when (require 'elscreen nil t)
  (if window-system
      (define-key elscreen-map (kbd "C-z")
        'iconify-or-deiconify-frame)
    (define-key elscreen-map (kbd "C-z")
      'suspend-emacs)))

;;-------------------------------------------------------------------------
;; auto-install
;; (install-elisp "http://www.emacswiki.org/emacs/download/auto-install.el")
;;-------------------------------------------------------------------------
(when (require 'auto-install nil t)
  ;; インストールディレクトリを設定する　初期値は ~/.emacs.d/auto-install/
  (setq auto-install-directory "~/.emacs.d/elisp/")
  ;; EmacsWiki に登録されている elisp の名前を取得する
  (auto-install-update-emacswiki-package-name t)
  ;; 必要であればプロキシの設定を行う
  ;; (setq url-proxy-services '(("http" . "localhost:8339")))
  ;; install-elisp の関数を利用可能にする
  (auto-install-compatibility-setup))

;;-------------------------------------------------------------------------
;; smartchr
;; (install-elisp "http://github.com/imakado/emacs-smartchr/raw/master/smartchr.el")
;;-------------------------------------------------------------------------
(when (require 'smartchr nil t)
  (define-key global-map
    (kbd "=") (smartchr '("=" " = " " == " " === "))))

;;-------------------------------------------------------------------------
;; Redo 
;; (install-elisp "http://www.emacswiki.org/emacs/download/redo+.el")
;;-------------------------------------------------------------------------
(when (require 'redo+ nil t)
  ;; global-map
  (global-set-key (kbd "C-'") 'redo)) ;C-' にredoを割り当てる
(put 'upcase-region 'disabled nil)

;;-------------------------------------------------------------------------
;; undohist 
;; (install-elisp "http://cx4a.org/pub/undolist.el")
;;-------------------------------------------------------------------------
(when (require 'undolist nil t)
  (undolist-initialize))

;;-------------------------------------------------------------------------
;; undo-tree
;; (install-elisp "http://www.dr-qubit.org/undo-tree/undo-tree.el")
;;-------------------------------------------------------------------------
(when (require 'undo-tree nil t)
  (global-undo-tree-mode))

;;-------------------------------------------------------------------------
;; point-undo
;; (install-elisp "http://www.emacswiki.org/cgi-bin/wiki/download/point-undo.el")
;;-------------------------------------------------------------------------
(when (require 'point-undo nil t)
  (define-key global-map [f6] 'point-undo)
  (define-key global-map [f7] 'point-redo))

;;-------------------------------------------------------------------------
;; color-moccur, moccur-edit
;; (install-elisp "http://www.emacswiki.org/emacs/download/color-moccur.el")
;; (install-elisp "http://www.emacswiki.org/emacs/download/moccur-edit.el")
;;-------------------------------------------------------------------------
(when (require 'color-moccur nil t)
  ;; global-map に occur-by-moccur を割り当て
  (define-key global-map (kbd "M-o") 'occur-by-moccur)
  ;; スペース区切りでAND検索
  (setq moccur-split-word t)
  ;; ディレクトリ検索の時除外するファイル
  (add-to-list 'dmoccur-exclusion-mask "\\.DS_Store")
  (add-to-list 'dmoccur-exclusion-mask "^#.+#$")
  (require 'moccur-edit nil t)
  ;; Migemo を利用できる環境であれば Migemo 利用
  (when (and (executable-find "cmigemo")
             (require 'migemo nil t))
    (setq moccur-use-migemo t))
  )
  ;; 編集終了時保存
  (defadvice moccur-edit-change-file
    (after save-after-moccur-edit-buffer activate)
    (save-buffer))

;;-------------------------------------------------------------------------
;; grep-edit
;; (install-elisp "http://www.emacswiki.org/emacs/download/grep-edit.el")
;;-------------------------------------------------------------------------
(require 'grep-edit)

;;-------------------------------------------------------------------------
;; Migemo
;; @see. http://wun.jp/emacs/cmigemo/ 
;;-------------------------------------------------------------------------
(require 'migemo)
(setq migemo-command "cmigemo")
(setq migemo-options '("-q" "--emacs"))
(setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")
;; cmigemoで必須の設定
(setq migemo-user-dictionary nil)
(setq migemo-regex-dictionary nil)
(setq migemo-coding-system 'utf-8-unix)
;; Migemo起動
(load-library "migemo")
(migemo-init)

;;-------------------------------------------------------------------------
;; egg (Emacs Got Git)
;; (http://github.com/byplayer/egg/raw/master/egg.el) 
;;-------------------------------------------------------------------------
(when (executable-find "git")
  (require 'egg nil t))

;;-------------------------------------------------------------------------
;; multi-term
;; (http://www.emacswiki.org/emacs/download/multi-term.el) 
;;-------------------------------------------------------------------------
(when (require 'multi-term nil t)
  (setq multi-term-program "/bin/zsh"))

;;-------------------------------------------------------------------------
;; カーソル移動加速 
;; @see. http://www.bookshelf.jp/soft/meadow_31.html#SEC427 
;;-------------------------------------------------------------------------
;; 10 回ごとに加速
(defvar scroll-speedup-count 10)
;; 10 回下カーソルを入力すると，次からは 1+1 で 2 行ずつの
;; 移動になる
(defvar scroll-speedup-rate 1)
;; 800ms 経過したら通常のスクロールに戻す
(defvar scroll-speedup-time 800)

;; 以下，内部変数
(defvar scroll-step-default 1)
(defvar scroll-step-count 1)
(defvar scroll-speedup-zero (current-time))

(defun scroll-speedup-setspeed ()
  (let* ((now (current-time))
         (min (- (car now)
                 (car scroll-speedup-zero)))
         (sec (- (car (cdr now))
                 (car (cdr scroll-speedup-zero))))
         (msec
          (/ (- (car (cdr (cdr now)))
                (car
                 (cdr (cdr scroll-speedup-zero))))
                     1000))
         (lag
          (+ (* 60000 min)
             (* 1000 sec) msec)))
    (if (> lag scroll-speedup-time)
        (progn
          (setq scroll-step-default 1)
          (setq scroll-step-count 1))
      (setq scroll-step-count
            (+ 1 scroll-step-count)))
    (setq scroll-speedup-zero (current-time))))

(defun scroll-speedup-next-line (arg)
  (if (= (% scroll-step-count
            scroll-speedup-count) 0)
      (setq scroll-step-default
            (+ scroll-speedup-rate
               scroll-step-default)))
  (if (string= arg 'next)
      (line-move scroll-step-default)
    (line-move (* -1 scroll-step-default))))

(defadvice next-line
  (around next-line-speedup activate)
  (if (and (string= last-command 'next-line)
           (interactive-p))
      (progn
        (scroll-speedup-setspeed)
        (condition-case err
            (scroll-speedup-next-line 'next)
          (error
           (if (and
                next-line-add-newlines
                (save-excursion
                  (end-of-line) (eobp)))
               (let ((abbrev-mode nil))
                 (end-of-line)
                 (insert "\n"))
             (line-move 1)))))
    (setq scroll-step-default 1)
    (setq scroll-step-count 1)
    ad-do-it))

(defadvice previous-line
  (around previous-line-speedup activate)
  (if (and
       (string= last-command 'previous-line)
       (interactive-p))
      (progn
        (scroll-speedup-setspeed)
        (scroll-speedup-next-line 'previous))
    (setq scroll-step-default 1)
    (setq scroll-step-count 1)
    ad-do-it))

;;-------------------------------------------------------------------------
;; Anything 
;; (auto-install-batch 'anything')
;;-------------------------------------------------------------------------
(when (require 'anything nil t)
  (setq
    ;; 候補を表示するまでの時間 デフォルト0.5
    anything-idle-delay 0.3
    ;; タイプして再描画するまでの時間 デフォルト0.1
    anything-input-idle-delay 0.2
    ;; 候補の最大表示数 デフォルト50
    anything-candidate-number-limit 100
    ;; 候補が多い時に体感速度を早くする
    anything-quick-update t
    ;; 候補選択ショートカットをアルファベットに
    anything-enable-shortcuts 'alphabet)

  (when (require 'anything-config nil t)
    ;; root権限でアクションを実行する時のコマンド デフォルトsu
    (setq anything-su-or-sudo "sudo"))

  (require 'anything-match-plugin nil t)
  (and (equal current-language-environment "Japanese")
       (executable-find "cmigemo")
       (require 'anything-migemo nil t))
  (when (require 'anything-complete nil t)
    ;; M-x による補完をAnythingで行う
    ;; (anything-read-string-mode 1)
    ;; lispシンボルの補完候補の再検索時間
    (anything-lisp-complete-symbol-set-timer 150))

  (require 'anything-show-completion nil t)

  (when (require 'descbinds-anything nil t)
    ;; describe-bindingsをAnythingに置き換える
    (descbinds-anything-install))

  (require 'anything-grep nil t))

;; anything-for-document (man & info search)
(setq anything-for-document-sources
  (list
   anything-c-source-man-pages
   anything-c-source-info-cl
   anything-c-source-info-pages
   anything-c-source-info-elisp
   anything-c-source-apropos-emacs-commands
   anything-c-source-apropos-emacs-functions
   anything-c-source-apropos-emacs-variables))

(defun anything-for-document ()
  "Preconfigured `anything' for anything-for-document."
  (interactive)
  (anything anything-for-document-sources
    (thing-at-point 'symbol) nil nil nil
    "*anything for document*"))
(define-key global-map (kbd "s-d") 'anything-for-document)

;;-------------------------------------------------------------------------
;; flymake-jsl 
;;-------------------------------------------------------------------------
(defun js-mode-hooks ()
  ;; キーマップをセット
  (setq flymake-jsl-mode-map 'js-mode-map)
  ;; flymake-jslを起動するための設定
  (when (require 'flymake-jsl nil t)
  (setq flymake-check-was-interrupted t)
  (flymake-mode t)))
;; js-modeの起動時にhookを追加
(add-hook 'js-mode-hook 'js-mode-hooks)

;;-------------------------------------------------------------------------
;; Aspell 
;;------------------------------------------------------------------------- 
;;; ispellをより高機能なaspellに置き換える  
(setq-default ispell-program-name "aspell")
;;; 日本語ファイル中のスペルチェックを可能にする
(eval-after-load "ispell"
  '(add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))

;;-------------------------------------------------------------------------
;; Flyspell 
;;-------------------------------------------------------------------------   
;; FlySpellの逐次スペルチェックを使用するモードの指定  
(defun my-flyspell-mode-enable ()  
  (flyspell-mode 1))  
(mapc  
 (lambda (hook)  
   (add-hook hook 'my-flyspell-mode-enable))  
 '(  
   changelog-mode-hook  
   text-mode-hook  
   latex-mode-hook  
   )  
 )  
;; Flyspellの逐次スペルチェックをコメントにのみ使用するモード  
;; (コメントかどうかの判断は各モードによる)  
(mapc  
 (lambda (hook)  
   (add-hook hook 'flyspell-prog-mode))  
 '(  
   c-mode-common-hook  
   emacs-lisp-mode-hook  
   )  
 )

;; エラーのフェイス
;;(set-face-background 'flymake-errline "orange red")
;;(set-face-foreground 'flymake-errline "black")
;; 警告のフェイス
;;(set-face-background 'flymake-warnline "yellow")
;;(set-face-foreground 'flymake-warnline "black")

;;-------------------------------------------------------------------------
;; coffee-mode 
;;-------------------------------------------------------------------------   
(add-to-list 'load-path "~/.emacs.d/coffee-mode")
(require 'coffee-mode)
(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(add-to-list 'auto-mode-alist '("Cakefile" . coffee-mode))
