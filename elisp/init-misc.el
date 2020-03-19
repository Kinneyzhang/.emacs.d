(use-package pp-html
  :load-path "~/.emacs.d/site-lisp/pp-html")

(use-package pomodoro
  :load-path "~/.emacs.d/site-lisp/pomodoro"
  :init
  (setq pomodoro-work-time 25
	pomodoro-break-time 5
	pomodoro-long-break-time 15
	pomodoro-nth-for-longer-break 4
	;; pomodoro-desktop-notification nil
	pomodoro-work-cycle "work "	
	pomodoro-break-cycle "break "
	pomodoro-sound-player "mplayer"
	pomodoro-break-start-sound (expand-file-name (concat config-dir "alarm.mp3"))
	pomodoro-work-start-sound (expand-file-name (concat config-dir "alarm.mp3"))
	))

;; (use-package pomidor
;;   :bind (("<f12>" . pomidor))
;;   :config
;;   (setq pomidor-sound-tick nil
;; 	pomidor-sound-tack nil
;; 	pomidor-seconds 10;; (* 25 60)
;; 					; 25 minutes for the work period
;; 	pomidor-break-seconds 5;; (* 5 60)
;; 					; 5 minutes break time
;; 	pomidor-sound-overwork (expand-file-name (concat config-dir "alarm.mp3"))
;; 	pomidor-sound-break-over (expand-file-name (concat config-dir "alarm.mp3")))
;;   :hook
;;   (pomidor-mode . (lambda ()
;; 		    (display-line-numbers-mode -1) ; Emacs 26.1+
;; 		    (setq left-fringe-width 0 right-fringe-width 0)
;; 		    (setq left-margin-width 2 right-margin-width 0)
;; 		    ;; force fringe update
;; 		    (set-window-buffer nil (current-buffer)))))

(require 'sunshine)

(require 'alarm-clock)

(use-package symbol-overlay
  :ensure t)

(use-package color-rg
  :load-path "~/.emacs.d/site-lisp/color-rg")

(use-package ox-rss
  :load-path "~/.emacs.d/site-lisp/ox-rss")

(use-package moz-controller
  :ensure t)

(use-package w3m
  :ensure t
  :commands w3m-goto-url w3m-search
  :init
  (setq w3m-use-cookies t)
  ;; clean up the w3m buffers:
  (add-hook 'w3m-display-functions 'w3m-hide-stuff)
  (add-hook 'w3m-mode 'ace-link-mode)
  (global-set-key (kbd "C-c w m") 'w3m-goto-url)
  (global-set-key (kbd "C-c w l") 'browse-url-at-point)
  (global-set-key (kbd "C-c w s") 'w3m-search)
  :config
  (define-key w3m-mode-map (kbd "&") 'w3m-view-url-with-external-browser))

(use-package smart-comment
  :ensure t
  :bind ("M-;" . smart-comment))

(use-package tramp-term
  :ensure t)

(use-package nov
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
  (defun my-nov-font-setup ()
    (face-remap-add-relative 'variable-pitch :family "Liberation Serif"
                             :height 1.0))
  (add-hook 'nov-mode-hook 'my-nov-font-setup)
  ;; (setq nov-text-width 80)
  (setq nov-text-width t)
  (setq visual-fill-column-center-text t)
  (add-hook 'nov-mode-hook 'visual-line-mode)
  (add-hook 'nov-mode-hook 'visual-fill-column-mode)

  (with-no-warnings
    (defun my-nov-content-unique-identifier (content)
      "Return the the unique identifier for CONTENT."
      (when-let* ((name (nov-content-unique-identifier-name content))
                  (selector (format "package>metadata>identifier[id='%s']"
                                    (regexp-quote name)))
                  (id (car (esxml-node-children (esxml-query selector content)))))
        (intern id)))
    (advice-add #'nov-content-unique-identifier :override #'my-nov-content-unique-identifier))

  (use-package justify-kp
    :load-path "~/.emacs.d/site-lisp/justify-kp"
    :config
    (defun my-nov-window-configuration-change-hook ()
      (my-nov-post-html-render-hook)
      (remove-hook 'window-configuration-change-hook
  		   'my-nov-window-configuration-change-hook
  		   t))
    
    (defun my-nov-post-html-render-hook ()
      (if (get-buffer-window)
  	  (let ((max-width (pj-line-width))
		buffer-read-only)
            (save-excursion
              (goto-char (point-min))
              (while (not (eobp))
		(when (not (looking-at "^[[:space:]]*$"))
  		  (goto-char (line-end-position))
  		  (when (> (shr-pixel-column) max-width)
                    (goto-char (line-beginning-position))
                    (pj-justify)))
		(forward-line 1))))
	(add-hook 'window-configuration-change-hook
  		  'my-nov-window-configuration-change-hook
  		  nil t)))

    (add-hook 'nov-post-html-render-hook 'my-nov-post-html-render-hook)
    ))

(use-package hide-mode-line
  :ensure t
  :config
  (add-hook 'completion-list-mode-hook #'hide-mode-line-mode)
  (add-hook 'neotree-mode-hook #'hide-mode-line-mode))

;; (use-package org-alert
;;   :ensure nil
;;   :init (setq alert-default-style 'libnotify)
;;   :config
;;   (require 'org-alert))

(use-package org-noter
  :ensure t)

(use-package ledger-mode
  :ensure t)

(use-package flycheck-ledger
  :ensure t
  :config
  (eval-after-load 'flycheck
    '(require 'flycheck-ledger)))

;; (use-package git-gutter
;;   :ensure t
;;   :config
;;   (global-git-gutter-mode +1)
;;   (custom-set-variables
;;    '(git-gutter:update-interval 1)
;;    '(git-gutter:modified-sign " ") ;; two space
;;    '(git-gutter:added-sign "+")    ;; multiple character is OK
;;    '(git-gutter:deleted-sign "-")
;;    '(git-gutter:lighter " GG"))
;;   (set-face-background 'git-gutter:modified "purple") ;; background color
;;   (set-face-foreground 'git-gutter:added "green")
;;   (set-face-foreground 'git-gutter:deleted "red")
;;   )

(use-package bm
  :ensure t
  :demand t
  :init
  ;; restore on load (even before you require bm)
  (setq bm-restore-repository-on-load t)
  :config
  ;; Allow cross-buffer 'next'
  (setq bm-cycle-all-buffers t)
  ;; where to store persistant files
  (setq bm-repository-file (concat config-dir "bm-repository"))
  ;; save bookmarks
  (setq-default bm-buffer-persistence t)
  ;; Loading the repository from file when on start up.
  (add-hook 'after-init-hook 'bm-repository-load)
  ;; Saving bookmarks
  (add-hook 'kill-buffer-hook #'bm-buffer-save)
  ;; Saving the repository to file when on exit.
  ;; kill-buffer-hook is not called when Emacs is killed, so we
  ;; must save all bookmarks first.
  (add-hook 'kill-emacs-hook #'(lambda nil
                                 (bm-buffer-save-all)
                                 (bm-repository-save)))
  ;; The `after-save-hook' is not necessary to use to achieve persistence,
  ;; but it makes the bookmark data in repository more in sync with the file
  ;; state.
  (add-hook 'after-save-hook #'bm-buffer-save)
  ;; Restoring bookmarks
  (add-hook 'find-file-hooks   #'bm-buffer-restore)
  (add-hook 'after-revert-hook #'bm-buffer-restore)
  ;; The `after-revert-hook' is not necessary to use to achieve persistence,
  ;; but it makes the bookmark data in repository more in sync with the file
  ;; state. This hook might cause trouble when using packages
  ;; that automatically reverts the buffer (like vc after a check-in).
  ;; This can easily be avoided if the package provides a hook that is
  ;; called before the buffer is reverted (like `vc-before-checkin-hook').
  ;; Then new bookmarks can be saved before the buffer is reverted.
  ;; Make sure bookmarks is saved before check-in (and revert-buffer)
  (add-hook 'vc-before-checkin-hook #'bm-buffer-save)
  )

(use-package quelpa-use-package
  :ensure t)

(use-package org-ql
  :ensure t)

(use-package prescient
  :ensure t
  :init (setq prescient-save-file (concat config-dir "prescient-save.el"))
  :config (prescient-persist-mode))
(use-package ivy-prescient :ensure t :config (ivy-prescient-mode))
(use-package company-prescient :ensure t :config (company-prescient-mode))

(use-package org-analyzer
  :ensure t)

(use-package diminish
  :ensure t)

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
  :load-path "~/.emacs.d/site-lisp/snails")


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

  ;; (define-key awesome-pair-mode-map (kbd "%") 'awesome-pair-match-paren)
  (define-key awesome-pair-mode-map (kbd "\"") 'awesome-pair-double-quote)

  ;;(define-key awesome-pair-mode-map (kbd "M-o") 'awesome-pair-backward-delete)
  ;;(define-key awesome-pair-mode-map (kbd "C-d") 'awesome-pair-forward-delete)
  (define-key awesome-pair-mode-map (kbd "C-k") 'awesome-pair-kill)

  (define-key awesome-pair-mode-map (kbd "M-\"") 'awesome-pair-wrap-double-quote)
  (define-key awesome-pair-mode-map (kbd "M-[") 'awesome-pair-wrap-bracket)
  (define-key awesome-pair-mode-map (kbd "M-{") 'awesome-pair-wrap-curly)
  (define-key awesome-pair-mode-map (kbd "M-(") 'awesome-pair-wrap-round)
  (define-key awesome-pair-mode-map (kbd "M-)") 'awesoMe-pair-unwrap)

  (define-key awesome-pair-mode-map (kbd "M-p") 'awesome-pair-jump-left)
  (define-key awesome-pair-mode-map (kbd "M-n") 'awesome-pair-jump-right)
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
(defun print-symbol-◉ ()
  (interactive)
  (insert "◉"))
(global-set-key (kbd "C-c s t d") 'print-symbol-◉)

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

(defun print-symbol-❤ ()
  (interactive)
  (insert "❤"))
(global-set-key (kbd "C-c s t m") 'print-symbol-❤)

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
(global-set-key (kbd "C-x c v") 'customize-variable)

(global-set-key (kbd "C-c C-/") 'comment-or-uncomment-region)

(global-set-key (kbd "M-\/") 'set-mark-command)

;;代码缩进
(add-hook 'prog-mode-hook '(lambda ()
			     (local-set-key (kbd "C-M-\\")
					    'indent-region-or-buffer)))

;; 延迟加载
(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file))

(use-package expand-region
  :ensure t
  :config
  (defun ha/expand-region (lines)
    "Prefix-oriented wrapper around Magnar's `er/expand-region'.

Call with LINES equal to 1 (given no prefix), it expands the
region as normal.  When LINES given a positive number, selects
the current line and number of lines specified.  When LINES is a
negative number, selects the current line and the previous lines
specified.  Select the current line if the LINES prefix is zero."
    (interactive "p")
    (cond ((= lines 1)   (er/expand-region 1))
          ((< lines 0)   (ha/expand-previous-line-as-region lines))
          (t             (ha/expand-next-line-as-region (1+ lines)))))

  (defun ha/expand-next-line-as-region (lines)
    (message "lines = %d" lines)
    (beginning-of-line)
    (set-mark (point))
    (end-of-line lines))

  (defun ha/expand-previous-line-as-region (lines)
    (end-of-line)
    (set-mark (point))
    (beginning-of-line (1+ lines)))

  :bind ("C-=" . ha/expand-region))

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
  (add-hook 'prog-mode-hook #'yas-minor-mode)
  (add-hook 'org-mode-hook #'yas-minor-mode))


(use-package smartparens
  :ensure t
  :config
  (electric-pair-mode t)
  (sp-local-pair 'emacs-lisp-mode "'" nil :actions nil))


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
  (add-hook 'web-mode-hook 'flycheck-mode)
  (add-hook 'ledger-mode-hook 'flycheck-mode)
  )

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

;; (use-package helpful
;;   :ensure t
;;   :defer 5
;;   :pretty-hydra
;;   ((:color teal :quit-key "q")
;;    ("Helpful"
;;     (("f" helpful-callable "callable")
;;      ("v" helpful-variable "variable")
;;      ("k" helpful-key "key")
;;      ("c" helpful-command "command")
;;      ("d" helpful-at-point "thing at point"))))
;;   :bind ("C-h" . helpful-hydra/body))

(use-package django-mode
  :ensure t)

(use-package undo-tree
  :ensure t
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

;;;==================================================
;; (use-package company-tabnine
;;   :ensure t
;;   :init ;; Trigger completion immediately.
;;   (setq company-idle-delay 0)

;;   ;; Number the candidates (use M-1, M-2 etc to select completions).
;;   (setq company-show-numbers t)

;;   ;; Use the tab-and-go frontend.
;;   ;; Allows TAB to select and complete at the same time.
;;   (company-tng-configure-default)
;;   (setq company-frontends
;; 	'(company-tng-frontend
;;           company-pseudo-tooltip-frontend
;;           company-echo-metadata-frontend))
;;   :config
;;   (add-to-list 'company-backends #'company-tabnine)
;;   (company-tabnine nil))

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



(use-package cal-china-x
  :ensure t
  :after calendar
  :commands cal-china-x-setup
  :init (cal-china-x-setup)
  :config
  ;; `S' can show the time of sunrise and sunset on Calendar
  (setq calendar-location-name "Chengdu"
	calendar-latitude 30.67
	calendar-longitude 104.06)
  ;; Holidays
  (setq calendar-mark-holidays-flag nil)
  (setq cal-china-x-important-holidays cal-china-x-chinese-holidays)
  (setq cal-china-x-general-holidays
	'((holiday-lunar 1 15 "元宵节")
	  (holiday-lunar 7 7 "七夕节")
	  (holiday-fixed 3 8 "妇女节")
	  (holiday-fixed 3 12 "植树节")
	  (holiday-fixed 5 4 "青年节")
	  (holiday-fixed 6 1 "儿童节")
	  (holiday-fixed 9 10 "教师节")))
  (setq holiday-other-holidays
	'((holiday-fixed 2 14 "情人节")
	  (holiday-fixed 4 1 "愚人节")
	  (holiday-fixed 12 25 "圣诞节")
	  (holiday-float 5 0 2 "母亲节")
	  (holiday-float 6 0 3 "父亲节")
	  (holiday-float 11 4 4 "感恩节"))))


(provide 'init-misc)
