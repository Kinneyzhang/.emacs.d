;;; hydra

(use-package hydra
  :ensure t
  :defer 5
  :commands (hydra-default-pre
             hydra-keyboard-quit
             hydra--call-interactively-remap-maybe
             hydra-show-hint
             hydra-set-transient-map))

(use-package pretty-hydra
  :ensure t
  :bind (("<f2>" . emacs-hydra/body)
	 ("C-c r" . hydra-launch/body))
  :init
  (cl-defun pretty-hydra-title (title &optional icon-type icon-name &key face height v-adjust)
    "Add an icon in the hydra title."
    (let ((face (or face `(:foreground ,(face-background 'highlight))))
          (height (or height 1.0))
          (v-adjust (or v-adjust 0.0)))
      (concat
       (when (and (display-graphic-p) icon-type icon-name)
         (let ((f (intern (format "all-the-icons-%s" icon-type))))
           (when (fboundp f)
             (concat
              (apply f (list icon-name :face face :height height :v-adjust v-adjust))
              " "))))
       (propertize title 'face face)))))


;; Global toggles
(pretty-hydra-define emacs-hydra
  (:color amaranth :exit t)
  ("Basic"
   (("a" org-agenda "org agenda")
    ("b" ivy-switch-buffer "switch buffer")
    ("c" org-capture "org capture")
    ("e" eval-expression "eval expression")
    ("f" find-file "find file")
    ("s" swiper "swiper search"))
   "Open Browser"
   (("w w" search-web "with engine")
    ("w u" browse-url "with url")
    ("w p" search-web-at-point "point")
    ("w r" search-web-region "region")
    ("w g" browse-at-remote "remote"))
   "Describe"
   (("h f" describe-function "function")
    ("h v" describe-variable "variable")
    ("h k" describe-key "key"))
   "Bookmark"
   (("m t" bm-toggle "toggle")
    ("m s" bm-show "show")
    ("m n" bm-next "next")
    ("m p" bm-previous "previous"))
   "Pomodoro"
   (("p s" pomodoro-start "start")
    ("p d" pomodoro-stop "stop")
    ("p p" pomodoro-pause "pause")
    ("p r" pomodoro-resume "resume"))
   "Avy"
   (("g c" avy-goto-char-timer "goto char")
    ("g l" avy-goto-line "goto line"))
   "Deft"
   (("d d" deft "deft")
    ("d f" deft-find-file "find file"))
   ))

(pretty-hydra-define hydra-launch
  (:color amaranth :exit t)
  ("Goto website"
   (("x e" (browse-url "http://ergoemacs.org/emacs/emacs.html") "XahEmacs")
    ("b l" (browse-url "https://www.bilibili.com") "Bilibili")
    ("d b" (browse-url "https://www.douban.com") "Douban")
    ("e c" (browse-url "https://www.emacs-china.org") "EmacsChina")
    ("e w" (browse-url "http://www.emacswiki.org/") "EmacsWiki")
    ("e l" (browse-url "https://www.gnu.org/software/emacs/manual/html_mono/elisp.html") "Elisp")
    ("g o" (browse-url "https://www.google.com") "Google")
    ("g t" (browse-url "https://www.github.com") "Github")
    ("m p" (browse-url "http://www.melpa.org/#/") "Melpa")
    ("v 2" (browse-url "https://www.v2ex.com") "V2EX")
    ("y t" (browse-url "https://www.youtube.com") "YouTube")
    ("f d" (browse-url "https://feedly.com/i/latest") "Feedly")
    ("g m" (browse-url "https://mail.google.com/mail/u/0/?client=safari#inbox") "Gmail")
    ("g b" (browse-url "https://blog.geekinney.com") "Geekblog")
    ("r d" (browse-url "https://www.reddit.com") "Reddit")
    ("o m" (browse-url "https://orgmode.org/org.html") "OrgMode Manual")
    ("z h" (browse-url "https://www.zhihu.com" "Zhihu"))
    ("v t" vterm "vterm")
    ))
  )

(provide 'init-hydra)

;;; hydra end here
