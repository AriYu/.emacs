(add-to-list 'load-path "~/.emacs.d/lisp")
(add-to-list 'load-path "~/.emacs.d/elpa")
;;; platfrom-p(http://ongaeshi.hatenablog.com/entry/20120725/1343232098)
(require 'platform-p)

;;; カッコのハイライト
(show-paren-mode t)

;;; 行番号の表示
(require 'linum)
(global-linum-mode)

;;; スクロール時のカーソル位置の維持
(setq scroll-preserve-screen-position t)

;;; スクロール行数（一行ごとのスクロール）
(setq vertical-centering-font-regexp ".*")
(setq scroll-conservatively 35)
(setq scroll-margin 0)
(setq scroll-step 1)

;;; 画面スクロール時の重複行数
(setq next-screen-context-lines 1)

;;; 起動メッセージの非表示
(setq inhibit-startup-message t)

;;; スタートアップ時のエコー領域メッセージの非表示
(setq inhibit-startup-echo-area-message -1)

;;; @ backup
;;; 変更ファイルのバックアップ
(setq make-backup-files nil)

;;; 変更ファイルの番号つきバックアップ
(setq version-control nil)

;;; 編集中ファイルのバックアップ
(setq auto-save-list-file-name nil)
(setq auto-save-list-file-prefix nil)

;;; 編集中ファイルのバックアップ先
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;;; 編集中ファイルのバックアップ間隔（秒）
(setq auto-save-timeout 30)

;;; 編集中ファイルのバックアップ間隔（打鍵）
(setq auto-save-interval 500)

;;;バックアップ世代数
(setq kept-old-versions 1)
(setq kept-new-versions 2)

;;; 上書き時の警告表示
;;; (setq trim-versions-without-asking nil)

;;; 古いバックアップファイルの削除
(setq delete-old-versions t)


;; smooth-scroll
(require 'smooth-scroll)
(smooth-scroll-mode t)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;;; one line at at time
(setq mouse-wheel-progressive-speed nil) ;;; dont accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;;; scroll window under mouse

;; theme
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("05c3bc4eb1219953a4f182e10de1f7466d28987f48d647c01f1f0037ff35ab9a" default)))
 '(flycheck-display-errors-function (function flycheck-pos-tip-error-messages))
 '(show-paren-mode t)
 '(tab-width 4)
 '(tool-bar-mode nil)
 '(tool-bar-position (quote bottom)))

;; font
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Ricty for Powerline" :foundry "unknown" :slant normal :weight normal :height 128 :width normal)))))

;;;YaTexの設定
(setq auto-mode-alist
      (cons (cons "\\.tex$" 'yatex-mode)  auto-mode-alist))
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
(setq load-path (cons (expand-file-name "~/.emacs.d/site-lisp/yatex") load-path))
(setq YaTeX-inhibit-prefix-letter t)
(setq YaTeX-kanji-code nil)
(setq YaTeX-latex-message-code 'utf-8)

;;;(setq tex-command "latexmk -pvc")  ;;保存したら自動で再コンパイル
;; 強制コンパイル
(setq tex-command "latexmk -f") 
(setq dvi2-command "evince")

;; Yatexの自動改行をなしにする．
(add-hook 'yatex-mode-hook
		  '(lambda () (auto-fill-mode -1)))

(when platform-linux-p ; for GNU/Linux
;;; inverse search
  (require 'dbus)
  
  (defun un-urlify (fname-or-url)
	"A trivial function that replaces a prefix of file:/// with just /."
	(if (string= (substring fname-or-url 0 8) "file:///")
		(substring fname-or-url 7)
	  fname-or-url))
  
  (defun evince-inverse-search (file linecol &rest ignored)
	(let* ((fname (un-urlify file))
		   (buf (find-file fname))
		   (line (car linecol))
		   (col (cadr linecol)))
	  (if (null buf)
		  (message "[Synctex]: %s is not opened..." fname)
		(switch-to-buffer buf)
		(goto-line (car linecol))
		(unless (= col -1)
		  (move-to-column col)))))
  
  (dbus-register-signal
   :session nil "/org/gnome/evince/Window/0"
   "org.gnome.evince.Window" "SyncSource"
   'evince-inverse-search)
  )

;;; auto-install
(add-to-list 'load-path (expand-file-name "~/.emacs.d/auto-install/"))
;; (require 'auto-install)
;; (auto-install-update-emacswiki-package-name t)
;; (auto-install-compatibility-setup)

;;; popwin
(require 'popwin)
(popwin-mode 1)
;;; popwin(for yatex)
(require 'popwin-yatex)
(push '("*YaTeX-typesetting*") popwin:special-display-config)

;;; MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;; 指定したディレクトリでM-xをやる 
(defun in-directory (dir)
  "Runs execute-extended-command with default-directory set to the given directory."
  (interactive "DIn directory: ")
  (let ((default-directory dir))
	(call-interactively 'execute-extended-command)))

(global-set-key (kbd "M-X") 'in-directory)

;; roslaunch highlighting
(add-to-list 'auto-mode-alist '("\\.launch$" . xml-mode))

;; shellに色をつける
;; (autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
;; (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(add-hook 'compilation-mode-hook 'ansi-color-for-comint-mode-on)
(add-hook 'compilation-filter-hook
          '(lambda ()
             (let ((start-marker (make-marker))
                   (end-marker (process-mark 
								(get-buffer-process (current-buffer)))))
               (set-marker start-marker (point-min))
               (ansi-color-apply-on-region start-marker end-marker))))

;; yatex-indent
(autoload 'latex-indent-command "~/misc/latex-indent"
  "Indent current line accroding to LaTeX block structure.")
(autoload 'latex-indent-region-command "~/misc/latex-indent"
  "Indent each line in the region according to LaTeX block structure.")
(add-hook
 'latex-mode-hook
 '(lambda ()
    (define-key tex-mode-map "\t"       'latex-indent-command)
    (define-key tex-mode-map "\M-\C-\\" 'latex-indent-region-command)))

;; elscreen.el
;;; プレフィクスキーはC-z
(setq elscreen-prefix-key (kbd "C-z"))
(elscreen-start)
;;; タブの先頭に[X]を表示しない
(setq elscreen-tab-display-kill-screen nil)
;;; header-lineの先頭に[<->]を表示しない
(setq elscreen-tab-display-control nil)
;;; バッファ名・モード名からタブに表示させる内容を決定する(デフォルト設定)
(setq elscreen-buffer-to-nickname-alist
      '(("^dired-mode$" .
         (lambda ()
           (format "Dired(%s)" dired-directory)))
        ("^Info-mode$" .
         (lambda ()
           (format "Info(%s)" (file-name-nondirectory Info-current-file))))
        ("^mew-draft-mode$" .
         (lambda ()
           (format "Mew(%s)" (buffer-name (current-buffer)))))
        ("^mew-" . "Mew")
        ("^irchat-" . "IRChat")
        ("^liece-" . "Liece")
        ("^lookup-" . "Lookup")))
(setq elscreen-mode-to-nickname-alist
      '(("[Ss]hell" . "shell")
        ("compilation" . "compile")
        ("-telnet" . "telnet")
        ("dict" . "OnlineDict")
        ("*WL:Message*" . "Wanderlust")))

;; smartparent
(smartparens-global-mode)
;; [DEL]キーもしくは[C-h]に当てられているdelete-backward-charにadviceをかけられて削除するたびにフリーズする．これを無効化.
(ad-disable-advice 'delete-backward-char 'before 'sp-delete-pair-advice)
(ad-activate 'delete-backward-char)

;; gnuplot-mode
(require 'gnuplot-mode)
(setq auto-mode-alist 
(append '(("\\.\\(gp\\|gnuplot\\|plt\\)$" . gnuplot-mode)) auto-mode-alist))

;; doc-view-modeのときに行番号を表示すると非常に重たい
(add-hook 'doc-view-mode-hook
		  (lambda ()
			(linum-mode -1)
			))
(add-hook 'pdf-view-mode-hook
		  (lambda ()
			(linum-mode -1)
			))
;; pdf-tools
(pdf-tools-install)
;;(setq revert-without-query 'yes)
(add-hook 'doc-view-mode-hook 'auto-revert-mode)

;; for ssh
(require 'tramp)
(setq tramp-default-method "scp")

;; web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[gj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(setq web-mode-engines-alist
'(("php"    . "\\.phtml\\'")
  ("blade"  . "\\.blade\\.")))
(setq web-mode-enable-current-element-highlight t)
(defun my-web-mode-hook () "Hooks for Web mode." 
  (setq web-mode-markup-indent-offset 2) 
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  ) 
(add-hook 'web-mode-hook 'my-web-mode-hook)
;;;(setq web-mode-enable-current-column-highlight t)
;;(setq web-mode-current-element-highlight-face "#0000cd")

;; magit
(global-set-key (kbd "C-x g") 'magit-status)

;; yaml-mode
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))

;; 矢印キーでウィンドウを移動できる？
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)

;; 画面の端に来たら反対側に移動する
(setq windmove-wrap-around t)

;; 別のwindowに移動するキーバインド
(global-set-key "\C-t" 'other-window)

;; fcitx.el
(require 'fcitx)
(fcitx-aggressive-setup)


;; README.mdをブラウザでチェック
(defun mkup ()
  "Markdown on Firefox"
  (interactive)
  (shell-command (concat "mkup &"))
  (shell-command (concat "firefox localhost:8000/README.md")))


;;; color-theme
;;(load-theme 'deeper-blue t)
(load-theme 'monokai t)

;; 画面の下の方を綺麗にする
(require 'powerline)
(powerline-default-theme)
(set-face-attribute 'mode-line nil
                    :foreground "White"
                    :background "DarkCyan"
                    :box nil)

;; yasnippet
(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/.emacs.d/yasnippet-snippets"
        ))
(eval-after-load "yasnippet"
  '(progn
     ;; companyと競合するのでyasnippetのフィールド移動は "C-i" のみにする
     (define-key yas-keymap (kbd "<tab>") nil)
     (yas-global-mode 1)))

;; company-mode 補完
(when (locate-library "company")
  (global-company-mode 1) ; 全バッファで有効にする
  (setq company-idle-delay 0) ; デフォルトは0.5
  (setq company-minimum-prefix-length 2) ; デフォルトは4
  (setq company-selection-wrap-around t) ; 候補の一番下でさらに下に行こうとすると一番上に戻る
  (global-set-key (kbd "C-M-i") 'company-complete)
  ;; (setq company-idle-delay nil) ; 自動補完をしない
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-search-map (kbd "C-n") 'company-select-next)
  (define-key company-search-map (kbd "C-p") 'company-select-previous)
  ;; (define-key company-active-map (kbd "<tab>") 'company-complete-selection)
  )
(defun company--insert-candidate2 (candidate)
  (when (> (length candidate) 0)
    (setq candidate (substring-no-properties candidate))
    (if (eq (company-call-backend 'ignore-case) 'keep-prefix)
        (insert (company-strip-prefix candidate))
      (if (equal company-prefix candidate)
          (company-select-next)
          (delete-region (- (point) (length company-prefix)) (point))
        (insert candidate))
      )))
(defun company-complete-common2 ()
  (interactive)
  (when (company-manual-begin)
    (if (and (not (cdr company-candidates))
             (equal company-common (car company-candidates)))
        (company-complete-selection)
      (company--insert-candidate2 company-common))))

(define-key company-active-map [tab] 'company-complete-common2)
;; (define-key company-active-map [backtab] 'company-select-previous) 

(set-face-attribute 'company-tooltip nil
                    :foreground "black" :background "lightgrey")
(set-face-attribute 'company-tooltip-common nil
                    :foreground "black" :background "lightgrey")
(set-face-attribute 'company-tooltip-common-selection nil
                    :foreground "white" :background "steelblue")
(set-face-attribute 'company-tooltip-selection nil
                    :foreground "black" :background "steelblue")
(set-face-attribute 'company-preview-common nil
                    :background nil :foreground "lightgrey" :underline t)
(set-face-attribute 'company-scrollbar-fg nil
                    :background "DarkCyan")
(set-face-attribute 'company-scrollbar-bg nil
                    :background "gray40")

;; for c++ 
(eval-after-load "irony"
  '(progn
     (custom-set-variables '(irony-additional-clang-options '("-std=c++11")))
     (add-to-list 'company-backends 'company-irony)
     (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
     (add-hook 'c-mode-common-hook 'irony-mode)))
;;; C++ style
(load-file "~/.emacs.d/elpa/google-c-style-20140929.1118/google-c-style.el")
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)

;; for python
(require 'jedi-core)
(setq jedi:complete-on-dot t)
(setq jedi:use-shortcuts t)
(add-hook 'python-mode-hook 'jedi:setup)
(add-to-list 'company-backends 'company-jedi) ; backendに追加
(add-hook 'python-mode-hook
                   '(lambda ()
                        (setq indent-tabs-mode nil)
                        (setq indent-level 4)
                        (setq python-indent 4)
                        (setq tab-width 4)))

(require 'helm-config)
(helm-mode 1)
(define-key global-map (kbd "C-x C-f") 'helm-find-files)
(define-key global-map (kbd "M-x")     'helm-M-x)
(define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
(define-key helm-read-file-map (kbd "<tab>") 'helm-execute-persistent-action)
