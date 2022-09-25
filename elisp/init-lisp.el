(use-package elisp-demos
  :ensure t
  :config
  (advice-add 'describe-function-1
              :after #'elisp-demos-advice-describe-function-1))

(use-package slime
  :ensure t
  :config
  ;; 设置具体的 Common Lisp 实现，我这里是 sbcl
  (setq inferior-lisp-program "sbcl")
  ;; Slime 把多数功能拆成独立的包（Contrib Packages）
  ;; 需要根据功能单独加载，其中 slime-fancy 会自动加载流行的包，一般情况下只加载 slime-fancy 即可
  (setq slime-contribs '(slime-fancy)))

(use-package aggressive-indent
  :ensure t
  :config
  (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode))

(provide 'init-lisp)
