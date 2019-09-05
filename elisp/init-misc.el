(use-package darkroom
  :ensure t
  :defer t
  :bind (("C-c d" . darkroom-tentative-mode)))

;; (defun my/dark-mode ()
;;   (interactive)
;;   (set-window-margins (selected-window) 40 40))


(use-package org-download
  :ensure t
  :defer 5
  :init (setq-default org-download-image-dir "~/Pictures/org")
  :config
  (add-hook 'dired-mode-hook 'org-download-enable))

(use-package grab-mac-link
  :load-path "~/.emacs.d/site-lisp/grab-mac-link"
  :bind (("C-c l g" . grab-mac-link)))

(use-package snails
  :load-path "~/.emacs.d/site-lisp/snails"
  :bind (("<f4>" . snails)))

(use-package auto-save
  :load-path "~/.emacs.d/site-lisp/auto-save"
  :config 
  (auto-save-enable)  ;; 开启自动保存功能。
  (setq auto-save-slient t)) ;; 自动保存的时候静悄悄的， 不要打扰我

(use-package company-english-helper
  :load-path "~/.emacs.d/site-lisp/company-english-helper"
  :defer t
  :bind (("C-x c e" . toggle-company-english-helper)))

(use-package awesome-pair
  :load-path "~/.emacs.d/site-lisp/awesome-pair"
  :config
  (dolist (hook (list
		 'c-mode-common-hook
		 'c-mode-hook
		 'c++-mode-hook
		 'java-mode-hook
		 'haskell-mode-hook
		 'emacs-lisp-mode-hook
		 'lisp-interaction-mode-hook
		 'lisp-mode-hook
		 'maxima-mode-hook
		 'ielm-mode-hook
		 'sh-mode-hook
		 'makefile-gmake-mode-hook
		 'php-mode-hook
		 'python-mode-hook
		 'js-mode-hook
		 'go-mode-hook
		 'qml-mode-hook
		 'jade-mode-hook
		 'css-mode-hook
		 'ruby-mode-hook
		 'coffee-mode-hook
		 'rust-mode-hook
		 'qmake-mode-hook
		 'lua-mode-hook
		 'swift-mode-hook
		 'minibuffer-inactive-mode-hook
		 ))
    (add-hook hook '(lambda () (awesome-pair-mode 1))))

  (define-key awesome-pair-mode-map (kbd "(") 'awesome-pair-open-round)
  (define-key awesome-pair-mode-map (kbd "[") 'awesome-pair-open-bracket)
  (define-key awesome-pair-mode-map (kbd "{") 'awesome-pair-open-curly)
  (define-key awesome-pair-mode-map (kbd ")") 'awesome-pair-close-round)
  (define-key awesome-pair-mode-map (kbd "]") 'awesome-pair-close-bracket)
  (define-key awesome-pair-mode-map (kbd "}") 'awesome-pair-close-curly)

  (define-key awesome-pair-mode-map (kbd "%") 'awesome-pair-match-paren)
  (define-key awesome-pair-mode-map (kbd "\"") 'awesome-pair-double-quote)

  ;;(define-key awesome-pair-mode-map (kbd "M-o") 'awesome-pair-backward-delete)
  ;;(define-key awesome-pair-mode-map (kbd "C-d") 'awesome-pair-forward-delete)
  (define-key awesome-pair-mode-map (kbd "C-k") 'awesome-pair-kill)

  (define-key awesome-pair-mode-map (kbd "M-\"") 'awesome-pair-wrap-double-quote)
  (define-key awesome-pair-mode-map (kbd "M-[") 'awesome-pair-wrap-bracket)
  (define-key awesome-pair-mode-map (kbd "M-{") 'awesome-pair-wrap-curly)
  (define-key awesome-pair-mode-map (kbd "M-(") 'awesome-pair-wrap-round)
  (define-key awesome-pair-mode-map (kbd "M-)") 'awesoMe-pair-unwrap)

  (define-key awesome-pair-mode-map (kbd "M-p") 'awesome-pair-jump-right)
  (define-key awesome-pair-mode-map (kbd "M-n") 'awesome-pair-jump-left)
  (define-key awesome-pair-mode-map (kbd "M-:") 'awesome-pair-jump-out-pair-and-newline))


(defun print-symbol-τ ()
  "print to"
  (interactive)
  (insert "τ"))
(global-set-key (kbd "C-c s t o") 'print-symbol-τ)

(defun print-symbol-∂ ()
  "print round"
  (interactive)
  (insert "∂"))
(global-set-key (kbd "C-c s r d") 'print-symbol-∂)

(defun print-symbol-∮ ()
  "print qjf"
  (interactive)
  (insert "∮")∮)
(global-set-key (kbd "C-c s q j f") 'print-symbol-∮)

(defun print-symbol-ρ ()
  "print ru"
  (interactive)
  (insert "ρ"))
(global-set-key (kbd "C-c s r u") 'print-symbol-ρ)

(defun print-symbol-± ()
  "print plus and minus"
  (interactive)
  (insert "±"))
(global-set-key (kbd "C-c s p m") 'print-symbol-±)

(defun print-symbol-⊥ ()
  "print perpendicular to"
  (interactive)
  (insert "⊥"))
(global-set-key (kbd "C-c s p t") 'print-symbol-⊥)

(defun print-symbol-ʃ ()
  "print jifen"
  (interactive)
  (insert "ʃ"))
(global-set-key (kbd "C-c s j f") 'print-symbol-ʃ)

(defun print-symbol-≥ ()
  "print more and equal"
  (interactive)
  (insert "≥"))
(global-set-key (kbd "C-c s m e") 'print-symbol-≥)

(defun print-symbol-≤ ()
  "print less and equal"
  (interactive)
  (insert "≤"))
(global-set-key (kbd "C-c s l e") 'print-symbol-≤)

(defun print-symbol-≠ ()
  "print Inequality"
  (interactive)
  (insert "≠"))
(global-set-key (kbd "C-c s i e") 'print-symbol-≠)

(defun print-symbol-∃ ()
  "print existence"
  (interactive)
  (insert "∃"))
(global-set-key (kbd "C-c s e x") 'print-symbol-∃)

(defun print-symbol-∀ ()
  "print Arbitrary"
  (interactive)
  (insert "∀"))
(global-set-key (kbd "C-c s a b") 'print-symbol-∀)

(defun print-symbol-⊆ ()
  "print contained"
  (interactive)
  (insert "⊆"))
(global-set-key (kbd "C-c s c t") 'print-symbol-⊆)

(defun print-symbol-∈ ()
  "print Belong"
  (interactive)
  (insert "∈"))
(global-set-key (kbd "C-c s b l") 'print-symbol-∈)

(defun print-symbol-∞ ()
  "print Infinit"
  (interactive)
  (insert "∞"))
(global-set-key (kbd "C-c s i f") 'print-symbol-∞)

(defun print-symbol-ξ ()
  "print ksi"
  (interactive)
  (insert "ξ"))
(global-set-key (kbd "C-c s k s") 'print-symbol-ξ)

(defun print-symbol-η ()
  "print eta"
  (interactive)
  (insert "η"))
(global-set-key (kbd "C-c s e t") 'print-symbol-η)

(defun print-symbol-ε ()
  "print Epsilon"
  (interactive)
  (insert "ε"))
(global-set-key (kbd "C-c s e p") 'print-symbol-ε)

(defun print-symbol-α ()
  "print Alpha"
  (interactive)
  (insert "α"))
(global-set-key (kbd "C-c s a p") 'print-symbol-α)

(defun print-symbol-β ()
  "print Beta"
  (interactive)
  (insert "β"))
(global-set-key (kbd "C-c s b t") 'print-symbol-β)

(defun print-symbol-γ ()
  "print Gamma"
  (interactive)
  (insert "γ"))
(global-set-key (kbd "C-c s g m") 'print-symbol-γ)

(defun print-symbol-λ ()
  "print lambda"
  (interactive)
  (insert "λ"))
(global-set-key (kbd "C-c s l d") 'print-symbol-λ)

(defun print-symbol-θ ()
  "print Theta"
  (interactive)
  (insert "θ"))
(global-set-key (kbd "C-c s t t") 'print-symbol-θ)

(defun print-symbol-ζ ()
  "print Zeta"
  (interactive)
  (insert "ζ"))
(global-set-key (kbd "C-c s z t") 'print-symbol-ζ)

(defun print-symbol-Δ ()
  "print Delte"
  (interactive)
  (insert "Δ"))
(global-set-key (kbd "C-c s d t") 'print-symbol-Δ)

(defun print-symbol-μ ()
  "print Mu"
  (interactive)
  (insert "μ"))
(global-set-key (kbd "C-c s m u ") 'print-symbol-μ)

(defun print-symbol-π ()
  "print Pi"
  (interactive)
  (insert "π"))
(global-set-key (kbd "C-c s p i") 'print-symbol-π)

(defun print-symbol-σ ()
  "print Sigma"
  (interactive)
  (insert "σ"))
(global-set-key (kbd "C-c s s m") 'print-symbol-σ)

(defun print-symbol-Σ ()
  "print upper Sigma"
  (interactive)
  (insert "Σ"))
(global-set-key (kbd "C-c s u s m") 'print-symbol-Σ)

(defun print-symbol-ρ ()
  "print Rho"
  (interactive)
  (insert "ρ"))
(global-set-key (kbd "C-c s r h") 'print-symbol-ρ)

(defun print-symbol-ψ ()
  "print Psi"
  (interactive)
  (insert "ψ"))
(global-set-key (kbd "C-c s p s") 'print-symbol-ψ)

(defun print-symbol-φ ()
  "print Phi"
  (interactive)
  (insert "φ"))
(global-set-key (kbd "C-c s p h") 'print-symbol-φ)

(defun print-symbol-Φ ()
  "print upper Phi"
  (interactive)
  (insert "Φ"))
(global-set-key (kbd "C-c s u p h") 'print-symbol-Φ)

(defun print-symbol-ω ()
  "print lower Omiga"
  (interactive)
  (insert "ω"))
(global-set-key (kbd "C-c s l o g") 'print-symbol-ω)

(defun print-symbol-Ω ()
  "print upper Omiga"
  (interactive)
  (insert "Ω"))
(global-set-key (kbd "C-c s u o g") 'print-symbol-Ω)

;;=================================================================
(defun print-symbol-● ()
  (interactive)
  (insert "●"))
(global-set-key (kbd "C-c s s d") 'print-symbol-●) ;;solid dot

(defun print-symbol-○ ()
  (interactive)
  (insert "○"))
(global-set-key (kbd "C-c s h d") 'print-symbol-○) ;;hollow dot

(defun print-symbol-× ()
  (interactive)
  (insert "×"))
(global-set-key (kbd "C-c s c h") 'print-symbol-×) ;;cross

(defun print-symbol-★ ()
  (interactive)
  (insert "★"))
(global-set-key (kbd "C-c s 1") 'print-symbol-★)

(defun print-symbol-√ ()
  (interactive)
  (insert "√"))
(global-set-key (kbd "C-c s g h") 'print-symbol-√)

(use-package furl
  :ensure t
  :defer 5)

(use-package graphql
  :ensure t
  :defer 5)

(use-package leetcode
  :load-path "~/.emacs.d/site-lisp/leetcode"
  :defer t
  :init (setq leetcode-account "kinneyzhang666@gmail.com"))

(defun chunyang-scratch-save ()
  (ignore-errors
    (with-current-buffer "*scratch*"
      (write-region nil nil "~/.emacs.d/var/scratch"))))

(defun chunyang-scratch-restore ()
  (let ((f "~/.emacs.d/var/scratch"))
    (when (file-exists-p f)
      (with-current-buffer "*scratch*"
	(erase-buffer)
	(insert-file-contents f)))))

(add-hook 'kill-emacs-hook #'chunyang-scratch-save)
(add-hook 'after-init-hook #'chunyang-scratch-restore)

(use-package delete-block
  :load-path "~/.emacs.d/site-lisp/delete-block"
  :defer 5
  :bind (("C-d" . delete-block-forward)
	 ("<C-backspace>" . delete-block-backward)))

(global-set-key (kbd "C-x -") 'split-window-below)
(global-set-key (kbd "C-x /") 'split-window-right)

(global-set-key (kbd "<f5>") 'revert-buffer)

;; ================================================
(global-set-key (kbd "C-x <f10>") 'eval-last-sexp)

(global-set-key (kbd "C-c y s c") 'aya-create)
(global-set-key (kbd "C-c y s p") 'aya-persist-snippet)
(global-set-key (kbd "C-c y s e") 'aya-expand)

;; customize group and face
(global-set-key (kbd "C-x c g") 'customize-group)
(global-set-key (kbd "C-x c f") 'customize-face)
(global-set-key (kbd "C-x c t") 'customize-themes)



(global-set-key (kbd "C-c C-/") 'comment-or-uncomment-region)

(global-set-key (kbd "M-\/") 'set-mark-command)

;;代码缩进
(add-hook 'prog-mode-hook '(lambda ()
			     (local-set-key (kbd "C-M-\\")
					    'indent-region-or-buffer)))

;; 延迟加载
(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file))

;;标记后智能选中区域
(global-set-key (kbd "C-=") 'er/expand-region)


(defun open-my-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(defun open-my-misc-file()
  (interactive)
  (find-file "~/.emacs.d/elisp/init-misc.el"))

(global-set-key (kbd "<f1>") 'open-my-init-file)

(use-package magit
  :defer t
  :ensure t
  :bind (("C-x g" . magit-status)))

(use-package company
  :ensure t
  :defer 5
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 3)
  (global-company-mode t))

(use-package company-box
  :defer 5
  :ensure t
  :init (setq company-box-icons-alist 'company-box-icons-all-the-icons)
  :hook (company-mode . company-box-mode))

(use-package yasnippet
  :ensure t
  :defer t
  :init (setq yas-snippet-dirs
	      '("~/.emacs.d/snippets"))
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook #'yas-minor-mode))

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package smartparens
  :ensure t
  :config
  (electric-pair-mode t)
  (sp-local-pair 'emacs-lisp-mode "'" nil :actions nil))

(use-package paredit
  ;; check if the parens is matched
  :ensure t
  :defer t)

(use-package hungry-delete
  :defer 5
  :ensure t
  :config
  (global-hungry-delete-mode))

(use-package flycheck
  :ensure t
  :defer 5
  :init
  (progn
    (define-fringe-bitmap 'my-flycheck-fringe-indicator
      (vector #b00000000
	      #b00000000
	      #b00000000
	      #b00000000
	      #b00000000
	      #b00000000
	      #b00000000
	      #b00011100
	      #b00111110
	      #b00111110
	      #b00111110
	      #b00011100
	      #b00000000
	      #b00000000
	      #b00000000
	      #b00000000
	      #b00000000))

    (flycheck-define-error-level 'error
      :severity 2
      :overlay-category 'flycheck-error-overlay
      :fringe-bitmap 'my-flycheck-fringe-indicator
      :fringe-face 'flycheck-fringe-error)

    (flycheck-define-error-level 'warning
      :severity 1
      :overlay-category 'flycheck-warning-overlay
      :fringe-bitmap 'my-flycheck-fringe-indicator
      :fringe-face 'flycheck-fringe-warning)

    (flycheck-define-error-level 'info
      :severity 0
      :overlay-category 'flycheck-info-overlay
      :fringe-bitmap 'my-flycheck-fringe-indicator
      :fringe-face 'flycheck-fringe-info))

  :config
  (add-hook 'c++-mode-hook 'flycheck-mode)
  (add-hook 'python-mode-hook 'flycheck-mode)
  (add-hook 'js2-mode-hook 'flycheck-mode)
  (add-hook 'java-mode-hook 'flycheck-mode)
  (add-hook 'web-mode-hook 'flycheck-mode))

(use-package dashboard
  :ensure t
  :init
  (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
  (setq dashboard-banner-logo-title "Happy hacking emacs!  [Author:Kinney] [Github:https://github.com/Kinneyzhang/.emacs.d.git]")
  (setq dashboard-startup-banner "~/.emacs.d/img/ying.png")
  (setq dashboard-items '((recents  . 8) (projects . 5)))
  :config
  (dashboard-setup-startup-hook))

(use-package youdao-dictionary
  :ensure t
  :defer 5
  ;; :bind (("C-c y y" . youdao-dictionary-search-at-point)
  ;; 	 ("C-c y i" . youdao-dictionary-search-from-input))
  :init
  (setq url-automatic-caching t))

(use-package osx-dictionary
  :ensure t
  :bind (("C-c y y" . osx-dictionary-search-word-at-point)
	 ("C-c y i" . osx-dictionary-search-input))
  )

;;use xwidget-webkit
;; (setq browse-url-browser-function 'xwidget-webkit-browse-url)
;; (defun browse-url-default-browser (url &rest args)
;;   "Override `browse-url-default-browser' to use `xwidget-webkit' URL ARGS."
;;   (xwidget-webkit-browse-url url args))
;; (global-set-key (kbd "C-c w c") 'xwidget-webkit-copy-selection-as-kill)

(use-package search-web
  :defer t
  :ensure t
  :init
  (setq search-web-engines
	'(("Google" "http://www.google.com/search?q=%s" nil)
	  ("Youtube" "http://www.youtube.com/results?search_query=%s" nil)
	  ("Stackoveflow" "http://stackoverflow.com/search?q=%s" nil)
	  ("Sogou" "https://www.sogou.com/web?query=%s" nil)
	  ("Github" "https://github.com/search?q=%s" nil)
	  ("Melpa" "https://melpa.org/#/?q=%s" nil)
	  ("Emacs-China" "https://emacs-china.org/search?q=%s" nil)
	  ("EmacsWiki" "https://www.emacswiki.org/emacs/%s" nil)
	  ("Wiki-zh" "https://zh.wikipedia.org/wiki/%s" nil)
	  ("Wiki-en" "https://en.wikipedia.org/wiki/%s" nil)
	  ))
  :bind (("C-C w u" . browse-url)
	 ("C-c w w" . search-web)
	 ("C-c w p" . search-web-at-point)
	 ("C-c w r" . search-web-region)))

(use-package browse-at-remote
  :ensure t
  :bind ("C-c w g" . browse-at-remote))


;; (use-package lsp-python-ms
;;   :ensure t
;;   :defer 5
;;   :hook (python-mode . lsp)
;;   :config

;;   ;; for dev build of language server
;;   (setq lsp-python-ms-dir
;; 	(expand-file-name "~/python-language-server/output/bin/Release/"))
;;   ;; for executable of language server, if it's not symlinked on your PATH
;;   (setq lsp-python-ms-executable
;; 	"~/python-language-server/output/bin/Release/osx-x64/publish/Microsoft.Python.LanguageServer"))


;; markdown and preview

(use-package markdown-mode
  :ensure t
  :defer 5
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode))
  :init
  (setq markdown-command "markdown_py"))

(use-package markdown-preview-mode
  :ensure t
  :bind (("C-c C-c ." . markdown-preview-mode))
  :init
  (setq markdown-preview-stylesheets
	(list "https://blog.geekinney.com/static/css/github-markdown.css"
	      "~/.emacs.d/config-file/extra-css/extra-mardown.css")))

(use-package proxy-mode
  :ensure t
  :defer 5
  :init
  (setq proxy-mode-socks-proxy '("geekinney.com" "124.156.188.197" 10808 5))
  (setq url-gateway-local-host-regexp
      (concat "\\`" (regexp-opt '("localhost" "127.0.0.1")) "\\'")))

(use-package helpful
  :ensure t
  :defer 5
  :pretty-hydra
  ((:color teal :quit-key "q")
   ("Helpful"
    (("f" helpful-callable "callable")
     ("v" helpful-variable "variable")
     ("k" helpful-key "key")
     ("c" helpful-command "command")
     ("d" helpful-at-point "thing at point"))))
  :bind ("C-h" . helpful-hydra/body))

;; (use-package helpful
;;   :ensure t
;;   :defer 5
;;   :bind (("C-h f" . helpful-callable)
;; 	 ("C-h v" . helpful-variable)
;; 	 ("C-h k" . helpful-key)
;; 	 ("C-c C-d" . helpful-at-point)
;; 	 ("C-h F". helpful-function)
;; 	 ("C-h C" . helpful-command)))

(use-package django-mode
  :ensure t)

(use-package undo-tree
  :diminish undo-tree-mode
  :config
  (progn
    (global-undo-tree-mode)
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t)))

(use-package exec-path-from-shell
  :defer 5
  :if (memq window-system '(ns mac))
  :ensure t
  :config
  (setq exec-path-from-shell-arguments '("-l"))
  (exec-path-from-shell-initialize))

(use-package plain-org-wiki
  :load-path "~/.emacs.d/site-lisp/plain-org-wiki"
  :init (setq pow-directory "~/org"))


;;;==================================================
(use-package company-tabnine
  :ensure t
  :init ;; Trigger completion immediately.
  (setq company-idle-delay 0)

  ;; Number the candidates (use M-1, M-2 etc to select completions).
  (setq company-show-numbers t)

  ;; Use the tab-and-go frontend.
  ;; Allows TAB to select and complete at the same time.
  (company-tng-configure-default)
  (setq company-frontends
	'(company-tng-frontend
          company-pseudo-tooltip-frontend
          company-echo-metadata-frontend))
  :config (add-to-list 'company-backends #'company-tabnine)
  (company-tabnine nil))

;; The free version of TabNine is good enough,
;; and below code is recommended that TabNine not always
;; prompt me to purchase a paid version in a large project.
(defadvice company-echo-show (around disable-tabnine-upgrade-message activate)
  (let ((company-message-func (ad-get-arg 0)))
    (when (and company-message-func
               (stringp (funcall company-message-func)))
      (unless (string-match "The free version of TabNine only indexes up to" (funcall company-message-func))
        ad-do-it))))

(defun maple/mac-switch-input-source ()
  (shell-command
   "osascript -e 'tell application \"System Events\" to tell process \"SystemUIServer\"
      set currentLayout to get the value of the first menu bar item of menu bar 1 whose description is \"text input\"
      if currentLayout is not \"ABC\" then
        tell (1st menu bar item of menu bar 1 whose description is \"text input\") to {click, click (menu 1'\"'\"'s menu item \"ABC\")}
      end if
    end tell' &>/dev/null"))

;; (run-with-idle-timer 10 t (maple/mac-switch-input-source))
;;;==================================================

(defun insert-current-date () 
  "Insert the current time" 
  (interactive "*")
  (insert (format-time-string "%B %d, %Y" (current-time))))

(global-set-key "\C-xt" 'insert-current-date)

;;==============================

;; (use-package openwith
;;   :ensure t
;;   :config
;;   (setq openwith-associations
;;         (cond
;;          ((string-equal system-type "darwin")
;;           '(("\\.\\(dmg\\|doc\\|docs\\|xls\\|xlsx\\)$"
;;              "open" (file))
;;             ("\\.\\(mp4\\|mp3\\|webm\\|avi\\|flv\\|mov\\)$"
;;              "mplayer" ("-a" "VLC" file))))
;;          ((string-equal system-type "gnu/linux")
;;           '(("\\.\\(mp4\\|mp3\\|webm\\|avi\\|flv\\|mov\\)$"
;;              "xdg-open" (file))))))
;;   (openwith-mode +1))

(provide 'init-misc)
