;;; init-blog

(setq org-publish-project-alist
      '(("geekblog"
	 :base-extension "org"
	 :recursive nil
	 :base-directory "~/blog_site/org/"
	 :publishing-directory "~/blog_site/html/"
	 :publishing-function org-html-publish-to-html
	 :html-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"https://gongzhitaao.org/orgcss/org.css\"/>
<script src=\"https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.10.0/highlight.min.js\"></script>
<script>var hlf=function(){Array.prototype.forEach.call(document.querySelectorAll(\"pre.src\"),function(t){var e;e=t.getAttribute(\"class\").toLowerCase(),e=e.replace(/src-(\w+)/,\"src-$1 $1\"),console.log(e),t.setAttribute(\"class\",e),hljs.highlightBlock(t)})};addEventListener(\"DOMContentLoaded\",hlf);</script>
<link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.10.0/styles/googlecode.min.css\"/>"
	 ;; :with-toc t
	 ;; :headline-levels 4
	 ;; :table-of-contents nil
	 ;; :section-numbers nil
	 :auto-preamble t
	 :auto-sitemap nil
	 :html-extension "html"
	 :body-only nil
	 )))

;; (use-package org-static-blog
;;   :ensure t
;;   :init
;;   (setq org-static-blog-publish-title "Geekinney's Blog")
;;   (setq org-static-blog-publish-url "https://blog.geekinney.com/")
;;   (setq org-static-blog-publish-directory "~/blog_site/")
;;   (setq org-static-blog-posts-directory "~/blog_site/posts/")
;;   ;; (setq org-static-blog-drafts-directory "~/blog_site/drafts/")
;;   (setq org-static-blog-enable-tags t)
;;   ;; (setq org-export-with-toc nil)
;;   ;; (setq org-export-with-section-numbers nil)

;;   ;; This header is inserted into the <head> section of every page:
;;   ;;   (you will need to create the style sheet at
;;   ;;    ~/projects/blog/static/style.css
;;   ;;    and the favicon at
;;   ;;    ~/projects/blog/static/favicon.ico)
;;   (setq org-static-blog-page-header
;; 	"<meta name=\"author\" content=\"Kinney Zhang\">
;; <meta name=\"referrer\" content=\"no-referrer\">
;; <link href= \"static/style2.css\" rel=\"stylesheet\" type=\"text/css\" />
;; <link rel=\"icon\" href=\"static/favicon.ico\">")

;;   ;; This preamble is inserted at the beginning of the <body> of every page:
;;   ;;   This particular HTML creates a <div> with a simple linked headline
;;   (setq org-static-blog-page-preamble
;; 	"<div class=\"header\">
;; <a href=\"https://blog.geekinney.com\">Geekinney's Blog</a>
;; </div>")

;;   ;; This postamble is inserted at the end of the <body> of every page:
;;   ;;   This particular HTML creates a <div> with a link to the archive page
;;   ;;   and a licensing stub.
;;   (setq org-static-blog-page-postamble
;; 	"<div id=\"archive\"><a href=\"https://blog.geekinney.com/archive.html\">Other posts</a></div>
;; <center><a rel=\"license\" href=\"https://creativecommons.org/licenses/by-sa/3.0/\"><img alt=\"Creative Commons License\" style=\"border-width:0\" src=\"https://i.creativecommons.org/l/by-sa/3.0/88x31.png\" /></a><br /><span xmlns:dct=\"https://purl.org/dc/terms/\" href=\"https://purl.org/dc/dcmitype/Text\" property=\"dct:title\" rel=\"dct:type\">bastibe.de</span> by <a xmlns:cc=\"https://creativecommons.org/ns#\" href=\"https://bastibe.de\" property=\"cc:attributionName\" rel=\"cc:attributionURL\">Bastian Bechtold</a> is licensed under a <a rel=\"license\" href=\"https://creativecommons.org/licenses/by-sa/3.0/\">Creative Commons Attribution-ShareAlike 3.0 Unported License</a>.</center>"))


(provide 'init-blog)
