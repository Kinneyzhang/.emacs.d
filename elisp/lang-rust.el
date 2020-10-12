(use-package rust-mode
  :ensure t
  :config
  (setq rust-format-on-save t)
  (add-hook 'rust-mode-hook
            (lambda () (setq indent-tabs-mode nil)))
  (define-key rust-mode-map (kbd "C-c C-c") 'rust-run))

(use-package ob-rust
  :ensure t)

(provide 'lang-rust)
