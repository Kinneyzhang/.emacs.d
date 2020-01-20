;;; init-utils

;; thyme clock
(defun my/thyme-start ()
  "start thyme clock"
  (interactive)
  (do-applescript
   "tell application \"Thyme\" 
   start 
   end tell"))

(defun my/thyme-pause ()
  "pause thyme clock"
  (interactive)
  (do-applescript
   "tell application \"Thyme\" 
   pause
   end tell"))

(defun my/thyme-finish ()
  "stop thyme clock"
  (interactive)
  (do-applescript
   "tell application \"Thyme\" 
   stop
   end tell"))

(defalias 'mts' #'my/thyme-start)
(defalias 'mtp' #'my/thyme-pause)
(defalias 'mtf' #'my/thyme-finish)

;; generate qrcode
(setq lexical-binding t)
(defun my/qr-encode (str &optional buf)
  "Encode STR as a QR code.
Return a new buffer or BUF with the code in it."
  (interactive "MString to encode: ")
  (let ((buffer (get-buffer-create (or buf "*QR Code*")))
        (format (if (display-graphic-p) "PNG" "UTF8"))
        (inhibit-read-only t))
    (with-current-buffer buffer
      (delete-region (point-min) (point-max)))
    (make-process
     :name "qrencode" :buffer buffer
     :command `("qrencode" ,str "-t" ,format "-o" "-")
     :coding 'no-conversion
     ;; seems only the filter function is able to move point to top
     :filter (lambda (process string)
               (with-current-buffer (process-buffer process)
                 (insert string)
                 (goto-char (point-min))
                 (set-marker (process-mark process) (point))))
     :sentinel (lambda (process change)
                 (when (string= change "finished\n")
                   (with-current-buffer (process-buffer process)
                     (cond ((string= format "PNG")
                            (image-mode)
                            (image-transform-fit-to-height))
                           (t ;(string= format "UTF8")
                            (text-mode)
                            (decode-coding-region (point-min) (point-max) 'utf-8)))))))
    (when (called-interactively-p 'interactive)
      (display-buffer buffer))
    buffer))
;; =========================
(use-package general
  :ensure t)

(use-package auto-save
  :load-path "~/.emacs.d/site-lisp/auto-save"
  :config
  (auto-save-enable)  ;; 开启自动保存功能。
  (setq auto-save-slient t) ;; 自动保存的时候静悄悄的， 不要打扰我
  (setq auto-save-delete-trailing-whitespace nil))


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

;;google translate
(use-package google-translate
  :ensure t
  :init
  (setq google-translate-base-url
	"http://translate.google.cn/translate_a/single")
  (setq google-translate-listen-url
	"http://translate.google.cn/translate_tts")
  (setq google-translate-backend-method 'curl)
  (setq google-translate-default-source-language "en")
  (setq google-translate-default-target-language "zh-CN")  
  :config
  (when (and (string-match "0.11.18"
			   (google-translate-version))
             (>= (time-to-seconds)
		 (time-to-seconds
                  (encode-time 0 0 0 23 9 2018))))
    (defun google-translate--get-b-d1 ()
      ;; TKK='427110.1469889687'
      (list 427110 1469889687))))

(use-package youdao-dictionary
  :ensure t
  :defer 5
  :bind (("C-c y y" . youdao-dictionary-search-at-point+)
  	 ("C-c y i" . youdao-dictionary-search-from-input))
  :init
  (setq url-automatic-caching t))

(use-package osx-dictionary
  :ensure t
  ;; :bind (("C-c y y" . osx-dictionary-search-word-at-point)
  ;; 	 ("C-c y i" . osx-dictionary-search-input))
  )

(use-package search-web
  :defer 5
  :ensure t
  :init
  (setq search-web-engines
	'(("Google" "http://www.google.com/search?q=%s" nil)
	  ("Youtube" "http://www.youtube.com/results?search_query=%s" nil)
	  ("Bilibili" "https://search.bilibili.com/all?keyword=%s" nil)
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

;; use xwidget-webkit
;; (setq browse-url-browser-function 'xwidget-webkit-browse-url)
;; (defun browse-url-default-browser (url &rest args)
;;   "Override `browse-url-default-browser' to use `xwidget-webkit' URL ARGS."
;;   (xwidget-webkit-browse-url url args))
;; (local-set-key (kbd "C-c w c") 'xwidget-webkit-copy-selection-as-kill)
;; (local-set-key (kbd "C-c w k") 'xwidget-webkit-current-url-message-kill)

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

(use-package darkroom
  :ensure t
  :defer t
  :bind (("C-c d" . darkroom-tentative-mode)))

(defun my/insert-current-time ()
  "Insert the current time"
  (interactive "*")
  (insert (format-time-string "%Y-%m-%d %H:%M:%S" (current-time))))

(defun my/insert-current-date ()
  "Insert the current time"
  (interactive "*")
  (insert (format-time-string "%b %d, %Y" (current-time))))

(global-set-key (kbd "C-c t t") 'my/insert-current-time)
(global-set-key (kbd "C-c t d") 'my/insert-current-date)

(use-package password-generator
  :ensure t)

(defun chunyang-scratch-save ()
  (ignore-errors
    (with-current-buffer "*scratch*"
      (write-region nil nil (concat config-dir "scratch")))))

(defun chunyang-scratch-restore ()
  (let ((f (concat config-dir "scratch")))
    (when (file-exists-p f)
      (with-current-buffer "*scratch*"
	(erase-buffer)
	(insert-file-contents f)))))

(add-hook 'kill-emacs-hook #'chunyang-scratch-save)
(add-hook 'after-init-hook #'chunyang-scratch-restore)


(provide 'init-utils)

;;; init-utils.el ends here
