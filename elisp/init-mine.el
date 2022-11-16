;;; Set org-indent-mode and org-bullets-mode for org buffer in gk-org-prettify-dirs
(defvar gk-org-prettify-dirs '("c:/Users/26289/Asiainfo/陕西V8/"))

(defun gk/set-better-org ()
  (let ((file-dir (file-name-directory (buffer-file-name))))
    (when (member file-dir gk-org-prettify-dirs)
      (org-indent-mode 1)
      (org-bullets-mode 1))))

(add-hook 'org-mode-hook 'gk/set-better-org)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Prettify org buffer

(defvar gk/org-list-re
  "^ *\\([0-9]+[).]\\|[*+-]\\) \\(\\[[ X-]\\] \\)?"
  "Org list bullet and checkbox regexp.")

(defun gk/org-prettify-work-p ()
  (and (not (gkroam-work-p)) (eq major-mode 'org-mode)))

(defun gk/fontify-org-checkbox (notation)
  "Highlight org checkbox with NOTATION."
  (add-text-properties
   (match-beginning 2) (1- (match-end 2)) `(display ,notation)))

(defun gk/fontify-org-list (list checkbox)
  "Highlight org list, including bullet and checkbox."
  (with-silent-modifications
    (when list
      (add-text-properties (match-beginning 1) (match-end 1) '(display "•")))
    (when checkbox
      (when (match-beginning 2)
        (pcase (match-string-no-properties 2)
          ("[-] " (gk/fontify-org-checkbox "■"))
          ("[ ] " (gk/fontify-org-checkbox "□"))
          ("[X] " (gk/fontify-org-checkbox "■")))))))

(defun gk/org-list-fontify (beg end)
  "Highlight org list bullet between BEG and END."
  (save-excursion
    (goto-char beg)
    (while (re-search-forward gk/org-list-re end t)
      (if (string= (match-string-no-properties 1) "*")
          (unless (= (match-beginning 0) (match-beginning 1))
            (gk/fontify-org-list t t))
        (if (not (member (match-string-no-properties 1) '("-" "+" "*")))
            (gk/fontify-org-list nil t)
          (gk/fontify-org-list t t))))))

(defun gk/org-list-unfontify (beg end)
  (save-excursion
    (goto-char beg)
    (while (re-search-forward gk/org-list-re end t)
      (with-silent-modifications
        (remove-text-properties (match-beginning 0) (match-end 0) '(display nil))))))

(defun gk/org-preserve-list-fontify ()
  (save-selected-window
    (dolist (win (window-list))
      (select-window win)
      (when (gk/org-prettify-work-p)
        (gk/org-list-fontify (point-min) (point-max))))))

(defun gk/org-preserve-list-unfontify ()
  (save-selected-window
    (dolist (win (window-list))
      (select-window win)
      (when (gk/org-prettify-work-p)
        (gk/org-list-unfontify (point-min) (point-max))))))

(defvar gk/org-win-margin 2)

(defun gk/org-preserve-win-margin ()
  "Preserve pages' window margin."
  (save-selected-window
    (dolist (win (window-list))
      (select-window win)
      (when (gk/org-prettify-work-p)
        (set-window-margins (selected-window) gk/org-win-margin
                            gk/org-win-margin)))))

;;;###autoload
(define-minor-mode gk/org-prettify-mode
  "Minor mode for prettifying page."
  :global t
  :lighter ""
  :keymap nil
  (if gk/org-prettify-mode
      (progn
        (jit-lock-register #'gk/org-list-fontify)
        (add-hook 'window-configuration-change-hook 'gk/org-preserve-win-margin)
        ;; (gk/org-list-fontify (point-min) (point-max))
        (gk/org-preserve-list-fontify)
        (gk/org-preserve-win-margin))
    (jit-lock-unregister #'gk/org-list-fontify)
    (remove-hook 'window-configuration-change-hook 'gk/org-preserve-win-margin)
    (gk/org-preserve-list-unfontify))
  (jit-lock-refontify))

(defun electric-indent-mode-disable ()
  (electric-indent-mode -1))

(add-hook 'org-mode-hook 'electric-indent-mode-disable)
(add-hook 'org-mode-hook 'gk/org-prettify-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'init-mine)
