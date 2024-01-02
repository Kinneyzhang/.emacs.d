;; (use-package vterm
;;  :ensure t)

;; (use-package vterm-toggle
;;   :ensure t
;;   :bind
;;   (("M-<f1>" . vterm-toggle)
;;    ("M-<f2>" . vterm-toggle-cd))
;;   :config
;;   (define-key vterm-mode-map (kbd "s-n") 'vterm-toggle-forward)
;;   (define-key vterm-mode-map (kbd "s-p") 'vterm-toggle-backward)
;;   (setq vterm-toggle-fullscreen-p nil)
;;   (add-to-list 'display-buffer-alist
;; 	       '("^v?term.*"
;; 		 (display-buffer-reuse-window display-buffer-in-side-window)
;; 		 (side . bottom)
;; 		 ;;(dedicated . t) ;dedicated is supported in emacs27
;; 		 (reusable-frames . visible)
;; 		 (window-height . 0.3))))

;;-----------------------------------------------

;; count words
(defvar wc-regexp-chinese-char-and-punc
  (rx (category chinese)))
(defvar wc-regexp-chinese-punc
  "[。，！？；：「」『』（）、【】《》〈〉※—]")
(defvar wc-regexp-english-word
  "[a-zA-Z0-9-]+")

(defun my/word-count ()
  "「較精確地」統計中/日/英文字數。
- 文章中的註解不算在字數內。
- 平假名與片假名亦包含在「中日文字數」內，每個平/片假名都算單獨一個字（但片假
  名不含連音「ー」）。
- 英文只計算「單字數」，不含標點。
- 韓文不包含在內。

※計算標準太多種了，例如英文標點是否算入、以及可能有不太常用的標點符號沒算入等
。且中日文標點的計算標準要看 Emacs 如何定義特殊標點符號如ヴァランタン・アルカン
中間的點也被 Emacs 算為一個字而不是標點符號。"
  (interactive)
  (let* ((v-buffer-string
          (progn
            (if (eq major-mode 'org-mode) ; 去掉 org 文件的 OPTIONS（以#+開頭）
                (setq v-buffer-string (replace-regexp-in-string "^#\\+.+" ""
								(buffer-substring-no-properties (point-min) (point-max))))
              (setq v-buffer-string (buffer-substring-no-properties (point-min) (point-max))))
            (replace-regexp-in-string (format "^ *%s *.+" comment-start) "" v-buffer-string)))
                                        ; 把註解行刪掉（不把註解算進字數）。
         (chinese-char-and-punc 0)
         (chinese-punc 0)
         (english-word 0)
         (chinese-char 0))
    (with-temp-buffer
      (insert v-buffer-string)
      (goto-char (point-min))
      ;; 中文（含標點、片假名）
      (while (re-search-forward wc-regexp-chinese-char-and-punc nil :no-error)
        (setq chinese-char-and-punc (1+ chinese-char-and-punc)))
      ;; 中文標點符號
      (goto-char (point-min))
      (while (re-search-forward wc-regexp-chinese-punc nil :no-error)
        (setq chinese-punc (1+ chinese-punc)))
      ;; 英文字數（不含標點）
      (goto-char (point-min))
      (while (re-search-forward wc-regexp-english-word nil :no-error)
        (setq english-word (1+ english-word))))
    (setq chinese-char (- chinese-char-and-punc chinese-punc))
    ;;  (message
    ;;      (format "中日文字數（不含標點）：%s
    ;; 中日文字數（包含標點）：%s
    ;; 英文字數（不含標點）：%s
    ;; =======================
    ;; 中英文合計（不含標點）：%s"
    ;;              chinese-char chinese-char-and-punc english-word
    ;;              (+ chinese-char english-word)))
    (+ chinese-char english-word)))

;;----------------------------------------------------------------------
(defun my/insert-current-time ()
  "Insert the current time"
  (interactive "*")
  (insert (format-time-string "%Y-%m-%d %H:%M:%S" (current-time))))

(defun my/insert-current-date ()
  "Insert the current time"
  (interactive "*")
  (insert (format-time-string "%b %d, %Y" (current-time))))

(global-set-key (kbd "C-c t t") 'my/insert-current-time)
(global-set-key (kbd "C-c t d") 'my/insert-current-date)

(use-package general
  :ensure t)

(use-package paredit
  ;; check if the parens is matched
  :ensure t
  :defer t)

(defun file-contents (filename)
  (interactive "fFind file: ")
  (with-temp-buffer
    (insert-file-contents filename) ;; 先将文件内容插入临时buffer，再读取内容
    (buffer-substring-no-properties (point-min) (point-max))))

;;; deploy functions

(defun gk/deploy-wiki ()
  (interactive)
  (let ((display-buffer-alist
         '(("\\*Async Shell Command\\*" display-buffer-no-window))))
    (async-shell-command "cd ~/iCloud/hack/md-wiki && git add . && git commit -m 'update' && git push")))

(defun gk/deploy-egodb ()
  (interactive)
  (let* ((buf-name "\\*Async Shell Command Egodb\\*")
         (display-buffer-alist `((,buf-name display-buffer-no-window))))
    (async-shell-command "cd ~/.emacs.d/ego-db && sh ./deploy.sh")))

(defun gk/deploy-langc ()
  (interactive)
  (let ((display-buffer-alist
         '(("\\*Async Shell Command\\*" display-buffer-no-window))))
    (async-shell-command "cd ~/iCloud/LangC/ && git add . && git commit -m 'update' && git push")))

(defun gk/deploy-gknows ()
  (interactive)
  (let ((display-buffer-alist
         '(("\\*Async Shell Command\\*" display-buffer-no-window))))
    (async-shell-command "cd ~/gknows/ && git add . && git commit -m 'update' && git push")))

(defun gk/deploy-mygtd ()
  (interactive)
  (let ((display-buffer-alist
         '(("\\*Async Shell Command\\*" display-buffer-no-window))))
    (async-shell-command "cd ~/iCloud/hack/mygtd/ && git add . && git commit -m 'update' && git push")))

;;; print symbol

(defun print-symbol-τ ()
  "print to"
  (interactive)
  (insert "τ"))
(global-set-key (kbd "C-c s t o") 'print-symbol-τ)

(defun print-symbol-∂ ()
  "print round"
  (interactive)
  (insert "∂"))
(global-set-key (kbd "C-c s r d") 'print-symbol-∂)

(defun print-symbol-∮ ()
  "print qjf"
  (interactive)
  (insert "∮"))
(global-set-key (kbd "C-c s q j f") 'print-symbol-∮)

(defun print-symbol-ρ ()
  "print ru"
  (interactive)
  (insert "ρ"))
(global-set-key (kbd "C-c s r u") 'print-symbol-ρ)

(defun print-symbol-± ()
  "print plus and minus"
  (interactive)
  (insert "±"))
(global-set-key (kbd "C-c s p m") 'print-symbol-±)

(defun print-symbol-⊥ ()
  "print perpendicular to"
  (interactive)
  (insert "⊥"))
(global-set-key (kbd "C-c s p t") 'print-symbol-⊥)

(defun print-symbol-ʃ ()
  "print jifen"
  (interactive)
  (insert "ʃ"))
(global-set-key (kbd "C-c s j f") 'print-symbol-ʃ)

(defun print-symbol-≥ ()
  "print more and equal"
  (interactive)
  (insert "≥"))
(global-set-key (kbd "C-c s m e") 'print-symbol-≥)

(defun print-symbol-≤ ()
  "print less and equal"
  (interactive)
  (insert "≤"))
(global-set-key (kbd "C-c s l e") 'print-symbol-≤)

(defun print-symbol-≠ ()
  "print Inequality"
  (interactive)
  (insert "≠"))
(global-set-key (kbd "C-c s i e") 'print-symbol-≠)

(defun print-symbol-∃ ()
  "print existence"
  (interactive)
  (insert "∃"))
(global-set-key (kbd "C-c s e x") 'print-symbol-∃)

(defun print-symbol-∀ ()
  "print Arbitrary"
  (interactive)
  (insert "∀"))
(global-set-key (kbd "C-c s a b") 'print-symbol-∀)

(defun print-symbol-⊆ ()
  "print contained"
  (interactive)
  (insert "⊆"))
(global-set-key (kbd "C-c s c t") 'print-symbol-⊆)

(defun print-symbol-∈ ()
  "print Belong"
  (interactive)
  (insert "∈"))
(global-set-key (kbd "C-c s b l") 'print-symbol-∈)

(defun print-symbol-∞ ()
  "print Infinit"
  (interactive)
  (insert "∞"))
(global-set-key (kbd "C-c s i f") 'print-symbol-∞)

(defun print-symbol-ξ ()
  "print ksi"
  (interactive)
  (insert "ξ"))
(global-set-key (kbd "C-c s k s") 'print-symbol-ξ)

(defun print-symbol-η ()
  "print eta"
  (interactive)
  (insert "η"))
(global-set-key (kbd "C-c s e t") 'print-symbol-η)

(defun print-symbol-ε ()
  "print Epsilon"
  (interactive)
  (insert "ε"))
(global-set-key (kbd "C-c s e p") 'print-symbol-ε)

(defun print-symbol-α ()
  "print Alpha"
  (interactive)
  (insert "α"))
(global-set-key (kbd "C-c s a p") 'print-symbol-α)

(defun print-symbol-β ()
  "print Beta"
  (interactive)
  (insert "β"))
(global-set-key (kbd "C-c s b t") 'print-symbol-β)

(defun print-symbol-γ ()
  "print Gamma"
  (interactive)
  (insert "γ"))
(global-set-key (kbd "C-c s g m") 'print-symbol-γ)

(defun print-symbol-λ ()
  "print lambda"
  (interactive)
  (insert "λ"))
(global-set-key (kbd "C-c s l d") 'print-symbol-λ)

(defun print-symbol-θ ()
  "print Theta"
  (interactive)
  (insert "θ"))
(global-set-key (kbd "C-c s t t") 'print-symbol-θ)

(defun print-symbol-ζ ()
  "print Zeta"
  (interactive)
  (insert "ζ"))
(global-set-key (kbd "C-c s z t") 'print-symbol-ζ)

(defun print-symbol-Δ ()
  "print Delte"
  (interactive)
  (insert "Δ"))
(global-set-key (kbd "C-c s d t") 'print-symbol-Δ)

(defun print-symbol-μ ()
  "print Mu"
  (interactive)
  (insert "μ"))
(global-set-key (kbd "C-c s m u ") 'print-symbol-μ)

(defun print-symbol-π ()
  "print Pi"
  (interactive)
  (insert "π"))
(global-set-key (kbd "C-c s p i") 'print-symbol-π)

(defun print-symbol-σ ()
  "print Sigma"
  (interactive)
  (insert "σ"))
(global-set-key (kbd "C-c s s m") 'print-symbol-σ)

(defun print-symbol-Σ ()
  "print upper Sigma"
  (interactive)
  (insert "Σ"))
(global-set-key (kbd "C-c s u s m") 'print-symbol-Σ)

(defun print-symbol-ρ ()
  "print Rho"
  (interactive)
  (insert "ρ"))
(global-set-key (kbd "C-c s r h") 'print-symbol-ρ)

(defun print-symbol-ψ ()
  "print Psi"
  (interactive)
  (insert "ψ"))
(global-set-key (kbd "C-c s p s") 'print-symbol-ψ)

(defun print-symbol-φ ()
  "print Phi"
  (interactive)
  (insert "φ"))
(global-set-key (kbd "C-c s p h") 'print-symbol-φ)

(defun print-symbol-Φ ()
  "print upper Phi"
  (interactive)
  (insert "Φ"))
(global-set-key (kbd "C-c s u p h") 'print-symbol-Φ)

(defun print-symbol-ω ()
  "print lower Omiga"
  (interactive)
  (insert "ω"))
(global-set-key (kbd "C-c s l o g") 'print-symbol-ω)

(defun print-symbol-Ω ()
  "print upper Omiga"
  (interactive)
  (insert "Ω"))
(global-set-key (kbd "C-c s u o g") 'print-symbol-Ω)

;;=================================================================
(defun print-symbol-◉ ()
  (interactive)
  (insert "◉"))
(global-set-key (kbd "C-c s t d") 'print-symbol-◉)

(defun print-symbol-● ()
  (interactive)
  (insert "●"))
(global-set-key (kbd "C-c s s d") 'print-symbol-●) ;;solid dot

(defun print-symbol-○ ()
  (interactive)
  (insert "○"))
(global-set-key (kbd "C-c s h d") 'print-symbol-○) ;;hollow dot

(defun print-symbol-× ()
  (interactive)
  (insert "×"))
(global-set-key (kbd "C-c s c h") 'print-symbol-×) ;;cross

(defun print-symbol-★ ()
  (interactive)
  (insert "★"))
(global-set-key (kbd "C-c s 1") 'print-symbol-★)

(defun print-symbol-√ ()
  (interactive)
  (insert "√"))
(global-set-key (kbd "C-c s g h") 'print-symbol-√)

(defun print-symbol-❤ ()
  (interactive)
  (insert "❤"))
(global-set-key (kbd "C-c s t m") 'print-symbol-❤)

(use-package grab-mac-link
  :ensure t
  :bind (("C-c l g" . grab-mac-link)))

(defun diary-last-day-of-month (date)
  "Return `t` if DATE is the last day of the month."
  (let* ((day (calendar-extract-day date))
         (month (calendar-extract-month date))
         (year (calendar-extract-year date))
         (last-day-of-month
          (calendar-last-day-of-month month year)))
    (= day last-day-of-month)))

(provide 'init-utils)
;; ;;; init-utils.el ends here
