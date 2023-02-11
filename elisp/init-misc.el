(use-package prescient
  :ensure t
  :config
  (prescient-persist-mode))

(use-package ivy-prescient
  :ensure t
  :config
  (ivy-prescient-mode))

(use-package company-prescient
  :ensure t
  :config
  (company-prescient-mode))

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
  (find-file (concat user-emacs-directory "init.el"))
  (with-current-buffer "init.el"
    (read-only-mode)))
(global-set-key (kbd "<f1>") 'open-my-init-file)

;; (use-package magit
;;   :defer t
;;   :ensure t
;;   :bind ("C-x g" . magit-status))

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
  :init (setq yas-snippet-dirs `(,(concat user-emacs-directory "snippets")))
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook #'yas-minor-mode)
  (add-hook 'org-mode-hook #'yas-minor-mode)
  (add-hook 'c-mode-hook #'yas-minor-mode))

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

(use-package markdown-mode
  :ensure t
  :defer 5
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode))
  :init
  (setq markdown-command "markdown_py"))

(provide 'init-misc)
