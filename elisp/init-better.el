;;; some better defaults
(setq inhibit-startup-message t) ;; 不显示启动信息
(setq ring-bell-function 'ignore) ;; 消除滑动到底部或顶部时的声音
(global-auto-revert-mode 1) ;; 自动加载更新内容
(setq make-backup-files nil) ;; 不允许备份
(setq auto-save-default nil) ;; 不允许自动保存
(setq auto-save-silent t)

(recentf-mode 1)
(delete-selection-mode 1)
(ido-mode 1)
(setq recentf-max-menu-items 10)
(global-hl-line-mode -1)
(show-paren-mode 1)
(setq delete-by-moving-to-trash t)

(setq scroll-step 1
      scroll-margin 0
      scroll-conservatively 10000)

(fset 'yes-or-no-p 'y-or-n-p) ;; 用y/s代替yes/no

(setq default-buffer-file-coding-system 'utf-8)
(setq bookmark-file-coding-system 'utf-8)
(setq magit-git-output-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(setq bookmark-save-flag 1)
(setq org-image-actual-width nil)
(setq show-trailing-whitespace t)

(setq ad-redefinition-action 'accept) ;; 在执行程序的时候，不需要确认
(setq org-confirm-babel-evaluate nil) ;; 设定文档中需要执行的程序类型，以下设置了R，python，latex和emcas-lisp
(setq exec-path-from-shell-check-startup-files nil)
(setq x-select-enable-primary nil) ;; t表示选中区域自动复制

(setq confirm-kill-emacs
      (lambda (prompt) (y-or-n-p-with-timeout "Whether quit Emacs:" 10 "y")))

;;全部递归拷贝删除文件夹中的文件
(setq dired-recursive-deletes 'always
      dired-recursive-copies 'always)

;;Handy way of getting back to previous places.
(bind-key "C-x p" 'pop-to-mark-command)
(setq set-mark-command-repeat-pop t)

(put 'dired-find-alternate-file 'disabled nil) ;; 避免每一级目录都产生一个buffer
(require 'dired-x)
(setq dired-dwim-target t)

(define-key global-map (kbd "C-h p") 'describe-text-properties)

;;Highlight parens when inside it
(define-advice show-paren-function (:around (fn) fix-show-paren-function)
  "Highlight enclosing parens."
  (cond ((looking-at-p "\\s(")
         (funcall fn))
	(t (save-excursion
	     (ignore-errors (backward-up-list))
	     (funcall fn)))))


;; indent buffer
(setq-default indent-tabs-mode nil)

(defun indent-buffer()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun indent-region-or-buffer()
  (interactive)
  (save-excursion
    (if (region-active-p)
	(progn
	  (indent-region (region-beginning) (region-end))
	  (message "Indent selected region."))
      (progn
	(indent-buffer)
	(message "Indent buffer.")))))

(use-package which-key
  :ensure t
  :hook (after-init . which-key-mode)
  :init (setq which-key-idle-delay 0.5))

(use-package youdao-dictionary
  :ensure t
  :defer 5
  :bind (("C-c y y" . youdao-dictionary-search-at-point+)
  	 ("C-c y i" . youdao-dictionary-search-from-input))
  :init
  (setq url-automatic-caching t))

(use-package search-web
  :defer 5
  :ensure t
  :init
  (setq search-web-engines
	'(("LeetCode" "https://leetcode.cn/search/?q=%s" nil)
          ("腾讯视频" "https://v.qq.com/x/search/?q=%s" nil)
	  ("Google" "http://www.google.com/search?q=%s" nil)
          ("Baidu" "https://www.baidu.com/s?wd=%s" nil)
	  ("Youtube" "http://www.youtube.com/results?search_query=%s" nil)
	  ("Bilibili" "https://search.bilibili.com/all?keyword=%s" nil)
          ("Zhihu" "https://www.zhihu.com/search?type=content&q=%s" nil)
	  ("Stackoveflow" "http://stackoverflow.com/search?q=%s" nil)
	  ("Sogou" "https://www.sogou.com/web?query=%s" nil)
	  ("Github" "https://github.com/search?q=%s" nil)
	  ("Melpa" "https://melpa.org/#/?q=%s" nil)
	  ("Emacs-China" "https://emacs-china.org/search?q=%s" nil)
	  ("EmacsWiki" "https://www.emacswiki.org/emacs/%s" nil)
	  ("Wiki-zh" "https://zh.wikipedia.org/wiki/%s" nil)
	  ("Wiki-en" "https://en.wikipedia.org/wiki/%s" nil)
	  ))
  :bind (("C-c w u" . browse-url)
	 ("C-c w w" . search-web)
	 ("C-c w p" . search-web-at-point)
	 ("C-c w r" . search-web-region)))

(use-package browse-at-remote
  :ensure t
  :bind ("C-c w g" . browse-at-remote))

(use-package darkroom
  :ensure t
  :bind (("C-c d" . darkroom-tentative-mode)))

(use-package winner-mode
  :ensure nil
  :hook (after-init . winner-mode))

(use-package move-text
  :ensure t
  :defer 5
  :config (move-text-default-bindings))

(use-package exec-path-from-shell
  :if (memq window-system '(ns mac))
  :ensure t
  :config
  (setq exec-path-from-shell-arguments '("-l"))
  (exec-path-from-shell-initialize))

(provide 'init-better)
