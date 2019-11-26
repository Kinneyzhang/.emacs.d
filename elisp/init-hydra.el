;;; hydra

(use-package hydra
  :ensure t
  :defer 5
  :commands (hydra-default-pre
             hydra-keyboard-quit
             hydra--call-interactively-remap-maybe
             hydra-show-hint
             hydra-set-transient-map)
  :bind (("C-c r" . 'hydra-launch/body)))

(defhydra hydra-launch (:color blue)
  "Launch"
  ("ec" (browse-url "https://www.emacs-china.org") "EmacsChina")
  ("ew" (browse-url "http://www.emacswiki.org/") "EmacsWiki")
  ("go" (browse-url "https://www.google.com") "Google")
  ("gt" (browse-url "https://www.github.com") "Github")
  ("mp" (browse-url "http://www.melpa.org/#/") "Melpa")
  ("v2" (browse-url "https://www.v2ex.com") "V2EX")
  ("yt" (browse-url "https://www.youtube.com") "YouTube")
  ("fd" (browse-url "https://feedly.com/i/latest") "Feedly")
  ("gm" (browse-url "https://mail.google.com/mail/u/0/?client=safari#inbox") "Gmail")
  ("gb" (browse-url "https://blog.geekinney.com") "Geekblog")
  ("rd" (browse-url "https://www.reddit.com") "Reddit")
  ("om" (browse-url "https://orgmode.org/org.html") "OrgMode Manual")
  ("s" multi-term "multi-term")
  ("q" nil "cancel"))

(use-package major-mode-hydra
  :ensure t
  :bind
  ("<f6>" . major-mode-hydra))

(use-package pretty-hydra
  :ensure t
  :init
  (cl-defun pretty-hydra-title (title &optional icon-type icon-name
                                      &key face height v-adjust)
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
       (propertize title 'face face))))
  )

;; (use-package hydra-posframe
;;   :defer 5
;;   :load-path "~/.emacs.d/site-lisp/hydra-posframe"
;;   :hook (after-init . hydra-posframe-enable))

(provide 'init-hydra)

;;; hydra end here
