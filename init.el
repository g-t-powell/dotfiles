;; packages  -*- lexical-binding: t; -*-
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
(global-display-line-numbers-mode t)
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
(use-package tree-sitter)
(use-package tree-sitter-langs)
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
(use-package cobol-mode)


;; lsp-mode
(use-package lsp-mode
  :ensure t
  :custom
  (lsp-typst-export-pdf "onSave")
  (lsp-typst-formatter-mode "typstyle")
  (lsp-completion-provider :none)
  :init
  ;; FIX: Forces LSP completion to cooperate with Corfu and Orderless filtering
  (defun my/lsp-mode-corfu-setup ()
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
          '(orderless)))
  :commands (lsp lsp-deferred)
  :hook ((typst-ts-mode . lsp-deferred)
         (python-mode   . lsp-deferred)
         (cobol-mode    . lsp-deferred)
         ;; FIX: Trigger the filtering fix automatically when LSP completion loads
         (lsp-completion-mode . my/lsp-mode-corfu-setup)))
	
;; corfu
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.2)
  (corfu-cycle t)
  (corfu-quit-no-match 'separator)
  :init
  (add-hook 'prog-mode-hook #'corfu-mode)
  (setq tab-always-indent 'complete))

;; A few more useful configurations...
(use-package emacs
  :custom
  ;; TAB cycle if there are only few candidates
  ;; (completion-cycle-threshold 3)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (tab-always-indent 'complete)

  ;; Emacs 30 and newer: Disable Ispell completion function.
  ;; Try `cape-dict' as an alternative.
  (text-mode-ispell-word-completion nil)

  ;; Hide commands in M-x which do not apply to the current mode.  Corfu
  ;; commands are hidden, since they are not used via M-x. This setting is
  ;; useful beyond Corfu.
  (read-extended-command-predicate #'command-completion-default-include-p))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(corfu lsp-mode tree-sitter-langs treemacs treemacs-evil
	   typst-preview typst-ts-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
