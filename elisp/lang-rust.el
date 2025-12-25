(use-package rust-mode
  :ensure t
  :config
  (setq rust-format-on-save t)
  ;; (add-hook 'rust-mode-hook 'eglot-ensure)
  (add-hook 'rust-mode-hook
            (lambda () (setq indent-tabs-mode nil)))
  ;; (add-hook 'rust-mode-hook #'auto-save-disable)
  (define-key rust-mode-map (kbd "C-c C-c")
              (lambda () (interactive) (save-buffer) (rust-run))))

(use-package ob-rust
  :ensure t)

;; (use-package rustic
;;   :ensure t
;;   :config
;;   (rustic-doc-mode 1))

(provide 'lang-rust)
