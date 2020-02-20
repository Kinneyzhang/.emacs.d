;; (use-package org-panes
;;   :load-path "~/.emacs.d/site-lisp/org-panes.el")

;; 体验要比multi-term好很多
(use-package vterm
  :ensure t
  )

(use-package vterm-toggle
  :ensure t
  :bind
  (("<f2>" . vterm-toggle)
   ("C-<f2>" . vterm-toggle-cd))
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
		 (window-height . 0.3)))
  )

(defun my-dnd-func (event)
  (interactive "e")
  (goto-char (nth 1 (event-start event)))
  (x-focus-frame nil)
  (let* ((payload (car (last event)))
         (type (car payload))
         (fname (cadr payload))
         (img-regexp "\\(png\\|jp[e]?g\\)\\>"))
    (cond
     ;; insert image link
     ((and  (eq 'drag-n-drop (car event))
            (eq 'file type)
            (string-match img-regexp fname))
      (insert (format "[[%s]]" fname))
      (org-display-inline-images t t))
     ;; insert image link with caption
     ((and  (eq 'C-drag-n-drop (car event))
            (eq 'file type)
            (string-match img-regexp fname))
      (insert "#+ATTR_ORG: :width 300\n")
      (insert (concat  "#+CAPTION: " (read-input "Caption: ") "\n"))
      (insert (format "[[%s]]" fname))
      (org-display-inline-images t t))
     ;; C-drag-n-drop to open a file
     ((and  (eq 'C-drag-n-drop (car event))
            (eq 'file type))
      (find-file fname))
     ((and (eq 'M-drag-n-drop (car event))
           (eq 'file type))
      (insert (format "[[attachfile:%s]]" fname)))
     ;; regular drag and drop on file
     ((eq 'file type)
      (insert (format "[[%s]]\n" fname)))
     (t
      (error "I am not equipped for dnd on %s" payload)))))


(define-key org-mode-map (kbd "<drag-n-drop>") 'my-dnd-func)
(define-key org-mode-map (kbd "<C-drag-n-drop>") 'my-dnd-func)
(define-key org-mode-map (kbd "<M-drag-n-drop>") 'my-dnd-func)
;;----------------------------------------------

;; (html-parse-single-list '("div" :class "post-div"
;; 			  ("h3" :class "hello" ("a" :href "url" "post-title"))
;; 			  ("p" "digest")
;; 			  ("code" ("a" :href "url" "tag"))
;; 			  ("span" "date")
;; 			  ))

(defvar html-parse-single-tag-list
  '("br" "hr" "img" "input" "meta" "link" "param"))

(defun html-parse-single-list (list)
  (interactive)
  (let ((tag (car list))
	(plist (cdr list))
	(alist (html-parse-get-alist (cdr list)))
	)
    (with-current-buffer (get-buffer-create "*html-parse*")
      (my/insert-html-tag-with-attr tag alist)
      (progn
	(setq inner-text (html-parse-get-inner-text plist))
	(if (eq nil inner-text)
	    ()
	  (insert (html-parse-get-inner-text plist))))
      (progn
	(setq html-list (html-parse-get-html-list plist))
	(if (eq nil html-list)
	    (forward-char (+ 3 (length tag)))
	  (html-parse-single-list html-list)))
      (buffer-substring-no-properties (point-min) (point-max)))
    ))

(defun html-parse-get-alist (plist)
  "将html标签的属性转化为alist形式"
  ;; nil也是symbol类型
  (if (or (null plist) (not (symbolp (car plist)))) 
      '()
    (cons
     (list (substring (symbol-name (car plist)) 1) (cadr plist))
     (html-parse-get-alist (cddr plist)))))

(defun html-parse-get-inner-text (plist)
  "获取html标签内部的文本"
  (let ((inner-text nil))
    (if (and (symbolp (car plist)) (not (null plist)))
	(setq inner-text (html-parse-get-inner-text (cddr plist)))
      (progn
	(if (listp (car plist))
	    (setq inner-text nil))
	(if (or (stringp (car plist)) (numberp (car plist)))
	    (setq inner-text (car plist)))
	))
    inner-text))
;; (html-parse-get-inner-text '(:class "class" "heello" ("tag")))

(defun html-parse-get-html-list (plist)
  "获取新的list"
  (let ((plist plist))
    (if (and (symbolp (car plist)) (not (null plist)))
	(setq plist (html-parse-get-html-list (cddr plist)))
      (progn
	(if (or (stringp (car plist)) (numberp (car plist)))
	    (setq plist (cdr plist)))
	(if (listp (car plist))
	    (setq plist (car plist)))
	(if (null plist)
	    (setq plist))
	))
    plist))
;;-----------------------------------------------
(defun my/video-compress-and-convert (video new)
  (interactive "fvideo path: \nfnew item path: ")
  (let ((video-format (cadr (split-string video "\\."))))
    (if (string= video-format "gif")
	(progn
	  (shell-command (concat "ffmpeg -i " video " -r 5 " new))
	  (message "%s convert to %s successfully!" video new))
      (progn
	(shell-command
	 (concat "ffmpeg -i " video " -vcodec libx264 -b:v 5000k -minrate 5000k -maxrate 5000k -bufsize 4200k -preset fast -crf 20 -y -acodec libmp3lame -ab 128k " new))
	(message "%s compress and convert to %s successfully!" video new))
      )
    ))
;;---------------------------------------------------

(provide 'init-test)

