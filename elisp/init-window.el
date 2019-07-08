;;; window config
(use-package window-numbering
  :ensure t
  :init
  (setq window-numbering-assign-func
	(lambda () (when (equal (buffer-name) "*Calculator*") 9)))
  :config
  (window-numbering-mode 1))

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

(provide 'init-window)
