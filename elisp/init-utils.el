;;; init-utils

(use-package paredit
  ;; check if the parens is matched
  :ensure t
  :defer t)

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package all-the-icons
  :load-path "~/.emacs.d/site-lisp/all-the-icons")

(use-package youdao-dictionary
  :ensure t
  :defer 5
  ;; :bind (("C-c y y" . youdao-dictionary-search-at-point)
  ;; 	 ("C-c y i" . youdao-dictionary-search-from-input))
  :init
  (setq url-automatic-caching t))

(use-package osx-dictionary
  :ensure t
  :bind (("C-c y y" . osx-dictionary-search-word-at-point)
	 ("C-c y i" . osx-dictionary-search-input))
  )

(use-package search-web
  :defer t
  :ensure t
  :init
  (setq search-web-engines
	'(("Google" "http://www.google.com/search?q=%s" nil)
	  ("Youtube" "http://www.youtube.com/results?search_query=%s" nil)
	  ("Stackoveflow" "http://stackoverflow.com/search?q=%s" nil)
	  ("Sogou" "https://www.sogou.com/web?query=%s" nil)
	  ("Github" "https://github.com/search?q=%s" nil)
	  ("Melpa" "https://melpa.org/#/?q=%s" nil)
	  ("Emacs-China" "https://emacs-china.org/search?q=%s" nil)
	  ("EmacsWiki" "https://www.emacswiki.org/emacs/%s" nil)
	  ("Wiki-zh" "https://zh.wikipedia.org/wiki/%s" nil)
	  ("Wiki-en" "https://en.wikipedia.org/wiki/%s" nil)
	  ))
  :bind (("C-C w u" . browse-url)
	 ("C-c w w" . search-web)
	 ("C-c w p" . search-web-at-point)
	 ("C-c w r" . search-web-region)))

(use-package browse-at-remote
  :ensure t
  :bind ("C-c w g" . browse-at-remote))


(use-package proxy-mode
  :ensure t
  :defer 5
  :init
  (setq proxy-mode-socks-proxy '("geekinney.com" "124.156.188.197" 10808 5))
  (setq url-gateway-local-host-regexp
      (concat "\\`" (regexp-opt '("localhost" "127.0.0.1")) "\\'")))


(defun insert-current-date () 
  "Insert the current time" 
  (interactive "*")
  (insert (format-time-string "%B %d, %Y" (current-time))))

(global-set-key "\C-xt" 'insert-current-date)

(use-package darkroom
  :ensure t
  :defer t
  :bind (("C-c d" . darkroom-tentative-mode)))

;; (defun my/dark-mode ()
;;   (interactive)
;;   (set-window-margins (selected-window) 40 40))


(provide 'init-utils)

;;; init-utils.el ends here
