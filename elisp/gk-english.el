(use-package websocket
  ;; git@github.com:ahyatt/emacs-websocket.git
  :load-path "~/.emacs.d/site-lisp/emacs-websocket")

(use-package websocket-bridge
  ;; git@github.com:ginqi7/websocket-bridge.git
  :load-path "~/.emacs.d/site-lisp/websocket-bridge")

(use-package dictionary-overlay
  ;; git@github.com:ginqi7/dictionary-overlay.git
  :load-path "~/.emacs.d/site-lisp/dictionary-overlay"
  :config
  (defface dictionary-overlay-translation
    '((((class color) (min-colors 88) (background light))
       :underline "#fb8c96" :background "#fbd8db")
      (((class color) (min-colors 88) (background dark))
       :underline "#C77577" :background "#7A696B")
      (t :inherit highlight))
    "Face for dictionary-overlay unknown words.")
  (setq dictionary-overlay-just-unknown-words nil)
  (setq dictionary-overlay-position 'help-echo)
  (copy-face 'font-lock-keyword-face 'dictionary-overlay-unknownword)
  (copy-face 'font-lock-comment-face 'dictionary-overlay-translation)
  (global-set-key (kbd "C-c m s") 'dictionary-overlay-start)
  (global-set-key (kbd "C-c m S") 'dictionary-overlay-stop)
  (global-set-key (kbd "C-c m R") 'dictionary-overlay-render-buffer)
  (global-set-key (kbd "C-c m r") 'dictionary-overlay-refresh-buffer)
  (global-set-key (kbd "C-c m u") 'dictionary-overlay-mark-word-unknown)
  (global-set-key (kbd "C-c m U") 'dictionary-overlay-mark-buffer-unknown)
  (global-set-key (kbd "C-c m k") 'dictionary-overlay-mark-word-known)
  (global-set-key (kbd "C-c m K") 'dictionary-overlay-mark-buffer))

(provide 'gk-english)
