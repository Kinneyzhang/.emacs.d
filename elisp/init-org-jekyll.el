;; ;;; init-org-jekyll
;; (setq org-publish-project-alist
;;       '(
;;         ("jekyll-post"
;;          :base-directory "~/iCloud/blog/_posts"
;;          :base-extension "org"
;;          :publishing-directory "~/iCloud/geekstuff/whiteglass/_posts"
;;          :recursive nil
;;          :publishing-function org-html-publish-to-html
;; 	 ;;; 注释的选项不做全局定义，在文件头部定义
;;          :with-toc nil
;;          ;; :headline-levels 4
;;          ;; :auto-preamble nil
;; 	 :table-of-contents nil
;;          ;; :section-numbers 2
;;          ;; :auto-sitemap nil
;;          :html-extension "html"
;;          :body-only t
;; 	 )

;; 	("jekyll-bookmark"
;; 	 :base-directory "~/iCloud/blog/_pages"
;;          :base-extension "org"
;;          :publishing-directory "~/iCloud/huxBlog/_includes/bookmark"
;;          :recursive nil
;;          :publishing-function org-html-publish-to-html
;; 	 ;;; 注释的选项不做全局定义，在文件头部定义
;;          :with-toc nil
;;          ;; :headline-levels 1
;;          ;; :auto-preamble nil
;;          ;; :auto-sitemap nil
;;          ;; :html-extension "html"
;;          :table-of-contents nil
;; 	 ;; :section-numbers nil
;; 	 :body-only t
;; 	 )
	
;;         ("jekyll-static"
;;          :base-directory "~/iCloud/blog/assets"
;;          :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|php"
;;          :publishing-directory "~/iCloud/huxBlog/assets"
;;          :recursive t
;;          :publishing-function org-publish-attachment)

;; 	("jekyll"
;;          :components ("jekyll-post" "jekyll-static"))
;;         ))

;; (defvar jekyll-directory (concat icloud-directory "blog/")
;;   "Path to Jekyll blog.")
;; (defvar jekyll-drafts-dir "_drafts/"
;;   "Relative path to drafts directory.")
;; (defvar jekyll-posts-dir "_posts/"
;;   "Relative path to posts directory.")
;; (defvar jekyll-post-ext ".org"
;;   "File extension of Jekyll posts.")
;; (defvar jekyll-post-template
;;   "#+STARTUP: showall indent\n#+STARTUP: hidestars\n#+begin_export html\n---\ndate: \nlayout: post\ntitle: %s\nsubtitle: \nauthor: Geekinney\nheader-img: \ntags: \ncatalog: \n---\n#+end_export\n\n"
;;   "Default template for Jekyll posts. %s will be replace by the post title.")

;; (defun jekyll-make-slug (s)
;;   "Turn a string into a slug."
;;   (replace-regexp-in-string
;;    " " "-" (downcase
;;             (replace-regexp-in-string
;;              "[^A-Za-z0-9 ]" "" s))))

;; (defun jekyll-yaml-escape (s)
;;   "Escape a string for YAML."
;;   (if (or (string-match ":" s)
;;           (string-match "\"" s))
;;       (concat "\"" (replace-regexp-in-string "\"" "\\\\\"" s) "\"")
;;     s))

;; (defun jekyll-draft-post (title)
;;   "Create a new Jekyll blog post."
;;   (interactive "sPost Title: ")
;;   (let ((draft-file (concat jekyll-directory jekyll-drafts-dir
;;                             (jekyll-make-slug title)
;;                             jekyll-post-ext)))
;;     (if (file-exists-p draft-file)
;;         (find-file draft-file)
;;       (find-file draft-file)
;;       (insert (format jekyll-post-template (jekyll-yaml-escape title))))))

;; (defun jekyll-publish-post ()
;;   "Move a draft post to the posts directory, and rename it so that it
;;  contains the date."
;;   (interactive)
;;   (cond
;;    ((not (equal
;;           (file-name-directory (buffer-file-name (current-buffer)))
;;           (concat jekyll-directory jekyll-drafts-dir)))
;;     (message "This is not a draft post."))
;;    ((buffer-modified-p)
;;     (message "Can't publish post; buffer has modifications."))
;;    (t
;;     (let ((filename
;;            (concat jekyll-directory jekyll-posts-dir
;;                    (format-time-string "%Y-%m-%d-")
;;                    (file-name-nondirectory
;;                     (buffer-file-name (current-buffer)))))
;;           (old-point (point)))
;;       (rename-file (buffer-file-name (current-buffer))
;;                    filename)
;;       (kill-buffer nil)
;;       (find-file filename)
;;       (set-window-point (selected-window) old-point)))))

;; (provide 'init-org-jekyll)
