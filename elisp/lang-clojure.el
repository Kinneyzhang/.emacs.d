(use-package clj-refactor
  :ensure t
  :config
  (cljr-add-keybindings-with-prefix "C-c C-r"))

(use-package clojure-mode
  :ensure nil
  :hook ((clojure-mode . clj-refactor-mode))
  :config (setq clojure-toplevel-inside-comment-form t))

(use-package cider
  :ensure t)

(provide 'lang-clojure)
