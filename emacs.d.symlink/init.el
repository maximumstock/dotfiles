;;(setq debug-on-error t)
;;(setq debug-on-quit t)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
;;(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(package-initialize)

;; use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(defvar *is-mac* (memq window-system '(mac ns x)))

(use-package exec-path-from-shell
	:init
    (when *is-mac*
      (exec-path-from-shell-initialize)))

(when *is-mac*
  (defvar mac-option-key-is-meta nil)
  (defvar mac-command-key-is-meta t)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier nil))

(setq gc-cons-threshold 32000000
			garbage-collection-messages t)

;;(add-to-list 'default-frame-alist '(fullscreen . maximized))
(prefer-coding-system 'utf-8)

(global-auto-revert-mode t)
(global-display-line-numbers-mode t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(global-hl-line-mode t)

(setq ring-bell-function 'ignore)
(setq select-enable-clipboard t
			select-enable-primary t)
(setq version-control t)
(setq ns-use-native-fullscreen t)

; No backup files
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)

; Show matching parentheses
(show-paren-mode 1)

; Delete trailing whitespace before saving
(add-hook 'before-save-hook 'delete-trailing-whitespace)

; Spell checker program on macOS
(setq ispell-program-name "/usr/local/bin/aspell")

; Scrolling  (setq scroll-step 1)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse 't)
(setq redisplay-dont-pause t)

(set-face-attribute 'region t :background "#164040")
(set-face-attribute 'default nil :family "Hack" :height 120)

(use-package editorconfig
  :ensure t
  :init (editorconfig-mode 1))

;; Recentf comes with Emacs but it should always be enabled.

(use-package recentf
  :init (recentf-mode t)
  :config
  (add-to-list 'recentf-exclude "\\.emacs.d")
  (add-to-list 'recentf-exclude ".+tmp......\\.org"))

(use-package ivy
	:init (ivy-mode))
(use-package counsel
	:init (counsel-mode))
(use-package projectile
  :config (setq projectile-git-submodule-command nil)
  :init (projectile-mode))
(use-package counsel-projectile
  :init (counsel-projectile-mode))

(use-package gruvbox-theme :ensure t)
(use-package rainbow-delimiters :ensure t)
(use-package powerline
  :ensure t
  :init (powerline-default-theme))
(use-package rainbow-delimiters
  :ensure t
  :init (rainbow-delimiters-mode))

;; (use-package doom-themes
;;   :config
;;   (load-theme 'doom-tomorrow-night)
;;   (doom-themes-visual-bell-config)
;;   (doom-themes-org-config)
;;
;;   ;; Docstrings should be a bit lighter, since they're important.
;;   (custom-theme-set-faces
;;   'doom-tomorrow-night
;;   '(font-lock-doc-face ((t (:foreground "#D8D2C1"))))))

(use-package which-key
  :config (setq which-key-idle-delay 0.5)
  :init (which-key-mode t))

(use-package evil
  :ensure t
  :config
  (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
  (define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)
  (evil-ex-define-cmd "q" 'kill-this-buffer)
  (defalias #'forward-evil-word #'forward-evil-symbol)
  (define-key evil-insert-state-map (kbd "C-u")
    (lambda ()
      (interactive)
      (evil-delete (point-at-bol) (point))))
  (modify-syntax-entry ?_ "w")
  (modify-syntax-entry ?- "w")
  )
(use-package evil-surround
	:config
  (global-evil-surround-mode))
(use-package evil-goggles
	:ensure t
  :config (evil-goggles-mode))
(evil-mode 1)

(use-package org-bullets)
(use-package org)
(add-hook 'org-mode-hook (lambda() (org-bullets-mode t)))
(add-hook 'org-mode-hook (lambda() (org-indent-mode)))

(setq org-hide-leading-stars t)
(setq org-log-done t)
(setq org-todo-keywords '((sequence "TODO" "INPROGRESS" "DONE")))
(setq org-todo-keyword-faces
  '(
     ("TODO" . (:foreground "red" :weight bold))
     ("INPROGRESS" . (:foreground "orange" :weight bold))
     ("DONE" . (:foreground "green" :weight bold))
     ))
(defvar org-agenda-show-log t)
(defvar org-agenda-todo-ignore-scheduled t)
(defvar org-agenda-todo-ignore-deadlines t)
(setq org-agenda-files '("~/todo"))
(setq org-src-fontify-natively t)

(org-babel-do-load-languages
	'org-babel-load-languages
  	'((emacs-lisp . t)
      (shell . t)))

(setq org-src-preserve-indentation t
      org-edit-src-content-indentation t)

(use-package git-gutter
  :ensure t
  :init (global-git-gutter-mode t)
	:config
	(set-face-background 'git-gutter:added "light green")
	(set-face-background 'git-gutter:modified "orange")
	(set-face-background 'git-gutter:deleted "red")

	(custom-set-variables
		'(git-gutter:added-sign " ")
		'(git-gutter:modified-sign " ")
		'(git-gutter:deleted-sign " ")
		)

)
(use-package evil-magit :ensure t)
(use-package magit
  :ensure t
  :init (evil-magit-init))

(use-package company
	:diminish company-mode
  :config
  	(setq company-idle-delay 0.2)
    (setq company-minimum-prefix-length 2)
    (defvar company-tooltip-align-annotations t)
    (defvar company-dabbrev-downcase nil)
    (defvar company-dabbrev-ignore-case nil)
    (defvar company-require-match nil)
    (defvar company-etags-ignore-case t))
;; (use-package company-quickhelp
;;	:init (with-eval-after-load 'company (company-quickhelp-mode)))
(global-company-mode t)

(use-package flycheck
  :hook (prog-mode . flycheck-mode))

(use-package nvm :ensure t)

;; Map escape to cancel (like C-g)...
(define-key isearch-mode-map [escape] 'isearch-abort)
;; isearch
;; \e seems to work better for terminals
(define-key isearch-mode-map "\e" 'isearch-abort)
;; everywhere else
(global-set-key [escape] 'keyboard-escape-quit)

(use-package general
  :config
  (general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "C-SPC"

   ;; simple command
   "'"   '(iterm-focus :which-key "iterm")
   "?"   '(iterm-goto-filedir-or-home :which-key "iterm - goto dir")
   "/"   'counsel-ag
   "TAB" '(previous-buffer :which-key "prev buffer")
   "SPC" '(next-buffer :which-key "next buffer")
   "+" '(text-scale-increase :which-key "zoom-in")
   "-" '(text-scale-decrease :which-key "zoom-out")

   ;; Buffers
   "b" '(:ignore t :which-key "Buffers")
   "b b" '(switch-to-buffer :which-key "list buffers")
   "b k" '(kill-buffer :which-key "kill buffer")

   ;; Windows
   "w" '(:ignore t :which-key "Windows")
   "w s" '(split-window-vertically :which-key "hsplit")
   "w v" '(split-window-horizontally :which-key "vsplit")
   "w S" '((lambda () (interactive) (split-window-vertically) (other-window 1)) :which-key "Hsplit")
   "w V" '((lambda () (interactive) (split-window-horizontally) (other-window 1)) :which-key "Vsplit")
   "w k" '(delete-window :which-key "delete current")

   ;; Applications
   ;; "p" ('projectile-switch-project :which-key "Switch Project")
   "p" '(projectile-command-map :which-key "Projectile")
   "a" '(:ignore t :which-key "Applications")
   "ad" 'dired
   "g" '(magit-status :which-key "Magit")
   ))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
	'(custom-safe-themes
		 '("b583823b9ee1573074e7cbfd63623fe844030d911e9279a7c8a5d16de7df0ed0" "585942bb24cab2d4b2f74977ac3ba6ddbd888e3776b9d2f993c5704aa8bb4739" "8e797edd9fa9afec181efbfeeebf96aeafbd11b69c4c85fa229bb5b9f7f7e66c" "1436d643b98844555d56c59c74004eb158dc85fc55d2e7205f8d9b8c860e177f" "2b9dc43b786e36f68a9fd4b36dd050509a0e32fe3b0a803310661edb7402b8b6" "8f97d5ec8a774485296e366fdde6ff5589cf9e319a584b845b6f7fa788c9fa9a" "a22f40b63f9bc0a69ebc8ba4fbc6b452a4e3f84b80590ba0a92b4ff599e53ad0" default))
 '(git-gutter:added-sign " ")
 '(git-gutter:deleted-sign " ")
 '(git-gutter:modified-sign " ")
 '(global-visual-line-mode t)
	'(package-selected-packages
		 '(evil-goggles lsp-mode rustic neotree which-key use-package rainbow-delimiters powerline pipenv org-bullets nvm lv ht gruvbox-theme git-gutter general flycheck-rust exec-path-from-shell evil-surround evil-magit eglot editorconfig counsel-projectile company cargo)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
