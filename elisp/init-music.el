;;; include music and podcast config
(use-package mingus
  :ensure t
  :defer 5
  :init (setq mingus-mode-always-modeline nil)
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

(use-package emms
  :ensure t
  :init
  (emms-all)
  (emms-default-players)
  (require 'emms-setup)
  (require 'emms-source-file)
  (require 'emms-source-playlist)
  (require 'emms-streams)
  (require 'emms-stream-info)
  ;; (setq emms-stream-info-backend 'mpv)
  (setq emms-directory (concat config-dir "emms/")
	emms-stream-file (concat config-dir "streams.emms"))
  :config
  (define-emms-simple-player afplay '(file)
    (regexp-opt '(".mp3" ".m4a" ".aac" ".flac"))
    "afplay")
  (define-emms-simple-player mpv '(file url streamlist)
    (regexp-opt '(".ogg" ".mp3" ".opus" ".wav" ".mpg" ".mpeg" ".wmv" ".wma"
  		  ".mov" ".avi" ".ogm" ".mkv" "http://" "https" "mms://"
  		  ".mp4" ".flac" ".vob" ".m4a" ".flv" ".ogv" ".pls"))
    "mpv" "--quiet" "--no-audio-display" "--no-terminal" "--shuffle" "yes")
  (define-emms-simple-player mplayer '(file url)
    (regexp-opt '(".ogg" ".mp3" ".wav" ".mpg" ".mpeg" ".wmv" ".wma"
		  ".mov" ".avi" ".divx" ".ogm" ".asf" ".mkv" "http://" "mms://"
		  ".rm" ".rmvb" ".mp4" ".flac" ".vob" ".m4a" ".flv" ".ogv" ".pls"))
    "mplayer" "-slave" "-quiet" "-really-quiet" "-fullscreen")
  (setq emms-player-list `(,emms-player-mpv))
  (setq emms-source-file-default-directory (expand-file-name "~/Music")
        emms-source-file-directory-tree-function 'emms-source-file-directory-tree-find)
  ;; (setq emms-playlist-buffer-name "*Music*")
  )

(provide 'init-music)
