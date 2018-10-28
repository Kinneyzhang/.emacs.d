(add-to-list 'package-archives '("gnu" . "http://elpa.emacs-china.org/gnu/") t)
(add-to-list 'package-archives '("melpa" . "http://elpa.emacs-china.org/melpa/") t)

;;"some better defaults"
(setq inhibit-startup-message t)
(setq ring-bell-function 'ignore);;消除滑动到底部或顶部时的声音
(global-auto-revert-mode t);;自动加载更新内容
(setq make-backup-files nil);;不允许备份
(setq auto-save-default nil);;不允许自动保存
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(add-hook 'prog-mode-hook 'linum-mode);;显示行号
(add-hook 'emacs-lisp-mode-hook 'show-paren-mode);;括号匹配
(setq scroll-step 1 scroll-margin 3 scroll-conservatively 10000)
(fset 'yes-or-no-p 'y-or-n-p);;用y/s 代替yes/no

(setq dired-recursive-deletes 'always)
(setq dired-recursive-copies 'always);;全部递归拷贝删除文件夹中的文件

(put 'dired-find-alternate-file 'disabled nil);;避免每一级目录都产生一个buffer
(require 'dired-x)
(setq dired-dwim-target t)

;;let emacs could find the exe
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;;Highlight parens when inside it
(define-advice show-paren-function (:around (fn) fix-show-paren-function)
  "Highlight enclosing parens."
  (cond ((looking-at-p "\\s(") (funcall fn))
	(t (save-excursion
	     (ignore-errors (backward-up-list))
	     (funcall fn)))))

;;indent buffer
(defun indent-buffer()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun indent-region-or-buffer()
  (interactive)
  (save-excursion
    (if (region-active-p)
	(progn
	  (indent-region (region-beginning) (region-end))
	  (message "Indent selected region."))
      (progn
	(indent-buffer)
	(message "Indent buffer.")))))

;;better code company
(setq hippie-expand-try-function-list '(try-expand-debbrev
					try-expand-debbrev-all-buffers
					try-expand-debbrev-from-kill
					try-complete-file-name-partially
					try-complete-file-name
					try-expand-all-abbrevs
					try-expand-list
					try-expand-line
					try-complete-lisp-symbol-partially
					try-complete-lisp-symbol))

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode t)
(set-default-font "-*-Monaco-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")
(global-hl-line-mode t);;光标行高亮
(setq inhibit-splash-screen t);取消默认启动窗口
(setq-default cursor-type 'bar);变光标, setq-default设置全局
(setq initial-frame-alist (quote ((fullscreen . maximized))));;启动最大化窗口
;;设置窗口位置为屏库左上角(0,0)
;;(set-frame-position (selected-frame) 160 70)
;;设置宽和高
;;(set-frame-width (selected-frame) 140)
;;(set-frame-height (selected-frame) 45)

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(use-package org-pomodoro
  :ensure t)

(setq org-src-fontify-natively t)
(setq org-agenda-files '("~/org"))

;;启动时加载org-agenda
;; (add-hook 'after-init-hook 'org-agenda-list)

(setq org-capture-templates 'myconfig)
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/gtd.org" "Tasks")
	 "* TODO [#B] %?\n  %i\n"
	 :empty-lines 1)
	("j" "Journal" entry (file+datetree "~/org/journal.org")
	 "* %?\nEntered on %U\n %i\n")
	))

(defun org-insert-src-block (src-code-type)
  "Insert a `SRC-CODE-TYPE' type source code block in org-mode."
  (interactive
   (let ((src-code-types
	  '("emacs-lisp" "python" "C" "sh" "java" "js" "clojure" "C++" "css"
	    "calc" "asymptote" "dot" "gnuplot" "ledger" "lilypond" "mscgen"
	    "octave" "oz" "plantuml" "R" "sass" "screen" "sql" "awk" "ditaa"
	    "haskell" "latex" "lisp" "matlab" "ocaml" "org" "perl" "ruby"
	    "scheme" "sqlite")))
     (list (ido-completing-read "Source code type: " src-code-types))))
  (progn
    (newline-and-indent)
    (insert (format "#+BEGIN_SRC %s\n" src-code-type))
    (newline-and-indent)
    (insert "#+END_SRC\n")
    (previous-line 2)
    (org-edit-src-code)))

(add-hook 'org-mode-hook '(lambda ()
			    ;; turn on flyspell-mode by default
			    (flyspell-mode 1)
			    ;; C-TAB for expanding
			    (local-set-key (kbd "C-<tab>")
					   'yas/expand-from-trigger-key)
			    ;; keybinding for editing source code blocks
			    (local-set-key (kbd "C-c s e")
					   'org-edit-src-code)
			    ;; keybinding for inserting code blocks
			    (local-set-key (kbd "C-c s i")
					   'org-insert-src-block)
			    ))

;;设置换行
(setq truncate-lines t)
(defun my-org-mode ()
  (setq truncate-lines nil)
  )
(add-hook 'org-mode-hook 'my-org-mode)

(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 3)

  (global-company-mode t)
  )

(use-package company-irony
  :ensure t
  :config 
  (add-to-list 'company-backends 'company-irony)
  )

(use-package irony
  :ensure t
  :config
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
  )

(use-package irony-eldoc
  :ensure t
  :config
  (add-hook 'irony-mode-hook #'irony-eldoc))

(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))

(add-hook 'python-mode-hook 'my/python-mode-hook)
(use-package company-jedi
  :ensure t
  :config
  (add-hook 'python-mode-hook 'jedi:setup)
  )

(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))

(add-hook 'python-mode-hook 'my/python-mode-hook)

;;; company box mode
;;(use-package company-box
;;:ensure t
;;:hook (company-mode . company-box-mode))

(use-package web-mode
  :ensure t
  :config
  (add-hook 'web-mode-hook 'my-web-mode-indent-setup)
  (add-hook 'web-mode-hook 'my-toggle-web-indent))

(defun my-web-mode-indent-setup ()
  (setq web-mode-markup-indent-offset 2) ; web-mode, html tag in html file
  (setq web-mode-css-indent-offset 2)    ; web-mode, css in html file
  (setq web-mode-code-indent-offset 2)   ; web-mode, js code in html file
  )

;;change indent style
(defun my-toggle-web-indent ()
  (interactive)
  ;; web development
  (if (or (eq major-mode 'js-mode) (eq major-mode 'js2-mode))
      (progn
	(setq js-indent-level (if (= js-indent-level 2) 4 2))
	(setq js2-basic-offset (if (= js2-basic-offset 2) 4 2))))

  (if (eq major-mode 'web-mode)
      (progn (setq web-mode-markup-indent-offset (if (= web-mode-markup-indent-offset 2) 4 2))
	     (setq web-mode-css-indent-offset (if (= web-mode-css-indent-offset 2) 4 2))
	     (setq web-mode-code-indent-offset (if (= web-mode-code-indent-offset 2) 4 2))))
  (if (eq major-mode 'css-mode)
      (setq css-indent-offset (if (= css-indent-offset 2) 4 2)))

  (setq indent-tabs-mode nil))

(use-package ggtags
  :ensure t 
  :config 
  (add-hook 'c-mode-common-hook
	    (lambda ()
	      (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
		(ggtags-mode 1)))))

;;config for c++ indent
(defun vlad-cc-style()
  (c-set-style "linux")
  (c-set-offset 'innamespace '0)
  (c-set-offset 'inextern-lang '0)
  (c-set-offset 'inline-open '0)
  (c-set-offset 'label '*)
  (c-set-offset 'case-label '*)
  ;; (c-set-offset 'access-label '/)
  (setq c-basic-offset 4)
  (setq tab-width 4)
  (setq indent-tabs-mode nil)
  )
(add-hook 'c++-mode-hook 'vlad-cc-style)
(add-hook 'c-mode-hook 'vlad-cc-style)

(use-package evil
  :ensure t
  :config 
  (evil-mode 1))

(use-package evil-leader
  :ensure t
  :config
  (global-evil-leader-mode t)
  (evil-leader/set-key
    "ff" 'find-file
    "fr" 'sr-speedbar-open
    "fe" 'sr-speedbar-close

    "bb" 'switch-to-buffer
    "1"  'select-window-1
    "2"  'select-window-2
    "3"  'select-window-3
    "4"  'select-window-4
    "w/" 'split-window-right
    "w-" 'split-window-below
    "wd" 'delete-window
    "wj" 'other-window
    "ww" 'delete-other-windows

    "em" 'open-my-packages-manage-file
    "ei" 'open-my-init-file
    "ec" 'open-my-init-custom-file

    "<SPC>"  'counsel-M-x
    "cc"  'org-capture
    "aa" 'org-agenda
    "as" 'org-agenda-schedule
    "ad" 'org-agenda-deadline
    "az" 'org-agenda-add-note

    "osi" 'org-insert-src-block
    "ose" 'org-edit-src-code
    "oo" 'org-open-at-point

    "ee" 'eval-last-sexp
    "q" 'save-buffers-kill-terminal
    "pf" 'counsel-git
    "t" 'shell-pop
    "/" 'evilnc-comment-or-uncomment-lines
    "d" 'dired
    "j" 'goto-line
    "hk" 'describe-key
    "hv" 'counsel-describe-variable
    "hf" 'counsel-describe-function

    "ss" 'save-buffer
    "sw" 'swiper
    "snc" 'aya-create
    "sne" 'aya-expand
    "snp" 'aya-persist-snippet

    "cg" 'customize-group
    "cf" 'customize-face
    "v" 'er/expand-region
    ))

(evilnc-default-hotkeys)
(define-key evil-normal-state-map (kbd ",/") 'evilnc-comment-or-uncomment-lines)
(define-key evil-visual-state-map (kbd ",/") 'evilnc-comment-or-uncomment-lines)

(use-package yasnippet
  :ensure t
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook #'yas-minor-mode))

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package color-theme
  :ensure t)

(use-package color-theme-sanityinc-tomorrow
  :ensure t)

(use-package shell-pop
  :ensure t
  :bind (("C-t" . shell-pop))
  :config
  (setq shell-pop-shell-type (quote ("ehell" "eshell" (lambda nil (eshell)))))
  (setq shell-pop-term-shell "eshell")
  ;; (setq shell-pop-universal-key "C-t")
  (setq shell-pop-window-size 40)
  (setq shell-pop-full-span t)
  (setq shell-pop-window-position "right")

  ;; need to do this manually or not picked up by shell-pop
  (shell-pop--set-shell-type 'shell-pop-shell-type shell-pop-shell-type))

(use-package smartparens
  :ensure t
  :config
  (sp-local-pair 'emacs-lisp-mode "'" nil :actions nil))

(use-package hungry-delete
  :ensure t
  :config
  (global-hungry-delete-mode))

(use-package flycheck
  :ensure t
  :config
  (add-hook 'c++-mode-hook 'flycheck-mode)
  (add-hook 'python-mode-hook 'flycheck-mode)
  (add-hook 'js2-mode-hook 'flycheck-mode)
  (add-hook 'java-mode-hook 'flycheck-mode)
  (add-hook 'web-mode-hook 'flycheck-mode))

(use-package swiper
  :ensure t
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t))

(use-package js2-mode
  :ensure t
  :config
  ;;js2-mode config for jsfiles    
  (setq auto-mode-alist
	(append
	 '(("\\.js\\'" . js2-mode)
	   ("\\.html\\'" . web-mode)
	   )
	 auto-mode-alist)))

  ;;config for js2's imenu, 列出所有函数
  (defun js2-imenu-make-index ()
    (interactive)
    (save-excursion
      ;; (setq imenu-generic-expression '((nil "describe\\(\"\\(.+\\)\"" 1)))
      (imenu--generic-function '(("describe" "\\s-*describe\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
				 ("it" "\\s-*it\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
				 ("test" "\\s-*test\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
				 ("before" "\\s-*before\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
				 ("after" "\\s-*after\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
				 ("Function" "function[ \t]+\\([a-zA-Z0-9_$.]+\\)[ \t]*(" 1)
				 ("Function" "^[ \t]*\\([a-zA-Z0-9_$.]+\\)[ \t]*=[ \t]*function[ \t]*(" 1)
				 ("Function" "^var[ \t]*\\([a-zA-Z0-9_$.]+\\)[ \t]*=[ \t]*function[ \t]*(" 1)
				 ("Function" "^[ \t]*\\([a-zA-Z0-9_$.]+\\)[ \t]*()[ \t]*{" 1)
				 ("Function" "^[ \t]*\\([a-zA-Z0-9_$.]+\\)[ \t]*:[ \t]*function[ \t]*(" 1)
				 ("Task" "[. \t]task([ \t]*['\"]\\([^'\"]+\\)" 1)))))
  (add-hook 'js2-mode-hook
	     (lambda ()
	       (setq imenu-create-index-function 'js2-imenu-make-index)))
  (global-set-key (kbd "M-s i") 'counsel-imenu)

  (use-package js2-refactor
    :ensure t
    :config
    (add-hook 'js2-mode-hook #'js2-refactor-mode)
    (js2r-add-keybindings-with-prefix "C-c C-m"))

(use-package popwin
  :ensure t)

(use-package window-numbering
  :ensure t
  :config
  (window-numbering-mode 1)
  (setq window-numbering-assign-func
	(lambda () (when (equal (buffer-name) "*Calculator*") 9))))

(use-package ccls
  :ensure t)

(global-set-key (kbd "<f5>") 'revert-buffer)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "C-h f") 'counsel-describe-function)
(global-set-key (kbd "C-h v") 'counsel-describe-variable)

(global-set-key (kbd "C-h C-f") 'find-function)
(global-set-key (kbd "C-h C-v") 'find-variable)
(global-set-key (kbd "C-h C-k") 'find-fuction-on-key)

(global-set-key "\C-x\ \C-r" 'recentf-open-files)

(global-set-key (kbd "<f1>") 'open-my-init-file)
(global-set-key (kbd "<f2>") 'open-my-packages-file)

;;(global-set-key (kbd "C-c p f") 'counsel-git);;从默认git仓库中查找文件

(global-set-key (kbd "C-c a") 'org-agenda)

;; 设置C->键作为窗口之间的切换，默认的是C-x-o,比较麻烦 
(global-set-key (kbd "C-.") 'other-window)

;; 把C-j绑定到到达指定行上 
(global-set-key (kbd "C-j") 'goto-line)

;;设置M-/作为标志位，默认C-@来setmark,C-@不太好用 
;;M-/本来对应zap-to-char，这里占用了
(global-set-key (kbd "M-/") 'set-mark-command)

(global-set-key (kbd "C-M-\\") 'indent-region-or-buffer);;代码缩进

(global-set-key (kbd "s-/") 'hippie-expand);;补全功能

;; 延迟加载
(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file))

;;切换web-mode下默认tab空格数
(global-set-key (kbd "C-c t i") 'my-toggle-web-indent)

;;标记后智能选中区域
(global-set-key (kbd "C-=") 'er/expand-region)

(global-set-key (kbd "M-p") 'my-org-screenshot)

(defun open-my-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(defun open-my-config-file()
  (interactive)
  (find-file "~/.emacs.d/myconfig.org"))

(defun open-my-packages-manage-file()
  (interactive)
  (find-file "~/.emacs.d/lisp/packages-manage.el"))

(defun open-my-init-custom-file()
  (interactive)
  (find-file "~/.emacs.d/lisp/init-custom.el"))
