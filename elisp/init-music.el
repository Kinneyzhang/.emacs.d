;;; include music and podcast config
(use-package bongo
  :ensure t
  :defer t
  :bind (("C-c m" . bongo-playlist))
  :init (setq bongo-default-directory "~/Music")
  :config
  (progn
    (bongo-playlist)
    (bongo-insert-directory "网易云音乐")))

(use-package podcaster
  :defer 5
  :ensure t)

(provide 'init-music)
