;;; includes some basic settings, theme, modeline, neotree and some ui library.
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(fringe-mode 0)

(setq display-time-default-load-average t)
(display-time-mode -1)

(global-hl-line-mode -1);;光标行高亮

;; from centaur
(push '(vertical-scroll-bars . nil) default-frame-alist)
;; (when (featurep 'ns)
;;   (push '(ns-transparent-titlebar . t) default-frame-alist))

(setq hi-lock-file-patterns-policy #'(lambda (dummy) t)) ;;加载高亮模式
(setq initial-frame-alist (quote ((fullscreen . maximized))));;启动最大化窗口
(setq-default cursor-type 'box) ;变光标, setq-default设置全局

;; Fonts
(defun font-installed-p (font-name)
  "Check if font with FONT-NAME is available."
  (find-font (font-spec :name font-name)))

(when (display-graphic-p)
  ;; Set default font
  (cl-loop for font in '("Source Code Variable"
                         "Menlo" "SF"
                         "Monaco Mono" "Hack"
                         "Fira Code"
                         "DejaVu Sans Mono"
                         "Consolas")
           when (font-installed-p font)
           return (set-face-attribute 'default nil
                                      :font font
                                      :height (cond ((eq system-type 'darwin) 125)
                                                    ((eq system-type 'windows-nt) 110)
                                                    (t 100))))
  ;; Specify font for all unicode characters
  (cl-loop for font in '("Apple Color Emoji" "Symbola" "Symbol")
           when (font-installed-p font)
           return(set-fontset-font t 'unicode font nil 'prepend))
  ;; Specify font for Chinese characters
  (cl-loop for font in '("Source Han Serif SC"
                         "Source Han Sans SC"
                         "WenQuanYi Micro Hei"
                         "Microsoft Yahei")
           when (font-installed-p font)
           return (set-fontset-font t '(#x4e00 . #x9fff) font)))

;; @purcell
(defun sanityinc/adjust-opacity (frame incr)
  "Adjust the background opacity of FRAME by increment INCR."
  (unless (display-graphic-p frame)
    (error "Cannot adjust opacity of this frame"))
  (let* ((oldalpha (or (frame-parameter frame 'alpha) 100))
         (oldalpha (if (listp oldalpha) (car oldalpha) oldalpha))
         (newalpha (+ incr oldalpha)))
    (when (and (<= frame-alpha-lower-limit newalpha) (>= 100 newalpha))
      (modify-frame-parameters frame (list (cons 'alpha newalpha))))))

(global-set-key (kbd "M-C-8") (lambda () (interactive) (sanityinc/adjust-opacity nil -2)))
(global-set-key (kbd "M-C-9") (lambda () (interactive) (sanityinc/adjust-opacity nil 2)))
(global-set-key (kbd "M-C-7") (lambda () (interactive) (modify-frame-parameters nil `((alpha . 100)))))
;;==================================================

(use-package powerline
  :ensure t)
(require 'powerline)
(powerline-default-theme)

;; (use-package all-the-icons
;;   :ensure t)

;; (use-package all-the-icons-dired
;;   :ensure t
;;   :config
;;   (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

;; colorful dired-mode
(use-package diredfl
  :ensure t
  :config (diredfl-global-mode t))

;; (use-package indent-guide
;;   :ensure t
;;   :config
;;   (indent-guide-mode -1)
;;   (add-hook 'prog-mode-hook 'indent-guide-mode)
;;   (add-hook 'org-mode-hook 'indent-guide-mode)
;;   (setq indent-guide-delay 0)
;;   (setq indent-guide-recursive nil)
;;   (setq indent-guide-char "¦"))

(provide 'init-ui)
