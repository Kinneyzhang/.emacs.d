;;; window config

(use-package winum
  :ensure t
  :init
  (setq winum-keymap
	(let ((map (make-sparse-keymap)))
	  (define-key map (kbd "C-`") 'winum-select-window-by-number)
	  (define-key map (kbd "C-²") 'winum-select-window-by-number)
	  (define-key map (kbd "M-0") 'winum-select-window-0-or-10)
	  (define-key map (kbd "M-1") 'winum-select-window-1)
	  (define-key map (kbd "M-2") 'winum-select-window-2)
	  (define-key map (kbd "M-3") 'winum-select-window-3)
	  (define-key map (kbd "M-4") 'winum-select-window-4)
	  (define-key map (kbd "M-5") 'winum-select-window-5)
	  (define-key map (kbd "M-6") 'winum-select-window-6)
	  (define-key map (kbd "M-7") 'winum-select-window-7)
	  (define-key map (kbd "M-8") 'winum-select-window-8)
	  map))
  :config
  (defun winum-assign-9-to-calculator-8-to-flycheck-errors ()
    (cond
     ((equal (buffer-name) "*Calculator*") 9)
     ((equal (buffer-name) "*Flycheck errors*") 8)))

  (defun winum-assign-0-to-neotree ()
    (when (string-match-p (buffer-name) ".*\\*NeoTree\\*.*") 10))

  (add-to-list 'winum-assign-functions #'winum-assign-9-to-calculator-8-to-flycheck-errors)
  (add-to-list 'winum-assign-functions #'winum-assign-0-to-neotree)

  (set-face-attribute 'winum-face nil :weight 'bold)

  (setq window-numbering-scope            'global
	winum-reverse-frame-list          nil
	winum-auto-assign-0-to-minibuffer t
	winum-assign-func                 'my-winum-assign-func
	winum-auto-setup-mode-line        t
	winum-format                      " %s "
	winum-mode-line-position          1
	winum-ignored-buffers             '(" *which-key*"))

  (winum-mode)
  )

(use-package ace-window
  :ensure t
  :defer t
  :bind (("M-o" . ace-window))
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (defvar aw-dispatch-alist
    '((?x aw-delete-window "Delete Window")
      (?M aw-swap-window "Swap Windows")
      (?M aw-move-window "Move Window")
      (?c aw-copy-window "Copy Window")
      (?j aw-switch-buffer-in-window "Select Buffer")
      (?n aw-flip-window)
      (?u aw-switch-buffer-other-window "Switch Buffer Other Window")
      (?c aw-split-window-fair "Split Fair Window")
      (?v aw-split-window-vert "Split Vert Window")
      (?b aw-split-window-horz "Split Horz Window")
      (?o delete-other-windows "Delete Other Windows")
      (?? aw-show-dispatch-help))
    "List of actions for `aw-dispatch-default'."))

(use-package popwin
  :ensure t
  :config (popwin-mode 1))

(use-package neotree
  :ensure t
  :defer 5
  :bind (("<f8>" . neotree-toggle))
  :config
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))

(provide 'init-window)
