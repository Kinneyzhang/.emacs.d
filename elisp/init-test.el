;; (use-package org-panes
;;   :load-path "~/.emacs.d/site-lisp/org-panes.el")

;; 体验要比multi-term好很多
(use-package vterm
  :ensure t
  )

(use-package vterm-toggle
  :ensure t
  :bind
  (("<f2>" . vterm-toggle)
   ("C-<f2>" . vterm-toggle-cd))
  :config
  (define-key vterm-mode-map (kbd "s-n") 'vterm-toggle-forward)
  (define-key vterm-mode-map (kbd "s-p") 'vterm-toggle-backward)

  (setq vterm-toggle-fullscreen-p nil)
  (add-to-list 'display-buffer-alist
	       '("^v?term.*"
		 (display-buffer-reuse-window display-buffer-in-side-window)
		 (side . bottom)
		 ;;(dedicated . t) ;dedicated is supported in emacs27
		 (reusable-frames . visible)
		 (window-height . 0.3)))
  )

(use-package jupyter
  :ensure t)

(provide 'init-test)
