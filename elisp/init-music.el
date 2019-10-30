;;; include music and podcast config
(use-package mingus
  :ensure t
  :defer 5
  :init (setq mingus-mode-always-modeline t)
  :bind (("C-c m" . mingus)))

(use-package podcaster
  :defer 5
  :ensure t
  :init
  (setq podcaster-feeds-urls
	'("http://www.ximalaya.com/album/5574153.xml"
	  "http://rss.lizhi.fm/rss/14275.xml"))
  (setq podcaster-mp3-player "ffplay")
  )

(provide 'init-music)
