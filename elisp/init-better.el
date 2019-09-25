```;;; some better defaults
(global-set-key (kbd "<s-backspace>") 'universal-argument)
(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)
(setq ring-bell-function 'ignore);;消除滑动到底部或顶部时的声音
(global-auto-revert-mode t);;自动加载更新内容
(setq make-backup-files nil);;不允许备份
(setq auto-save-default t);;不允许自动保存
(recentf-mode 1)
(ido-mode 1)
(setq recentf-max-menu-items 10)
;;(add-hook 'prog-mode-hook 'display-line-numbers-mode);;显示行号
(add-hook 'emacs-lisp-mode-hook 'show-paren-mode);;括号匹配
(setq scroll-step 1 scroll-margin 3 scroll-conservatively 10000)
(fset 'yes-or-no-p 'y-or-n-p);;用y/s代替yes/no

(setq default-buffer-file-coding-system 'utf-8)
(setq bookmark-file-coding-system 'utf-8)
(setq magit-git-output-coding-system 'utf-8)

(prefer-coding-system 'utf-8)

(setq ad-redefinition-action 'accept);在执行程序的时候，不需要确认
(setq org-confirm-babel-evaluate nil);设定文档中需要执行的程序类型，以下设置了R，python，latex和emcas-lisp
(setq zone-when-idle 300)
(setq exec-path-from-shell-check-startup-files nil)
(setq epg-gpg-program "gpg2")
(setq x-select-enable-primary nil) ;不选中区域自动复制

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)
   ))

;; 默认分割成左右两个窗口
;; (setq split-height-threshold nil)
;; (setq split-width-threshold 0)

(setq dired-recursive-deletes 'always)
(setq dired-recursive-copies 'always);;全部递归拷贝删除文件夹中的文件

;;Handy way of getting back to previous places.
(bind-key "C-x p" 'pop-to-mark-command)
(setq set-mark-command-repeat-pop t)

(put 'dired-find-alternate-file 'disabled nil);;避免每一级目录都产生一个buffer
(require 'dired-x)
(setq dired-dwim-target t)

;;Highlight parens when inside it
(define-advice show-paren-function (:around (fn) fix-show-paren-function)
  "Highlight enclosing parens."
  (cond ((looking-at-p "\\s(") (funcall fn))
	(t (save-excursion
	     (ignore-errors (backward-up-list))
	     (funcall fn)))))

;;indent buffer
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

;;better code company
(setq hippie-expand-try-function-list '(try-expand-debbrev
					try-expand-debbrev-all-buffers
					try-expand-debbrev-from-kill
					try-complete-file-name-partially
					try-complete-file-name
					try-expand-all-abbrevs
					try-expand-list
					try-expand-line
					try-complete-lisp-symbol-partially
					try-complete-lisp-symbol))

(use-package restart-emacs
  :ensure t
  :defer 5
  :bind (("C-x C-c" . restart-emacs)))

(use-package beacon
  :ensure t
  :defer 5
  :config (beacon-mode 1))

(use-package disable-mouse
  :defer t
  :ensure nil
  :config (global-disable-mouse-mode -1))

(provide 'init-better)
