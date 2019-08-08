(use-package web-mode
  :defer t
  :ensure t
  :bind (("C-c ]" . emmet-next-edit-point)
         ("C-c [" . emmet-prev-edit-point)
         ("C-c o b" . browse-url-of-file))
  :mode
  (("\\.js\\'" . web-mode)
   ("\\.html?\\'" . web-mode)
   ("\\.phtml?\\'" . web-mode)
   ("\\.tpl\\.php\\'" . web-mode)
   ("\\.[agj]sp\\'" . web-mode)
   ("\\.as[cp]x\\'" . web-mode)
   ("\\.erb\\'" . web-mode)
   ("\\.mustache\\'" . web-mode)
   ("\\.djhtml\\'" . web-mode)
   ("\\.vue\\'" . web-mode)
   ("\\.jsx$" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2)

  (setq web-mode-engines-alist
	'(("php"    . "\\.phtml\\'")
	  ("blade"  . "\\.blade\\.")
	  ("django"  . "\\.djhtml\\'")
	  ("django"  . "\\.html?\\'")))


  ;;change indent style
  (defun my-toggle-web-indent ()
    (interactive)
    (if (or (eq major-mode 'js-mode) (eq major-mode 'js2-mode))
	(progn
	  (setq js-indent-level (if (= js-indent-level 2) 4 2))
	  (setq js2-basic-offset (if (= js2-basic-offset 2) 4 2))))

    (if (eq major-mode 'web-mode)
	(progn (setq web-mode-markup-indent-offset (if (= web-mode-markup-indent-offset 2) 4 2))
	       (setq web-mode-css-indent-offset (if (= web-mode-css-indent-offset 2) 4 2))
	       (setq web-mode-code-indent-offset (if (= web-mode-code-indent-offset 2) 4 2))))
    (if (eq major-mode 'css-mode)
	(setq css-indent-offset (if (= css-indent-offset 2) 4 2)))

    (setq indent-tabs-mode nil))

  (global-set-key (kbd "C-c t i") 'my-toggle-web-indent)
  

  (add-hook 'web-mode-hook 'jsx-flycheck)

  ;; highlight enclosing tags of the element under cursor
  (setq web-mode-enable-current-element-highlight t)

  (defadvice web-mode-highlight-part (around tweak-jsx activate)
    (if (equal web-mode-content-type "jsx")
        (let ((web-mode-enable-part-face nil))
          ad-do-it)
      ad-do-it))

  (defun jsx-flycheck ()
    (when (equal web-mode-content-type "jsx")
      ;; enable flycheck
      (flycheck-select-checker 'jsxhint-checker)
      (flycheck-mode)))

  ;; editing enhancements for web-mode
  ;; https://github.com/jtkDvlp/web-mode-edit-element
  
  ;; (use-package web-mode-edit-element
  ;;   :ensure nil
  ;;   :config (add-hook 'web-mode-hook 'web-mode-edit-element-minor-mode))

  ;; snippets for HTML
  ;; https://github.com/smihica/emmet-mode
  (use-package emmet-mode
    :defer 5
    :ensure t
    :init (setq emmet-move-cursor-between-quotes t) ;; default nil
    :bind (("C-j" . emmet-expand-line))
    :diminish (emmet-mode . " e"))
  (add-hook 'web-mode-hook 'emmet-mode)

  (defun my-web-mode-hook ()
    "Hook for `web-mode' config for company-backends."
    (set (make-local-variable 'company-backends)
         '((company-tern company-css company-web-html company-files))))
  (add-hook 'web-mode-hook 'my-web-mode-hook)

  ;; Enable JavaScript completion between <script>...</script> etc.
  (defadvice company-tern (before web-mode-set-up-ac-sources activate)
    "Set `tern-mode' based on current language before running company-tern."
    (message "advice")
    (if (equal major-mode 'web-mode)
	(let ((web-mode-cur-language
	       (web-mode-language-at-pos)))
	  (if (or (string= web-mode-cur-language "javascript")
		  (string= web-mode-cur-language "jsx"))
	      (unless tern-mode (tern-mode))
	    (if tern-mode (tern-mode -1))))))
  (add-hook 'web-mode-hook 'company-mode)

  ;; to get completion data for angularJS
  (use-package ac-html-angular
    :ensure t
    :defer t)
  ;; to get completion for twitter bootstrap
  (use-package ac-html-bootstrap
    :ensure t
    :defer t)

  ;; to get completion for HTML stuff
  ;; https://github.com/osv/company-web
  (use-package company-web
    :ensure t)

  (add-hook 'web-mode-hook 'company-mode))

;; configure CSS mode company backends
(use-package css-mode
  :defer 5
  :config
  (defun my-css-mode-hook ()
    (set (make-local-variable 'company-backends)
         '((company-css company-dabbrev-code company-files))))
  (add-hook 'css-mode-hook 'my-css-mode-hook)
  (add-hook 'css-mode-hook 'company-mode))

;; impatient mode - Live refresh of web pages
;; https://github.com/skeeto/impatient-mode
(use-package impatient-mode
  :defer 5
  :ensure t
  :diminish (impatient-mode . " i")
  :commands (impatient-mode))


(use-package web-beautify
  :ensure t
  :defer 5
  :config
  (eval-after-load 'js2-mode
    '(define-key js2-mode-map (kbd "C-c b") 'web-beautify-js))
  ;; Or if you're using 'js-mode' (a.k.a 'javascript-mode')
  (eval-after-load 'js
    '(define-key js-mode-map (kbd "C-c b") 'web-beautify-js))

  (eval-after-load 'json-mode
    '(define-key json-mode-map (kbd "C-c b") 'web-beautify-js))

  (eval-after-load 'sgml-mode
    '(define-key html-mode-map (kbd "C-c b") 'web-beautify-html))

  (eval-after-load 'web-mode
    '(define-key web-mode-map (kbd "C-c b") 'web-beautify-html))

  (eval-after-load 'css-mode
    '(define-key css-mode-map (kbd "C-c b") 'web-beautify-css)))

(provide 'lang-web)
