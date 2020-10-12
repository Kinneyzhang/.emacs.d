(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   (vector "#ffffff" "#bf616a" "#B4EB89" "#ebcb8b" "#89AAEB" "#C189EB" "#89EBCA" "#232830"))
 '(company-quickhelp-color-background "#4F4F4F")
 '(company-quickhelp-color-foreground "#DCDCCC")
 '(compilation-message-face 'default)
 '(cua-global-mark-cursor-color "#3cafa5")
 '(cua-normal-cursor-color "#8d9fa1")
 '(cua-overwrite-cursor-color "#c49619")
 '(cua-read-only-cursor-color "#93a61a")
 '(debug-on-error t)
 '(fci-rule-color "#343d46")
 '(highlight-changes-colors '("#e2468f" "#7a7ed2"))
 '(highlight-symbol-colors
   '("#3c6e408d329c" "#0c4a45f54ce3" "#486d33913531" "#1fab3bea568c" "#2ec943ac3324" "#449935a6314d" "#0b03411b5985"))
 '(highlight-symbol-foreground-color "#9eacac")
 '(highlight-tail-colors
   '(("#01323d" . 0)
     ("#687f00" . 20)
     ("#008981" . 30)
     ("#0069b0" . 50)
     ("#936d00" . 60)
     ("#a72e01" . 70)
     ("#a81761" . 85)
     ("#01323d" . 100)))
 '(hl-bg-colors
   '("#936d00" "#a72e01" "#ae1212" "#a81761" "#3548a2" "#0069b0" "#008981" "#687f00"))
 '(hl-fg-colors
   '("#002732" "#002732" "#002732" "#002732" "#002732" "#002732" "#002732" "#002732"))
 '(hl-paren-colors '("#3cafa5" "#c49619" "#3c98e0" "#7a7ed2" "#93a61a"))
 '(hl-sexp-background-color "#1c1f26")
 '(lsp-ui-doc-border "#9eacac")
 '(nrepl-message-colors
   '("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3"))
 '(org-agenda-files
   '("~/iCloud/hack/gk-roam/README.org" "~/iCloud/org/task.org" "~/iCloud/org/project.org" "~/iCloud/org/inbox.org" "~/iCloud/org/someday.org" "~/iCloud/org/review.org"))
 '(org-clones-abort-edit-shortcut "C-c C-k" t)
 '(org-clones-clone-prefix-icon "◈ " t)
 '(org-clones-commit-edit-shortcut "C-c C-c" t)
 '(org-clones-empty-body-string "[empty clone body]" t)
 '(org-clones-empty-headling-string "[empty clone headline]" t)
 '(org-clones-jump-to-next-clone-shortcut "n" t)
 '(org-clones-prompt-before-syncing nil t)
 '(org-clones-start-edit-shortcut "C-c C-c" t)
 '(org-clones-use-popup-prompt nil t)
 '(org-edit-src-content-indentation 0)
 '(org-journal-date-format "%A, %d %B %Y")
 '(org-journal-dir "~/iCloud/journal/")
 '(org-roam-directory "~/org-roam/")
 '(org-src-fontify-natively t)
 '(org-src-tab-acts-natively t)
 '(package-selected-packages
   '(eradio company-web company-prescient color-theme-sanityinc-tomorrow ob-rust telega rust-mode db org-roam gkroam bongo aggressive-indent link-hint rg package-lint smartparens powerline undo-tree hungry-delete go-translate youdao-dictionary form-feed page-break-lines elisp-demos gnugo epkg emms podcaster expand-region move-text sqlite3 esqlite emacsql-sqlite emacs-edbi gnuplot-mode gnuplot elscreen posframe solarized-theme cyberpunk-2019-theme cyberpunk-theme material-theme gruvbox-theme zenburn-theme leuven-theme debbugs auto-org-md super-save timerfunctions winum which-key webpaste web-server web-mode web-beautify w3m vterm-toggle visual-fill-column tree-mode tramp-term toc-org symbol-overlay sunshine spotlight smart-comment separedit search-web robe restart-emacs rainbow-delimiters quelpa-use-package pyenv-mode py-autopep8 proxy-mode popwin pomidor pip-requirements php-mode persist pdf-tools password-generator paredit osx-dictionary org-ql org-pomodoro org-noter org-download org-bullets org-analyzer org-agenda-property nov neotree moz-controller markdown-mode major-mode-hydra magit macrostep lispy libmpdee ledger-mode jupyter jsonrpc js2-refactor js-comint ivy-prescient ivy-posframe ivy-pass impatient-mode imenu-list idle-org-agenda hierarchy hide-mode-line helpful helm-core graphql google-translate git general furl flycheck-ledger exec-path-from-shell enh-ruby-mode emmet-mode elpy elfeed el2org ego dracula-theme django-mode diredfl diminish darkroom counsel-world-clock counsel-projectile counsel-osx-app calibredb calfw-org calfw cal-china-x browse-at-remote bm benchmark-init alarm-clock ac-html-bootstrap ac-html-angular))
 '(pdf-view-midnight-colors '("#fdf4c1" . "#32302f"))
 '(pos-tip-background-color "#01323d")
 '(pos-tip-foreground-color "#9eacac")
 '(safe-local-variable-values
   '((eval when
           (and
            (buffer-file-name)
            (not
             (file-directory-p
              (buffer-file-name)))
            (string-match-p "^[^.]"
                            (buffer-file-name)))
           (unless
               (featurep 'package-build)
             (let
                 ((load-path
                   (cons "../package-build" load-path)))
               (require 'package-build)))
           (unless
               (derived-mode-p 'emacs-lisp-mode)
             (emacs-lisp-mode))
           (package-build-minor-mode)
           (setq-local flycheck-checkers nil)
           (set
            (make-local-variable 'package-build-working-dir)
            (expand-file-name "../working/"))
           (set
            (make-local-variable 'package-build-archive-dir)
            (expand-file-name "../packages/"))
           (set
            (make-local-variable 'package-build-recipes-dir)
            default-directory))))
 '(smartrep-mode-line-active-bg (solarized-color-blend "#93a61a" "#01323d" 0.2))
 '(term-default-bg-color "#002732")
 '(term-default-fg-color "#8d9fa1")
 '(vc-annotate-background nil)
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   '((20 . "#bf616a")
     (40 . "#DCA432")
     (60 . "#ebcb8b")
     (80 . "#B4EB89")
     (100 . "#89EBCA")
     (120 . "#89AAEB")
     (140 . "#C189EB")
     (160 . "#bf616a")
     (180 . "#DCA432")
     (200 . "#ebcb8b")
     (220 . "#B4EB89")
     (240 . "#89EBCA")
     (260 . "#89AAEB")
     (280 . "#C189EB")
     (300 . "#bf616a")
     (320 . "#DCA432")
     (340 . "#ebcb8b")
     (360 . "#B4EB89")))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   '(unspecified "#002732" "#01323d" "#ae1212" "#ec423a" "#687f00" "#93a61a" "#936d00" "#c49619" "#0069b0" "#3c98e0" "#a81761" "#e2468f" "#008981" "#3cafa5" "#8d9fa1" "#60767e"))
 '(winner-mode t)
 '(xterm-color-names
   ["#01323d" "#ec423a" "#93a61a" "#c49619" "#3c98e0" "#e2468f" "#3cafa5" "#faf3e0"])
 '(xterm-color-names-bright
   ["#002732" "#db5823" "#62787f" "#60767e" "#8d9fa1" "#7a7ed2" "#9eacac" "#ffffee"]))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-clones-clone ((t (:background "black"))))
 '(org-clones-current-clone ((t (:background "orchid" :foreground "black"))))
 '(youdao-dictionary-posframe-tip-face ((t (:background "black" :foreground "grey")))))
