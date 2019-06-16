(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(package-initialize)

;; use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; Make sure all packages are installed
(require 'cl)
(defvar packages '( evil
                    general
                    which-key
                    projectile
                    ;; Search
                    ivy
                    counsel
                    counsel-projectile
                    swiper
                    ;; General
                    magit
                    forge
                    evil-magit
                    org
                    powerline
                    ledger-mode
                    evil-ledger
                    exec-path-from-shell
                    company
                    flycheck
                    format-all
                    editorconfig
                    ;; Language Support
                    python-mode
                    pyenv-mode
                    tide
                    nvm
                    ;; Org-babel
                    ob-typescript
                    ;; Visuals
                    gruvbox-theme
                    all-the-icons
                    rainbow-delimiters
                    )


  "Default packages;;")

(defun packages-installed-p ()
  (loop for pkg in packages
	when (not (package-installed-p pkg)) do (return nil)
	finally (return t)))

(unless (packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; Package configuration
(use-package which-key
  :ensure t
  :config (setq which-key-idle-delay 0.5)
  :init (which-key-mode t))

(use-package editorconfig
  :ensure t
  :init (editorconfig-mode 1))

(use-package company
  :ensure t
  :hook (prog-mode . company-mode)
  :config (setq company-tooltip-align-annotations t))

(use-package flycheck
  :ensure t
  :hook (prog-mode . flycheck-mode))

(with-eval-after-load 'evil
    (defalias #'forward-evil-word #'forward-evil-symbol))
(use-package evil
  :ensure t
  :config
  (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
  (define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)
  (define-key evil-insert-state-map (kbd "C-u")
    (lambda ()
      (interactive)
      (evil-delete (point-at-bol) (point))))
  (modify-syntax-entry ?_ "w")
  :init (evil-mode)
  )

(use-package powerline
  :ensure t
  :init (powerline-default-theme))

(use-package ivy
  :ensure t
  :init (ivy-mode))

(use-package projectile
  :ensure t
  :config (setq projectile-git-submodule-command nil)
  :init (projectile-mode))

(use-package counsel-projectile
  :ensure t
  :init (counsel-projectile-mode))

(use-package rainbow-delimiters
  :ensure t
  :init (rainbow-delimiters-mode))

;; Org Stuff
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (typescript . t)
   (python . t)
   (shell . t)
   ))


;; General Settings
(global-auto-revert-mode t)
(global-display-line-numbers-mode t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(setq ring-bell-function 'ignore)
(setq select-enable-clipboard t)
(setq make-backup-files nil)
(setq version-control t)
;; highlight current line
(global-hl-line-mode t)
(setq ns-use-native-fullscreen t)
;; don't create backup~ files
(setq make-backup-files nil)
;;change highlight colour
(set-face-attribute 'region t :background "#164040")
(set-face-attribute 'default nil
		    :family "Hack" :height 120)

;; org-mode
(use-package org
  :ensure t
  :config (lambda ()
            (setq org-log-done t)
            (setq org-todo-keywords '(("TODO" "INPROGRESS" "DONE")))
            (setq org-todo-keyword-faces '(("INPROGRESS" . (:foreground "orange" :weight bold))))
            (setq org-agenda-show-log t)
            (setq org-agenda-todo-ignore-scheduled t)
            (setq org-agenda-todo-ignore-deadlines t)
            (setq org-agenda-files '("~/todo"))
            ))
(add-hook 'org-mode-hook (lambda () (org-bullets-mode t)))

;; Keybindings

;; Map escape to cancel (like C-g)...
(define-key isearch-mode-map [escape] 'isearch-abort)
;; isearch
;; \e seems to work better for terminals
(define-key isearch-mode-map "\e" 'isearch-abort)
;; everywhere else
(global-set-key [escape] 'keyboard-escape-quit)

(use-package general
  :ensure t
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

   ;; Applications
   ;; "p" ('projectile-switch-project :which-key "Switch Project")
   "p" '(projectile-command-map :which-key "Projectile")
   "a" '(:ignore t :which-key "Applications")
   "ad" 'dired
   "g" '(magit-status :which-key "Magit")
   ))

; macOS stuff
(setq mac-option-key-is-meta nil)
(setq mac-command-key-is-meta t)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)

; ENV
(let ((path (shell-command-to-string "echo -n $PATH")))
  (setenv "PATH" path)
  (setq exec-path
	(append
	 (split-string-and-unquote path ":")
	 exec-path)))




;; Language Support

;; Themes & Visuals
(use-package gruvbox-theme :ensure t)
(use-package all-the-icons)
(use-package rainbow-delimiters :ensure t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (general ob-typescript which-key use-package tide rainbow-delimiters python-mode pyenv-mode powerline nvm gruvbox-theme format-all forge exec-path-from-shell evil-magit evil-ledger editorconfig counsel-projectile company all-the-icons))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
