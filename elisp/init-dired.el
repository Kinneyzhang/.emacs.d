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

(define-key dired-mode-map (kbd "<C-return>") 'xah-open-in-external-app)

(provide 'init-dired)
