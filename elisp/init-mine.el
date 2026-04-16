;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq pulse-delay 0.08
      pulse-iterations 2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package vb-split
  :load-path "~/.emacs.d/site-lisp/vb-split")

(use-package mind-wave
  :load-path "~/.emacs.d/site-lisp/mind-wave"
  :config
  (defun chatgpt-ask ()
    (interactive)
    (let ((file "c:/Users/26289/.emacs.d/mind-wave/gpt.chat"))
      (find-file file)
      (mind-wave-chat-ask))))

;;; Set org-indent-mode and org-bullets-mode for org buffer in gk-org-prettify-dirs
(defvar gk-org-prettify-dirs
  '("c:/Users/26289/Asiainfo/陕西V8/"))

(defun gk/set-better-org ()
  (when-let ((file (buffer-file-name)))
    (let ((file-dir (file-name-directory file)))
      (when (member file-dir gk-org-prettify-dirs)
        (setq-local electric-indent-mode nil)
        (org-indent-mode 1)
        (org-bullets-mode 1)))))

(add-hook 'org-mode-hook 'gk/set-better-org)

(provide 'init-mine)
