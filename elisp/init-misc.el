;; (use-package twidget
;;   :load-path "~/iCloud/hack/twidget/")

;; (use-package roam-block
;;   :load-path "~/iCloud/hack/roam-block/"
;;   :init (setq roam-block-home '("~/iCloud/TEMP/")
;;               roam-block-ref-highlight t
;;               roam-block-embed-highlight t)
;;   :bind
;;   (:map roam-block-mode-map
;;         (("C-c b d" . roam-block-delete-block)
;;          ("C-c b r s" . roam-block-ref-store)
;;          ("C-c b r i" . roam-block-ref-insert)
;;          ("C-c b r d" . roam-block-ref-delete)
;;          ("C-c b r t" . roam-block-ref-highlight-toggle)
;;          ("C-c b e s" . roam-block-embed-store)
;;          ("C-c b e i" . roam-block-embed-insert)
;;          ("C-c b e t" . roam-block-embed-highlight-toggle)))
;;   :config
;;   (roam-block-mode 1)
;;   ;; (defun roam-block-set-margins ()
;;   ;;   "Set window margins for buffer window which roam-block works on."
;;   ;;   (dolist (win (window-list))
;;   ;;     (let* ((buf (window-buffer win))
;;   ;;            (file (buffer-file-name buf)))
;;   ;;       (when (roam-block-work-on buf)
;;   ;;         (unless (car (window-margins win))
;;   ;;           (set-window-margins win 1 1))))))
;;   ;; (add-hook 'post-command-hook #'roam-block-set-margins)
;;   ;; (add-hook 'window-configuration-change-hook #'roam-block-set-margins)
;;   )

;;(use-package burly
;;  :quelpa (burly :fetcher github :repo "alphapapa/burly.el"))

(use-package gtd
  :load-path "~/Emacs/gtd-mode")

(use-package gkroam
  :ensure t
  :hook (after-init . gkroam-mode)
  :init
  (setq gkroam-root-dir "~/gknows/")
  (setq gkroam-show-brackets-p nil
        gkroam-prettify-page-p t
        gkroam-title-height 200
        gkroam-use-default-filename t
        gkroam-window-margin 4)
  :bind
  (:map gkroam-mode-map
        (("C-c r g" . gkroam-update)
         ("C-c r d" . gkroam-daily)
         ("C-c r D" . gkroam-delete)
         ("C-c r f" . gkroam-find)
         ("C-c r c" . gkroam-capture)
         ("C-c r e" . gkroam-link-edit)
         ("C-c r n" . gkroam-dwim)
         ("C-c r i" . gkroam-insert)
         ("C-c r I" . gkroam-index)
         ("C-c r u" . gkroam-show-unlinked)
         ("C-c r t" . gkroam-toggle-brackets)
         ("C-c r p" . gkroam-toggle-prettify)
         ("C-c r R" . gkroam-rebuild-caches)))
  :config
  (setq org-startup-folded nil))

(use-package bongo
  :ensure t
  :init
  (setq bongo-default-directory "~/Music/")
  (setq bongo-enabled-backends '(mplayer mpv afplay vlc))
  (setq bongo-custom-backend-matchers
        '((mplayer local-file "mp3" "m4a" "wav")
          (mpv local-file "mp4" "mkv")))
  :config
  (defun bongo-insert-default-dir (orig-fun)
    "Insert default directory after bongo initialization."
    (let ((buffer-exist-p (get-buffer bongo-default-playlist-buffer-name)))
      (funcall orig-fun)
      (unless buffer-exist-p
        (let ((bongo-insert-whole-directory-trees t))
          (bongo-insert-file "./")))))
  (advice-add 'bongo-playlist :around #'bongo-insert-default-dir))

(use-package eradio
  :ensure t
  :init
  (setq eradio-channels
        '(("def con - soma fm" . "https://somafm.com/defcon256.pls")
          ("metal - soma fm"   . "https://somafm.com/metal130.pls")
          ("cyberia - lainon"  . "https://lainon.life/radio/cyberia.ogg.m3u")
          ("cafe - lainon"     . "https://lainon.life/radio/cafe.ogg.m3u"))))

(use-package elisp-demos
  :ensure t
  :config (advice-add 'describe-function-1 :after #'elisp-demos-advice-describe-function-1))

(use-package gnuplot
  :ensure t
  :config
  (use-package gnuplot-mode
    :ensure t))

(use-package toc-org
  :ensure t
  :config
  (if (require 'toc-org nil t)
      (progn
	(add-hook 'org-mode-hook 'toc-org-mode)
	;; enable in markdown, too
	(add-hook 'markdown-mode-hook 'toc-org-mode))
    (warn "toc-org not found")))

;; (use-package pp-html
;;   :load-path "~/iCloud/hack/pp-html")

(use-package ledger-mode
  :ensure t)

(use-package flycheck-ledger
  :ensure t
  :config
  (eval-after-load 'flycheck
    '(require 'flycheck-ledger)))

(use-package bm
  :ensure t
  :demand t
  :init
  (setq bm-restore-repository-on-load t)
  :config
  (setq bm-cycle-all-buffers t)
  (setq-default bm-buffer-persistence t)
  (add-hook 'after-init-hook 'bm-repository-load)
  (add-hook 'kill-buffer-hook #'bm-buffer-save)
  (add-hook 'kill-emacs-hook #'(lambda nil
                                 (bm-buffer-save-all)
                                 (bm-repository-save))))

(use-package prescient
  :ensure t
  :config (prescient-persist-mode))
(use-package ivy-prescient :ensure t :config (ivy-prescient-mode))
(use-package company-prescient :ensure t :config (company-prescient-mode))

;; (use-package awesome-pair
;;   :load-path "~/.emacs.d/site-lisp/awesome-pair"
;;   :config
;;   (dolist (hook (list
;; 		 'c-mode-common-hook
;; 		 'c-mode-hook
;; 		 'c++-mode-hook
;; 		 'java-mode-hook
;; 		 'haskell-mode-hook
;; 		 'emacs-lisp-mode-hook
;; 		 'lisp-interaction-mode-hook
;; 		 'lisp-mode-hook
;; 		 'maxima-mode-hook
;; 		 'ielm-mode-hook
;; 		 'sh-mode-hook
;; 		 'makefile-gmake-mode-hook
;; 		 'php-mode-hook
;; 		 'python-mode-hook
;; 		 'js-mode-hook
;; 		 'go-mode-hook
;; 		 'qml-mode-hook
;; 		 'jade-mode-hook
;; 		 'css-mode-hook
;; 		 'ruby-mode-hook
;; 		 'coffee-mode-hook
;; 		 'rust-mode-hook
;; 		 'qmake-mode-hook
;; 		 'lua-mode-hook
;; 		 'swift-mode-hook
;;                  'clojure-mode-hook
;; 		 'minibuffer-inactive-mode-hook))
;;     (add-hook hook '(lambda () (awesome-pair-mode 1))))

;;   (define-key awesome-pair-mode-map (kbd "(") 'awesome-pair-open-round)
;;   (define-key awesome-pair-mode-map (kbd "[") 'awesome-pair-open-bracket)
;;   (define-key awesome-pair-mode-map (kbd "{") 'awesome-pair-open-curly)
;;   (define-key awesome-pair-mode-map (kbd ")") 'awesome-pair-close-round)
;;   (define-key awesome-pair-mode-map (kbd "]") 'awesome-pair-close-bracket)
;;   (define-key awesome-pair-mode-map (kbd "}") 'awesome-pair-close-curly)

;;   ;; (define-key awesome-pair-mode-map (kbd "%") 'awesome-pair-match-paren)
;;   (define-key awesome-pair-mode-map (kbd "\"") 'awesome-pair-double-quote)

;;   ;;(define-key awesome-pair-mode-map (kbd "M-o") 'awesome-pair-backward-delete)
;;   ;;(define-key awesome-pair-mode-map (kbd "C-d") 'awesome-pair-forward-delete)
;;   (define-key awesome-pair-mode-map (kbd "C-k") 'awesome-pair-kill)

;;   (define-key awesome-pair-mode-map (kbd "M-\"") 'awesome-pair-wrap-double-quote)
;;   (define-key awesome-pair-mode-map (kbd "M-[") 'awesome-pair-wrap-bracket)
;;   (define-key awesome-pair-mode-map (kbd "M-{") 'awesome-pair-wrap-curly)
;;   (define-key awesome-pair-mode-map (kbd "M-(") 'awesome-pair-wrap-round)
;;   (define-key awesome-pair-mode-map (kbd "M-)") 'awesoMe-pair-unwrap)

;;   (define-key awesome-pair-mode-map (kbd "M-p") 'awesome-pair-jump-left)
;;   (define-key awesome-pair-mode-map (kbd "M-n") 'awesome-pair-jump-right)
;;   (define-key awesome-pair-mode-map (kbd "M-:") 'awesome-pair-jump-out-pair-and-newline))


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

(global-set-key (kbd "C-x -") 'split-window-below)
(global-set-key (kbd "C-x /") 'split-window-right)

(global-set-key (kbd "<f5>") 'revert-buffer)

;; ================================================
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
  :bind (("C-=" . ha/expand-region))
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
    (beginning-of-line (1+ lines))))

(defun open-my-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el")
  (with-current-buffer "init.el"
    (read-only-mode)))
(global-set-key (kbd "<f1>") 'open-my-init-file)

(defun open-my-misc-file()
  (interactive)
  (find-file "~/.emacs.d/elisp/init-misc.el"))

(use-package magit
  :defer t
  :ensure t
  :bind ("C-x g" . magit-status))

(use-package company
  :ensure t
  :defer 5
  :config
  (setq company-idle-delay 0.1)
  (setq company-candidates-length 5)
  (setq company-minimum-prefix-length 2)
  (global-company-mode t)
  (with-eval-after-load 'company
    (define-key company-active-map (kbd "\C-n") #'company-select-next)
    (define-key company-active-map (kbd "\C-p") #'company-select-previous)
    (define-key company-active-map (kbd "M-n") nil)
    (define-key company-active-map (kbd "M-p") nil)))

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
  ;; (add-hook 'emacs-lisp-mode-hook 'flycheck-mode)
  )

;; markdown and preview

(use-package markdown-mode
  :ensure t
  :defer 5
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode))
  :init
  (setq markdown-command "markdown_py"))

(use-package exec-path-from-shell
  :defer 5
  :if (memq window-system '(ns mac))
  :ensure t
  :config
  (setq exec-path-from-shell-arguments '("-l"))
  (exec-path-from-shell-initialize))

;;;==================================================
(defun maple/mac-switch-input-source ()
  (shell-command
   "osascript -e 'tell application \"System Events\" to tell process \"SystemUIServer\"
   set currentLayout to get the value of the first menu bar item of menu bar 1 whose description is \"text input\"
   if currentLayout is not \"ABC\" then
   tell (1st menu bar item of menu bar 1 whose description is \"text input\") to {click, click (menu 1'\"'\"'s menu item \"ABC\")}
   end if
   end tell' &>/dev/null"))

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
