(use-package cider
  :ensure t
  :config   (setq org-babel-clojure-backend 'cider))

(use-package clj-refactor
  :ensure t
  :config
  (cljr-add-keybindings-with-prefix "C-c C-r"))

(use-package clojure-mode
  :ensure nil
  :hook ((clojure-mode . clj-refactor-mode)
         (clojure-mode . cider-mode))
  :config (setq clojure-toplevel-inside-comment-form t))

(provide 'lang-clojure)
