;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Sync part of emacs config
(defvar gk/emacs-config-list '("init-hack.el"))
(defun gk/emacs-config-files ()
  (mapcar (lambda (el)
            (expand-file-name el (concat user-emacs-directory "elisp/")))
          gk/emacs-config-list))
(gk/emacs-config-files)
(defun gk/push-emacs-config ()
  )
(defun gk/sync-emacs-config ()
  "Sync part of the emacs config between different OS."
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro map-with-files-in-dir (dir &rest body)
  `(let ((files (directory-files ,dir t ".+\.md$")))
     (dolist (file files)
       (with-current-buffer (find-file-noselect file)
         ,@body))))

;; (macroexpand
;;  (map-with-files-in-dir
;;   "c:/Users/26289/geekblog/content/post"
;;   (save-excursion
;;     (goto-char (point-min))
;;     )))

;; (map-with-files-in-dir
;;  "c:/Users/26289/geekblog/content/post"
;;  (save-excursion
;;    (goto-char (point-min))
;;    (message "hello")))

(defun hugo-meta-to-pelican-meta ()
  (let* ((dir "c:/Users/26289/geekblog/content/post")
         (files (directory-files dir t)))
    (dolist (file files)
      (with-current-buffer (find-file-noselect)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Gkroam  to Gkwiki
(defun gkroam-file-content (title)
  (let* ((page (gkroam--get-page title))
         (file (when page (gkroam--get-file page))))
    (if file
        (with-current-buffer (find-file-noselect file)
          (save-restriction
            (gkroam--narrow-to-content)
            (save-excursion
              (goto-char (point-min))
              (when (re-search-forward "#\\+TITLE:.+" nil t)
                (string-trim (buffer-substring-no-properties (point) (point-max)))))))
      (user-error "No such gkroam page: %s" title))))

;; (gkroam-file-content "Aug 26, 2022")

(defun md-wiki-content-replace-or-insert ()
  )

(defun gkroam-to-gkwiki (roam-title wiki-title)
  (let ((roam-content (gkroam-file-content roam-title))
        (wiki-file (md-wiki-page-file wiki-title)))
    (with-file-buffer wiki-file
      (let (beg (end (point-max)))
        (if (re-search-forward (concat "^# " roam-title) nil t)
            (progn
              (setq beg (line-beginning-position))
              (save-excursion
                (when (re-search-forward "^# .+" nil t)
                  (setq end (line-beginning-position))))
              (delete-region beg end)
              (insert "# " roam-title "\n" roam-content "\n\n"))
          (when (re-search-forward "^---.*" nil t 4)
            (insert "\n# " roam-title "\n" roam-content "\n")))))))

(defun daily-page-to-mdwiki (&optional date)
  (interactive)
  (let ((title (or date (format-time-string "%b %d, %Y"))))
    (gkroam-to-gkwiki title "Daily Page")))

(provide 'init-hack)
