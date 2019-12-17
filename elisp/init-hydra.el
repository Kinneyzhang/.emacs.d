;;; hydra

(use-package hydra
  :ensure t
  :defer 5
  :commands (hydra-default-pre
             hydra-keyboard-quit
             hydra--call-interactively-remap-maybe
             hydra-show-hint
             hydra-set-transient-map)
  :bind (("C-c r" . 'hydra-launch/body)
	 ("C-c w f" . 'hydra-workflow/body)))

(defhydra hydra-launch (:color pink)
  "
^Goto website "
  ("ec" (browse-url "https://www.emacs-china.org") "EmacsChina")
  ("ew" (browse-url "http://www.emacswiki.org/") "EmacsWiki")
  ("el" (browse-url "http://caiorss.github.io/Emacs-Elisp-Programming/Elisp_Programming.html") "Elisp")
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
  ("tm" vterm "multi-term")
  ("q" nil "cancel" :color blue))

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

(defhydra hydra-workflow (:color pink :hint nil)
  "workflow "
  ("e" (my/learn-emacs-lisp) "learn elisp")
  ("j" (my/write-morning-journal) "write journal")
  ("c" (my/learn-c-plus-plus-algorithms) "learn C++")
  ("q" nil "cancel" :color blue))

(defun my/learn-emacs-lisp ()
  (bookmark-jump "emacs-lisp-learning-note.org")
  (switch-to-buffer-other-window "*scratch*")
  (browse-url "http://caiorss.github.io/Emacs-Elisp-Programming/Elisp_Programming.html"))

(defun my/write-morning-journal ()
  (delete-other-windows)
  (org-capture nil "j")
  (ace-window)
  (dired-jump)
  (dired-previous-line))

(defun my/learn-c-plus-plus-algorithms ()
  (dired "~/iCloud/geekstuff/C-Plus-Plus/")
  (split-window-horizontally)
  (dired "~/iCloud/program_work/c-plus-plus-algorithms/"))

(provide 'init-hydra)

;;; hydra end here
