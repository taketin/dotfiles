;;-------------------------------------------------------------------------
;; カラーテーマ
;;-------------------------------------------------------------------------
(when (require 'color-theme nil t)
  (color-theme-initialize))

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

;;-------------------------------------------------------------------------
;; インデント
;;-------------------------------------------------------------------------
(setq js-indent-level 4)
;;(setq-default indent-tabs-mode nil)

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
;; Mac環境設定
;;-------------------------------------------------------------------------
(set-language-environment "Japanese")
(require 'ucs-normalize)
(prefer-coding-system 'utf-8-hfs)
(setq file-name-coding-system 'utf-8-hfs)
(setq locale-coding-system 'utf-8-hfs)


;;-------------------------------------------------------------------------
;; elispとconfディレクトリをサブディレクトリごと load-path に追加
;;-------------------------------------------------------------------------
(add-to-load-path "elisp" "conf")

;;-------------------------------------------------------------------------
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
;; Redo (install-elisp "http://www.emacswiki.org/emacs/download/redo+.el")
;;-------------------------------------------------------------------------
(when (require 'redo+ nil t)
  ;; global-map
  (global-set-key (kbd "C-'") 'redo)) ;C-' にredoを割り当てる
(put 'upcase-region 'disabled nil)

;;-------------------------------------------------------------------------
;; color-moccur, moccur-edit
;; (install-elisp "http://www.emacswiki.org/emacs/download/redo+.el")
;;-------------------------------------------------------------------------
(when (require 'color-moccur nil t)
  ;; global-map に occur-by-moccur を割り当て
  (global-key global-map (kbd "M-o") 'occur-by-moccur)
  ;; スペース区切りでAND検索
  (setq moccur-split-word t)
  ;; ディレクトリ検索の時除外するファイル
  (add-to-list 'dmoccur-exclusion-mask "\\.DS_Store")
  (add-to-list 'dmoccur-exclusion-mask "^#.+#$")
  (require 'moccur-edit nil t)
  ;; Migemo を利用できる環境であれば Migemo 利用
  (when (and (executable-find "cmigemo")
             (require 'migemo nil t))
    (setq moccur-use-migemo t)))
  ;; 編集終了時保存
  (defadvice moccur-edit-change-file
    (after save-after-moccur-edit-buffer activate)
    (save-buffer))

;;-------------------------------------------------------------------------
;; カーソル移動加速 @See. http://www.bookshelf.jp/soft/meadow_31.html#SEC427 
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