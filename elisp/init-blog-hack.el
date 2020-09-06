;;; init-blog
;;;==============================================================
;; https://gongzhitaao.org/orgcss/org.css

;; (defun org-html-src-block2 (src-block _contents info)
;;   "Transcode a SRC-BLOCK element from Org to HTML.
;; 		    CONTENTS holds the contents of the item.  INFO is a plist holding
;; 		    contextual information."
;;   (if (org-export-read-attribute :attr_html src-block :textarea)
;;       (org-html--textarea-block src-block)
;;     (let ((lang (org-element-property :language src-block))
;; 	  (code (org-html-format-code src-block info))
;; 	  (label (let ((lbl (and (org-element-property :name src-block)
;; 				 (org-export-get-reference src-block info))))
;; 		   (if lbl (format " id=\"%s\"" lbl) ""))))
;;       (if (not lang) (format "<pre><code class=\"example\"%s>\n%s</code></pre>" label code)
;; 	(format "<div class=\"col-auto\">\n%s%s\n</div>"
;; 		;; Build caption.
;; 		(let ((caption (org-export-get-caption src-block)))
;; 		  (if (not caption) ""
;; 		    (let ((listing-number
;; 			   (format
;; 			    "<span class=\"listing-number\">%s </span>"
;; 			    (format
;; 			     (org-html--translate "Listing %d:" info)
;; 			     (org-export-get-ordinal
;; 			      src-block info nil #'org-html--has-caption-p)))))
;; 		      (format "<label class=\"org-src-name\">%s%s</label>"
;; 			      listing-number
;; 			      (org-trim (org-export-data caption info))))))
;; 		;; Contents.
;; 		(format "<pre><code class=\"%s\"%s>%s</code></pre>"
;; 			lang label code))))))

;; (advice-add 'org-html-src-block :override 'org-html-src-block2)
;;-------------------------------------------------------------
;;--------------------------------------------------------------
(setq org-publish-project-alist
      `(("geekblog"
	 :base-extension "org"
	 :recursive nil
	 :base-directory ,blog-base-dir
	 :publishing-directory ,blog-publish-dir
	 :publishing-function org-html-publish-to-html
	 :preparation-function
	 (geekblog/generate-sitemap geekblog/generate-rss geekblog/generate-index-page geekblog/generate-archive-page geekblog/generate-category-page)
	 :completion-function geekblog/push-to-github
	 :body-only t
	 )))

(provide 'init-blog-hack)
