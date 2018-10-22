;;orgmode 配置

(setq org-src-fontify-natively t)

(setq org-agenda-files '("~/org"))

;;启动时加载org-agenda
;; (add-hook 'after-init-hook 'org-agenda-list)

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/gtd.org" "Tasks")
	 "* TODO [#B] %?\n  %i\n"
	 :empty-lines 1)
	("j" "Journal" entry (file+datetree "~/org/journal.org")
	 "* %?\nEntered on %U\n %i\n")
	))

;;(setq org-capture-templates 'init-org)

;;config for org-projectile
(use-package org-projectile
  :bind (("C-c n p" . org-projectile-project-todo-completing-read)
         ("C-c c" . org-capture))
  :config
  (progn
    (setq org-projectile-projects-file
          "~/org/gtd.org")
    (setq org-agenda-files (append org-agenda-files (org-projectile-todo-files)))
    (push (org-projectile-project-todo-entry) org-capture-templates))
  :ensure t)

;;获取当前浏
(defun kinney/retrieve-chrome-current-tab-url()
  "Get the URL of the active tab of the first window"
  (interactive)
  (let ((result (do-applescript
		 (concat
		  "set frontmostApplication to path to frontmost application\n"
		  "tell application \"Google Chrome\"\n"
		  " set theUrl to get URL of active tab of first window\n"
		  " set theResult to (get theUrl) \n"
		  "end tell\n"
		  "activate application (frontmostApplication as text)\n"
		  "set links to {}\n"
		  "copy theResult to the end of links\n"
		  "return links as string\n"))))
    (format "%s" (s-chop-suffix "\"" (s-chop-prefix "\"" result)))))

;;设置换行
(setq truncate-lines t)
(defun my-org-mode ()
  (setq truncate-lines nil)
  )
(add-hook 'org-mode-hook 'my-org-mode)

;;插入图片
(defun my-org-screenshot ()
  "Take a screenshot into a time stamped unique-named file in the
same directory as the org-buffer and insert a link to this file."
  (interactive)
  (setq filename
        (concat
         (make-temp-name
          (concat (file-name-nondirectory (buffer-file-name))
                  "_"
                  (format-time-string "%Y%m%d_%H%M%S_")) ) ".png"))
  (call-process "screencapture" nil nil nil "-i" filename)
  (insert (concat "[[./" filename "]]"))
  (org-display-inline-images))

(provide 'init-org)
