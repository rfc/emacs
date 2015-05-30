(setq load-path (cons "~/.emacs.d/lisp/" load-path))
(add-to-list 'load-path "~/.emacs.d/lisp/vendor/")

;; General settings
;;
(setq standard-indent 4)
(setq-default tab-width 4)
(setq scroll-step 1)                ; scroll line by line
(setq-default indent-tabs-mode nil) ; turn off tab character
(setq make-backup-files nil)        ; no backup~ files
(setq auto-save-default nil)        ; no #autosave# files
(line-number-mode 1)                ; Show line-number in the mode line
(column-number-mode 1)              ; Show column-number in the mode line
(menu-bar-mode 0)					; Remove menu bar
(fset 'yes-or-no-p 'y-or-n-p)       ; use y/n instead of yes/no
(setq stack-trace-on-error t)
(global-hl-line-mode 1)				; highlight line which has cursor
(set-face-background 'hl-line "#3e4446")
(show-paren-mode 1)					; show matching parenthesis
(global-auto-revert-mode t)			; auto reload files
(setq show-paren-delay 0)
(desktop-save-mode 1)

;; Mac OSX
;;
(if (eq system-type 'darwin)
    (progn
		(setq
		aquamacs-scratch-file nil
		initial-major-mode 'emacs-lisp-mode)
		
		(setq
		ns-command-filter-modifier 'meta
		ns-alternate-modifier nil
		ns-use-mac-modifier-symbols nil)))
		
(if (eq window-system 'ns)
    (progn
		(tool-bar-mode 0)))

;; Use Package Manager (MELPA)
;;
(load "init-package")

(require 'dropdown-list)
(require 'highlight-parentheses)
(require 'zenburn-theme)

;; Display settings
;;
(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-message t)	; disable startup message
(column-number-mode t)              ; show column numbers

(autoload 'linum-mode "linum" "toggle line numbers on/off" t)
(setq linum-format "%d ")

(display-time-mode 1)               ; enable display time in modeline
(setq display-time-24hr-format t
	display-time-day-and-date t)
(display-time)

(setq frame-title-format '(buffer-file-name "%f" (dired-directory dired-directory "%b")))

(require 'fill-column-indicator)
(setq-default fci-rule-column 80)
(setq-default fci-rule-use-dashes 1)
(setq-default fci-rule-color "white")
(setq-default fci-rule-character-color "gray")

;(add-to-list 'default-frame-alist '(font .  "DejaVu Sans Mono-10" ))
;(set-frame-font "DejaVu Sans Mono-10" nil t)
;(if (eq system-type 'darwin)
;		(progn
;			(setq
;			set-face-attribute 'default nil :family "Consolas"
;			set-face-attribute 'default nil :height 100))
;	(set-face-attribute 'default nil :family "Terminus")
;	(set-face-attribute 'default nil :height 100))

(if (eq system-type 'windows-nt)
	(set-frame-size (selected-frame) 140 70))

(require 'whitespace)

;; Keyboard bindings
;;
(global-set-key (kbd "<C-tab>") 'bury-buffer)
(global-set-key [8]  'delete-backward-char)   	; C-h backspace
(global-set-key (kbd "<f4>") 'fci-mode)
(global-set-key (kbd "<f5>") 'whitespace-mode)
(global-set-key (kbd "<f6>") 'linum-mode)
;(global-set-key (kbd "<f7>") 'ecb-activate)
;(global-set-key (kbd "<C-f7>") 'ecb-deactivate)
(global-set-key (kbd "<f9>") 'speedbar)

(require 'cycle-buffer)
(if (eq system-type 'darwin)
  (progn
    (global-set-key (kbd "<C-f11>") 'cycle-buffer)
    (global-set-key (kbd "<C-f12>") 'cycle-buffer-backward)))
	
(if (not (eq system-type 'darwin))
  (progn
    (global-set-key (kbd "<f11>") 'cycle-buffer)
    (global-set-key (kbd "<f12>") 'cycle-buffer-backward)))

;; Window Numbering
;;
(require 'window-numbering)
(window-numbering-mode t)

;; Load CEDET
;;
(require 'cedet)

;; Semantic settings
;; ---------------------------------------------------
;;(setq semantic-load-turn-useful-things-on t)
;;(require 'semantic/bovine/c)
;;(require 'semantic/bovine/gcc)
;;(semantic-mode t)
;;(global-ede-mode t)                      			; Enable the project management system
;;(require 'semantic/sb)
;;(require 'srecode)
;;(setq semanticdb-default-save-directory "~/.emacs.d/.semanticdb")

;;(require 'semantic/ia)
;;(setq-mode-local c-mode semanticdb-find-default-throttle '(project unloaded system recursive))
;;(setq-mode-local c++-mode semanticdb-find-default-throttle '(project unloaded system recursive))

;;(global-semanticdb-minor-mode 1)
;;(global-semantic-stickyfunc-mode -1)
;;(global-semantic-mru-bookmark-mode 1)

;;(global-semantic-idle-local-symbol-highlight-mode t)
;;(global-semantic-idle-scheduler-mode t)
;;(global-semantic-idle-completions-mode t)
;;(global-semantic-idle-summary-mode t)
;;(global-semantic-decoration-mode t)
;;(global-semantic-highlight-func-mode t)
;;(global-semantic-show-unmatched-syntax-mode t)

;;(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
;;(add-to-list 'semantic-default-submodes 'global-cedet-m3-minor-mode)
;;(add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)
;;(add-to-list 'semantic-default-submodes 'global-semantic-idle-local-symbol-highlight-mode)
;;(add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
;;(add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode)
;;(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)
;;(add-to-list 'semantic-default-submodes 'global-semantic-decoration-mode)

;;(defun my-semantic-hook ()
;;  (imenu-add-to-menubar "TAGS"))
;;(add-hook 'semantic-init-hooks 'my-semantic-hook)

;(global-semantic-tag-folding-mode 1)
;(require 'semantic-tag-folding)
;(defun c-folding-hook ()
;	(local-set-key (kbd "C-c <left>") 'semantic-tag-folding-fold-block)
;	(local-set-key (kbd "C-c <right>") 'semantic-tag-folding-show-block)
;)
;(add-hook 'c-mode-common-hook 'c-folding-hook)


;; Load ECB
;;
(require 'ecb)		; slow load
;(require 'ecb-autoloads)   ; bug in emacs 24

(setq ecb-vc-enable-support t)
(setq ecb-history-sort-method nil) 
(setq ecb-tip-of-the-day nil)

(setq ecb-compile-window-height 6)
(setq ecb-compile-window-width (quote edit-window))
(setq ecb-windows-width 0.2)

(if (eq system-type 'windows-nt)
		(setq ecb-source-path (quote (("/" #("/" 0 1 (help-echo tree-buffer-help-echo-fn mouse-face highlight))) "D:\workspace")))
	(setq ecb-source-path (quote (("/" #("/" 0 1 (help-echo tree-buffer-help-echo-fn mouse-face highlight))) "~/workspace")))
)

;; Load Autocomplete
;;
(require 'auto-complete)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/lisp/auto-complete/dict")
(setq-default ac-sources (add-to-list 'ac-sources 'ac-source-dictionary))
(ac-config-default)
(ac-set-trigger-key "TAB")
(global-auto-complete-mode t)
(setq ac-auto-start 2)				; auto complete after two chars of word
(setq ac-ignore-case nil)			; case sensitivity

;; Load Yasnippet
;;
(require 'yasnippet)
(setq yas/root-directory '("~/.emacs.d/lisp/yasnippet/snippets/"))
;(yas/initialize)
;(yas/load-directory "~/.emacs.d/lisp/yasnippet/snippets/")
;(mapc 'yas/load-directory yas/root-directory)
;(add-to-list 'auto-mode-alist '("^/snippets/" . snippet-mode))
;(add-to-list 'ac-sources 'ac-source-yasnippet)

;;(defun reload-snippets ()
;;  (interactive)
;;  (yas-reload-all)
;;  (yas-recompile-all)
;;  (yas-reload-all)
;;  (yas-recompile-all)
;;)
;;(defun snippet-mode-before-save ()
;;  (interactive)
;;  (when (eq major-mode 'snippet-mode) (reload-snippets)))
;;(add-hook 'after-save-hook 'snippet-mode-before-save)

;; Load Magit
;;
(require 'magit)
(if (eq system-type 'windows-nt)
		(setq magit-git-executable "c:/program files/Git/bin/git.exe")
	(setq magit-git-executable "/usr/bin/git")						;; correct in Slackware 14
)
(setq magit-last-seen-setup-instructions "1.4.0")
;; Load Go
;; ===================================================
;;(require 'go-mode-load)


;; Load Web-mode
;; ===================================================
;;(require 'web-mode)
;;(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
;;(setq web-mode-markup-indent-offset 4)
;;(setq web-mode-css-indent-offset 4)
;;(setq web-mode-code-indent-offset 4)
;;(setq web-mode-indent-style 4)

;; Load external
;; ===================================================
(load "init-cc")
(load "init-js")
(load "init-python")
(load "init-ruby")
;;(require 'poptoshell)
;;(require 'flymake-cursor)

;;(global-set-key "\M- " 'pop-to-shell)

;; =============================================================================
;; .emacs ends
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(current-language-environment "English")
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
