;; -*- lexical-binding: nil; -*-

(use-package emms
  :ensure t
  :config
  (my/ensure-dynamic-binding-cookie
   (expand-file-name "emms/cache" user-emacs-directory))
  (emms-all)
  (defun my/emms-ensure-cache-cookie (&rest _)
    "Keep EMMS's generated cache explicit about dynamic binding."
    (my/ensure-dynamic-binding-cookie emms-cache-file))
  (advice-add 'emms-cache-save :after #'my/emms-ensure-cache-cookie)
  (setq emms-player-list '(emms-player-mpv))
  (setq emms-source-file-default-directory "~/emms"))

(provide 'init-music)
