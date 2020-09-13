;; (use-package org-panes
;;   :load-path "~/.emacs.d/site-lisp/org-panes.el")

;;体验要比multi-term好很多
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
	   (concat "ffmpeg -i " video " -r 15 " new))
	  (message "%s convert to %s successfully!" video new))
      (progn
	(shell-command
	 (concat "ffmpeg -i " video " -vcodec libx264 -b:v 5000k -minrate 5000k -maxrate 5000k -bufsize 4200k -preset fast -crf 20 -y -acodec libmp3lame -ab 128k " new))
	(message "%s compress and convert to %s successfully!" video new))
      )
    ))

;; -------------------------------------------------------
(load-file "~/.emacs.d/elpa/smartparens-20191015.1754/smartparens.el")
(require 'smartparens)
(load-file "~/iCloud/hack/pp-html/pp-html.el")

(load-file "~/iCloud/hack/geekblog/geekblog.el")
(load-file "~/iCloud/hack/geekblog/geekblog-utils.el")
(load-file "~/iCloud/hack/geekblog/geekblog-vars.el")

(setq repl-string-list
      '(("old" "new")
	("test" "测试")
	("错误" "right")
	("隔开你" "戈楷旎")))

(setq repl-regexp-list
      '(("\\." "。")))

(setq repl-file "~/replace.txt")

(defun replall--read-pair-from-file ()
  (let ((repl-list '()))
    (with-temp-buffer
      (insert-file-contents repl-file)
      (goto-char (point-min))
      (while (< (point) (point-max))
	(setq repl-pair (split-string (thing-at-point 'line) "[ \f\t\n\r\v]+" t "[ \f\t\n\r\v]+"))
	(if (null repl-pair)
	    (next-line)
	  (next-line)
	  (setq repl-list (append repl-list (list repl-pair))))))
    repl-list))

(defun replall--get-repl-string-list ()
  (if (bound-and-true-p repl-string-list)
      repl-string-list
    (replall--read-pair-from-file)))

(defun replall--get-repl-regexp-list ()
  (if (bound-and-true-p repl-regexp-list)
      repl-regexp-list
    (message "please set variable 'repl-regexp-list'!")))

(defun replall--string (file lst)
  (with-temp-buffer
    (insert-file-contents file)
    (goto-char (point-min))
    (dolist (pair lst)
      (while (search-forward (car pair) nil t)
	(replace-match (cadr pair)))
      (goto-char (point-min)))
    (write-file file)))

(defun replall--regexp (file lst)
  (with-temp-buffer
    (insert-file-contents file)
    (goto-char (point-min))
    (dolist (pair lst)
      (while (re-search-forward (car pair) nil t)
	(replace-match (cadr pair)))
      (goto-char (point-min)))
    (write-file file)))

(defun replall-string-in-curr-buffer ()
  (interactive)
  (let ((curr-file (buffer-file-name (current-buffer)))
	(repl-list (replall--get-repl-string-list)))
    (replall--string curr-file repl-list)))

(defun replall-regexp-in-curr-buffer ()
  (interactive)
  (let ((curr-file (buffer-file-name (current-buffer)))
	(repl-list (replall--get-repl-regexp-list)))
    (replall--regexp curr-file repl-list)))

(defun replall-string-in-file (file repl)
  (interactive "fchoose a file to be processed: ")
  (let ((repl-list (replall--get-repl-string-list)))
    (replall--string file repl-list)))

(defun replall-regexp-in-file (file repl)
  (interactive "fchoose a file to be processed: ")
  (let ((repl-list (replall--get-repl-regexp-list)))
    (replall--regexp file repl-list)))

(defun replall--get-real-files-in-dir (files)
  (let (real-files)
    (dolist (file files)
      (when (not (or (string= "." (substring post 0 1))
		     (string= "#" (substring post 0 1))
		     (string= "~" (substring post 0 1))))
	(push file real-files)))
    real-files))

(defun replall-string-in-directory (dir)
  (interactive "Dchoose a directory to be processed: ")
  (let* ((repl-list (replall--get-repl-string-list))
	(files (directory-files dir))
	(real-files (replall--get-real-files-in-dir files)))
    (dolist (file real-files)
      (replall--string file repl-list))))

(defun replall-regexp-in-directory (dir)
  (interactive "Dchoose a directory to be processed: ")
  (let* ((repl-list (replall--get-repl-regexp-list))
	(files (directory-files dir))
	(real-files (replall--get-real-files-in-dir files)))
    (dolist (file real-files)
      (replall--regexp file repl-list))))

(defun replall-string (type)
  (interactive "sreplace string: 1.in current buffer  2.in a file  3.in a directory (input 1~3): ")
  (cond
   ((string= type "1")
    (replall-string-in-curr-buffer))
   ((string= type "2")
    (call-interactively #'replall-string-in-file))
   ((string= type "3")
    (call-interactively #'replall-string-in-directory))
   (t (message "please input 1~3!"))))

(defun replall-regexp (type)
  (interactive "sreplace regexp: 1.in current buffer  2.in a file  3.in a directory (input 1~3): ")
  (cond
   ((string= type "1")
    (replall-regexp-in-curr-buffer))
   ((string= type "2")
    (call-interactively #'replall-regexp-in-file))
   ((string= type "3")
    (call-interactively #'replall-regexp-in-directory))
   (t (message "please input 1~3!"))))
;;------------------------------------------------------
(provide 'init-test)
