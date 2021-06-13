;;; init-utils
(use-package command-log-mode
  :ensure t)

(use-package winner-mode
  :ensure nil
  :hook (after-init . winner-mode))

(use-package aggressive-indent
  :ensure t
  :config
  (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode))

(use-package package-lint
  :ensure t)

(use-package vterm
  :ensure t)

(use-package vterm-toggle
  :ensure t
  :bind
  (("M-<f1>" . vterm-toggle)
   ("M-<f2>" . vterm-toggle-cd))
  :config
  (define-key vterm-mode-map (kbd "s-n") 'vterm-toggle-forward)
  (define-key vterm-mode-map (kbd "s-p") 'vterm-toggle-backward)
  (setq vterm-toggle-fullscreen-p nil)
  (add-to-list 'display-buffer-alist
	       '("^v?term.*"
		 (display-buffer-reuse-window display-buffer-in-side-window)
		 (side . bottom)
		 ;;(dedicated . t) ;dedicated is supported in emacs27
		 (reusable-frames . visible)
		 (window-height . 0.3))))

;;-----------------------------------------------

(defun my/video-compress-and-convert (video new)
  (interactive "fvideo path: \nfnew item name (eg. exam.mp4, exam.gif) : ")
  (let ((video-format (cadr (split-string (file-name-nondirectory new) "\\."))))
    (if (string= video-format "gif")
	(progn
	  (shell-command
	   (concat "ffmpeg -i " video " -r 5 " new))
	  (message "%s convert to %s successfully!" video new))
      (progn
	(shell-command
	 (concat "ffmpeg -i " video " -vcodec libx264 -b:v 5000k -minrate 5000k -maxrate 5000k -bufsize 4200k -preset fast -crf 20 -y -acodec libmp3lame -ab 128k " new))
	(message "%s compress and convert to %s successfully!" video new)))))

(use-package quelpa
  :ensure t
  :config
  (use-package quelpa-use-package :ensure t)
  (setq quelpa-update-melpa-p nil)
  (setq quelpa-self-upgrade-p nil)
  (setq quelpa-upgrade-interval 30))

;; count words
(defvar wc-regexp-chinese-char-and-punc
  (rx (category chinese)))
(defvar wc-regexp-chinese-punc
  "[。，！？；：「」『』（）、【】《》〈〉※—]")
(defvar wc-regexp-english-word
  "[a-zA-Z0-9-]+")

(defun my/word-count ()
  "「較精確地」統計中/日/英文字數。
- 文章中的註解不算在字數內。
- 平假名與片假名亦包含在「中日文字數」內，每個平/片假名都算單獨一個字（但片假
  名不含連音「ー」）。
- 英文只計算「單字數」，不含標點。
- 韓文不包含在內。

※計算標準太多種了，例如英文標點是否算入、以及可能有不太常用的標點符號沒算入等
。且中日文標點的計算標準要看 Emacs 如何定義特殊標點符號如ヴァランタン・アルカン
中間的點也被 Emacs 算為一個字而不是標點符號。"
  (interactive)
  (let* ((v-buffer-string
          (progn
            (if (eq major-mode 'org-mode) ; 去掉 org 文件的 OPTIONS（以#+開頭）
                (setq v-buffer-string (replace-regexp-in-string "^#\\+.+" ""
								(buffer-substring-no-properties (point-min) (point-max))))
              (setq v-buffer-string (buffer-substring-no-properties (point-min) (point-max))))
            (replace-regexp-in-string (format "^ *%s *.+" comment-start) "" v-buffer-string)))
                                        ; 把註解行刪掉（不把註解算進字數）。
         (chinese-char-and-punc 0)
         (chinese-punc 0)
         (english-word 0)
         (chinese-char 0))
    (with-temp-buffer
      (insert v-buffer-string)
      (goto-char (point-min))
      ;; 中文（含標點、片假名）
      (while (re-search-forward wc-regexp-chinese-char-and-punc nil :no-error)
        (setq chinese-char-and-punc (1+ chinese-char-and-punc)))
      ;; 中文標點符號
      (goto-char (point-min))
      (while (re-search-forward wc-regexp-chinese-punc nil :no-error)
        (setq chinese-punc (1+ chinese-punc)))
      ;; 英文字數（不含標點）
      (goto-char (point-min))
      (while (re-search-forward wc-regexp-english-word nil :no-error)
        (setq english-word (1+ english-word))))
    (setq chinese-char (- chinese-char-and-punc chinese-punc))
    ;;  (message
    ;;      (format "中日文字數（不含標點）：%s
    ;; 中日文字數（包含標點）：%s
    ;; 英文字數（不含標點）：%s
    ;; =======================
    ;; 中英文合計（不含標點）：%s"
    ;;              chinese-char chinese-char-and-punc english-word
    ;;              (+ chinese-char english-word)))
    (+ chinese-char english-word)))

;;----------------------------------------------------------------------
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
;;--------------------------------------------------------------------
(defvar my-mood-diary-file "~/iCloud/blog_site/org/include/diary.org")
(defun my/mood-diary-quick-capture ()
  (interactive)
  (find-file my-mood-diary-file)
  (with-current-buffer (buffer-name)
    (goto-char (point-min))
    (re-search-forward "-----")
    (previous-line)
    (end-of-line)
    (insert "\n-----\n**")
    (backward-char)
    (my/insert-current-time)
    (forward-char)
    (insert "\n\n")))
(defun my/habit-recording ()
  (interactive)
  (find-file "~/iCloud/program_org/habit-recording-2020.org"))
(global-set-key (kbd "C-c m d") 'my/mood-diary-quick-capture)
(global-set-key (kbd "C-c m h") 'my/habit-recording)

;;-------------------------------------------------------------------
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
  (setq auto-save-slient nil) ;; 自动保存的时候静悄悄的， 不要打扰我
  (setq auto-save-delete-trailing-whitespace nil)
  (setq auto-save-disable-predicates
        '((lambda ()
            (string-suffix-p
             "gpg"
             (file-name-extension (buffer-name)) t)))))

(use-package paredit
  ;; check if the parens is matched
  :ensure t
  :defer t)

(use-package which-key
  :ensure t
  :hook (after-init . which-key-mode)
  :init (setq which-key-idle-delay 0.5))

;;google translate
;; (use-package go-translate
;;   :ensure t
;;   :init (setq go-translate-base-url "https://translate.google.cn"
;; 	      go-translate-local-language "zh-CN"))

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
	'(("腾讯视频" "https://v.qq.com/x/search/?q=%s" nil)
	  ("Google" "http://www.google.com/search?q=%s" nil)
	  ("Youtube" "http://www.youtube.com/results?search_query=%s" nil)
	  ("Bilibili" "https://search.bilibili.com/all?keyword=%s" nil)
          ("Zhihu" "https://www.zhihu.com/search?type=content&q=%s" nil)
	  ("Stackoveflow" "http://stackoverflow.com/search?q=%s" nil)
	  ("Sogou" "https://www.sogou.com/web?query=%s" nil)
	  ("Github" "https://github.com/search?q=%s" nil)
	  ("Melpa" "https://melpa.org/#/?q=%s" nil)
	  ("Emacs-China" "https://emacs-china.org/search?q=%s" nil)
	  ("EmacsWiki" "https://www.emacswiki.org/emacs/%s" nil)
	  ("Wiki-zh" "https://zh.wikipedia.org/wiki/%s" nil)
	  ("Wiki-en" "https://en.wikipedia.org/wiki/%s" nil)
	  ))
  :bind (("C-c w u" . browse-url)
	 ("C-c w w" . search-web)
	 ("C-c w p" . search-web-at-point)
	 ("C-c w r" . search-web-region)))

;; use xwidget-webkit
;; (setq browse-url-browser-function 'xwidget-webkit-browse-url)
;; (defun browse-url-default-browser (url &rest args)
;;   "Override `browse-url-default-browser' to use `xwidget-webkit' URL ARGS."
;;   (xwidget-webkit-browse-url url args))
;;(define-key xwidget-webkit-mode-map (kbd "C-c w c") 'xwidget-webkit-copy-selection-as-kill)
;;(define-key xwidget-webkit-mode-map (kbd "C-c w k") 'xwidget-webkit-current-url-message-kill)


(use-package browse-at-remote
  :ensure t
  :bind ("C-c w g" . browse-at-remote))

;; (use-package proxy-mode
;;   :ensure t
;;   :defer 5
;;   :init
;;   (setq proxy-mode-socks-proxy '("socks5" "127.0.0.1" 1086 5))
;;   (setq url-gateway-local-host-regexp
;; 	(concat "\\`" (regexp-opt '("localhost" "127.0.0.1")) "\\'")))

(use-package darkroom
  :ensure t
  :defer t
  :bind (("C-c d" . darkroom-tentative-mode)))

(use-package password-generator
  :ensure t)

(defun file-contents (filename)
  (interactive "fFind file: ")
  (with-temp-buffer
    (insert-file-contents filename) ;; 先将文件内容插入临时buffer，再读取内容
    (buffer-substring-no-properties (point-min) (point-max))))

(defun chunyang-scratch-save ()
  (ignore-errors
    (with-current-buffer "*scratch*"
      (write-region nil nil (concat user-emacs-directory "scratch")))))

(defun chunyang-scratch-restore ()
  (let ((f (concat user-emacs-directory "scratch")))
    (when (file-exists-p f)
      (with-current-buffer "*scratch*"
	(erase-buffer)
	(insert-file-contents f)))))

(add-hook 'kill-emacs-hook #'chunyang-scratch-save)
(add-hook 'after-init-hook #'chunyang-scratch-restore)
;;-----------------------------
(add-hook 'focus-in-hook 'my/mac-switch-input-source)
(defun my/mac-switch-input-source ()
  (interactive)
  (shell-command
   "osascript -e 'tell application \"System Events\" to tell process \"SystemUIServer\"
      set currentLayout to get the value of the first menu bar item of menu bar 1 whose description is \"text input\"
      if currentLayout is not \"ABC\" then
        tell (1st menu bar item of menu bar 1 whose description is \"text input\") to {click, click (menu 1'\"'\"'s menu item \"ABC\")}
      end if
    end tell' &>/dev/null")
  (message "Input source has changed to ABC!"))

(defun my/personal-summary (x)
  (interactive "swhich type of summary (w->week | m->month | y->year): ")
  (let* ((year (format-time-string "%Y"))
	 (month (format-time-string "%m"))
	 (week (format-time-string "%W"))
	 (week-file (concat "~/iCloud/program_org/" year "-week-summary-" week ".org"))
	 (month-file (concat "~/iCloud/program_org/" year "-month-summary-" month ".org"))
	 (year-file (concat "~/iCloud/program_org/" year "-year-summary.org"))
	 (org-head
	  (concat "#+DATE: " (format-time-string "%F") "\n"
		  "#+CATEGORY: 总结
#+STARTUP: showall
#+OPTIONS: toc:nil H:2 num:0
#+HTML_HEAD: <link rel=\"stylesheet\" type=\"text/css\" href=\"https://geekinney.com/assets/css/light.css\"/>\n
")))
    (with-temp-buffer
      (cond ((string= x "w")
	     (insert (concat "#+TITLE: " year "年" week "周总结\n"))
	     (insert org-head)
	     (insert "* 本周总结\n* 下周规划")
	     (write-file week-file))
	    ((string= x "m")
	     (insert (concat "#+TITLE: " year "年" month "月总结\n"))
	     (insert org-head)
	     (insert "* 本月总结\n* 下月规划")
	     (write-file month-file))
	    ((string= x "y")
	     (insert (concat "#+TITLE: " year "年度总结\n"))
	     (insert org-head)
	     (insert "* 年度总结\n* 明年规划")
	     (write-file year-file))))))

(defun xah-open-in-external-app (&optional @fname)
  "Open the current file or dired marked files in external app.
The app is chosen from your OS's preference.
When called in emacs lisp, if @fname is given, open that.
URL `http://ergoemacs.org/emacs/emacs_dired_open_file_in_ext_apps.html'
Version 2019-11-04"
  (interactive)
  (let* (($file-list
	  (if @fname
	      (progn (list @fname))
	    (if (string-equal major-mode "dired-mode")
		(dired-get-marked-files)
	      (list (buffer-file-name)))))
	 ($do-it-p (if (<= (length $file-list) 5)
		       t
		     (y-or-n-p "Open more than 5 files? "))))
    (when $do-it-p
      (cond
       ((string-equal system-type "windows-nt")
	(mapc
	 (lambda ($fpath)
	   (w32-shell-execute "open" $fpath))
	 $file-list))
       ((string-equal system-type "darwin")
	(mapc
	 (lambda ($fpath)
	   (shell-command
	    (concat "open " (shell-quote-argument $fpath))))
	 $file-list))
       ((string-equal system-type "gnu/linux")
	(mapc
	 (lambda ($fpath) (let ((process-connection-type nil))
			    (start-process "" nil "xdg-open" $fpath)))
	 $file-list))))))

(require 'dired)
(define-key dired-mode-map (kbd "<C-return>") 'xah-open-in-external-app)

(provide 'init-utils)
;;; init-utils.el ends here
