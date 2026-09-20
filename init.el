;; packages
(require 'package)
(setq package-archives
	'(("gnu" 		. "https://elpa.gnu.org/packages/")
	  ("melpa"		. "https://melpa.org/packages/")))
	  ; ("melpa-stable"	. "https://stable.melpa.org/packages/")))
(package-initialize)
(unless package-archive-contents
	(package-refresh-contents))
(unless (package-installed-p 'use-package)
	(package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; appearance
(global-visual-line-mode t)
(setq frame-resize-pixelwise t)
(tab-bar-mode 1)
(tool-bar-mode -1)


;; org mode
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)
(setq org-agenda-files '("/mnt/remote/org"))
(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "WAITING" "|" "DONE" "CANCELLED")))

;; evil
(use-package evil
	:config
	(evil-mode 1))

; tree-sitter
(require 'tree-sitter)
(require 'tree-sitter-langs)
(setq treesit-language-source-alist
      '((typst "https://github.com/uben0/tree-sitter-typst")))

;; typst
(use-package typst-ts-mode
  :vc (:url "https://codeberg.org/meow_king/typst-ts-mode")
  :custom
  (typst-ts-mode-watch-options "--open"))
(use-package websocket)
(use-package typst-preview)



;; language support
(use-package markdown-mode)

(use-package lsp-mode
	:hook ((typst-ts-mode . lsp-deferred)
	       (python-mode   . lsp-deferred)
	       (cobol-mode    . lsp-deferred))
		
	:commands (lsp lsp-deferred)
	:custom
	(lsp-typst-export-pdf "onSave")
	(lsp-typst-formatter-mode "typstyle"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(evil lsp-mode tree-sitter-langs typst-preview typst-ts-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
