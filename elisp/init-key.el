(global-set-key (kbd "C-x -") 'split-window-below)
(global-set-key (kbd "C-x /") 'split-window-right)

(global-set-key (kbd "C-x c g") 'customize-group)
(global-set-key (kbd "C-x c f") 'customize-face)
(global-set-key (kbd "C-x c t") 'customize-themes)
(global-set-key (kbd "C-x c v") 'customize-variable)

(global-set-key (kbd "C-c C-/") 'comment-or-uncomment-region)

(global-set-key (kbd "M-\/") 'set-mark-command)

;;代码缩进
(add-hook 'prog-mode-hook
          '(lambda ()
	     (local-set-key (kbd "C-M-\\")
			    'indent-region-or-buffer)))

(provide 'init-key)
