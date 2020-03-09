;; (use-package org-panes
;;   :load-path "~/.emacs.d/site-lisp/org-panes.el")

;; 体验要比multi-term好很多
(use-package vterm
  :ensure t
  )

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
	(message "%s compress and convert to %s successfully!" video new))
      )
    ))

(provide 'init-test)
