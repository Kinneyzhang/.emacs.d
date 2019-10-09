;;; include ivy avy counsel swiper and some packages using them.
(use-package ivy
  :ensure nil
  :diminish (ivy-mode . "")
  :bind (("C-x b" . ivy-switch-buffer))
  :config
  (ivy-mode 1)
  ;; add ‘recentf-mode’ and bookmarks to ‘ivy-switch-buffer’.
  (setq ivy-use-virtual-buffers t)
  ;; number of result lines to display
  (setq ivy-height 15)
  ;; does not count candidates
  (setq ivy-count-format "")
  ;; no regexp by default
  (setq ivy-initial-inputs-alist nil)
  ;; configure regexp engine.
  (setq ivy-re-builders-alist
	;; allow input not in order
	'((t . ivy--regex-ignore-order))))

(use-package swiper
  :ensure t
  :bind (("C-s" . swiper))
  :init (setq ivy-use-virtual-buffers t)
  :config
  (ivy-mode 1))

(use-package counsel
  :defer t
  :ensure nil
  :bind (("M-x" . counsel-M-x)
	 ("C-c e" . counsel-git)
	 ("C-c t l" . counsel-load-theme)
	 ("C-x C-f" . counsel-find-file)
	 ("C-x r b" . counsel-bookmark)
	 ("C-x r D" . bookmark-delete)
	 ))

;; posframe
(use-package posframe
  :ensure t)

(use-package ivy-posframe
  :ensure t
  :init
  (progn
    (setq ivy-posframe-parameters '((left-fringe . 6) (right-fringe . 6)))
    (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-top-center)))
    (setq ivy-posframe-height nil)
    (setq ivy-posframe-width 120))
  :config
  (ivy-posframe-mode))

(defun ivy-posframe-display-at-frame-top-center (str)
  (ivy-posframe--display str #'posframe-poshandler-frame-top-center))

;; projectile
(use-package projectile
  :ensure t)

(use-package counsel-projectile
  :ensure t
  :config
  (counsel-projectile-mode)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package counsel-world-clock
  :ensure t
  :defer 5)

;; open osx app
(use-package counsel-osx-app
  :ensure t
  :defer 5)


(use-package spotlight
  :ensure t
  :defer 5)

(use-package all-the-icons-ivy
  :ensure t
  :config
  (all-the-icons-ivy-setup)
  (setq all-the-icons-ivy-buffer-commands '())
  (setq all-the-icons-ivy-file-commands
	'(counsel-find-file counsel-file-jump counsel-recentf counsel-projectile-find-file counsel-projectile-find-dir)))

(use-package ivy-rich
  :ensure t
  :config
  (ivy-rich-mode 1)
  (setq ivy-format-function #'ivy-format-function-line)
  (setq ivy-rich--display-transformers-list
	'(ivy-switch-buffer
	  (:columns
	   ((ivy-rich-candidate (:width 30))  ; return the candidate itself
	    (ivy-rich-switch-buffer-size (:width 7))  ; return the buffer size
	    (ivy-rich-switch-buffer-indicators (:width 4 :face error :align right)); return the buffer indicators
	    (ivy-rich-switch-buffer-major-mode (:width 12 :face warning))          ; return the major mode info
	    (ivy-rich-switch-buffer-project (:width 15 :face success))          ; return project name using `projectile'
	    (ivy-rich-switch-buffer-path (:width (lambda (x) (ivy-rich-switch-buffer-shorten-path x (ivy-rich-minibuffer-width 0.3))))))  ; return file path relative to project root or `default-directory' if project is nil
	   :predicate
	   (lambda (cand) (get-buffer cand)))
	  counsel-M-x
	  (:columns
	   ((counsel-M-x-transformer (:width 80))  ; thr original transfomer
	    (ivy-rich-counsel-function-docstring (:face font-lock-doc-face))))  ; return the docstring of the command
	  counsel-describe-function
	  (:columns
	   ((counsel-describe-function-transformer (:width 40))  ; the original transformer
	    (ivy-rich-counsel-function-docstring (:face font-lock-doc-face))))  ; return the docstring of the function
	  counsel-describe-variable
	  (:columns
	   ((counsel-describe-variable-transformer (:width 40))  ; the original transformer
	    (ivy-rich-counsel-variable-docstring (:face font-lock-doc-face))))  ; return the docstring of the variable
	  counsel-recentf
	  (:columns
	   ((ivy-rich-candidate (:width 0.8)) ; return the candidate itself
	    (ivy-rich-file-last-modified-time (:face font-lock-comment-face))))) ; return the last modified time of the file
	))

;;; avy
(use-package avy
  :ensure t
  :defer 5
  :bind (("M-g c" . avy-goto-char-timer)
	 ("M-g l" . avy-goto-line)))

(use-package link-hint
  :ensure t
  :defer 5
  :bind
  ("C-c l o" . link-hint-open-link)
  ("C-c l c" . link-hint-copy-link)
  ("C-c l i" . org-insert-link)
  ("C-c l s" . org-store-link))

(use-package ivy-pass
  :ensure t)

(provide 'init-ivy)

