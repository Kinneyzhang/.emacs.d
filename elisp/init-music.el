(use-package emms
  :ensure t
  :config
  (emms-all)
  (setq emms-player-list '(emms-player-mpv))
  (setq emms-source-file-default-directory "~/emms"))

(provide 'init-music)
