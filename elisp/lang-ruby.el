;;; ruby config

(use-package inf-ruby
  :ensure t
  :defer t
  :config (add-hook 'ruby-mode-hook 'inf-ruby-minor-mode))

(use-package enh-ruby-mode
  :ensure t
  :defer t
  :config
  (add-to-list 'auto-mode-alist
               '("\\(?:\\.rb\\|ru\\|rake\\|thor\\|jbuilder\\|gemspec\\|podspec\\|/\\(?:Gem\\|Rake\\|Cap\\|Thor\\|Vagrant\\|Guard\\|Pod\\)file\\)\\'" . enh-ruby-mode)))

(use-package robe
  :ensure t
  :defer t
  :config (add-hook 'enh-ruby-mode-hook 'robe-mode))


(provide 'lang-ruby)
