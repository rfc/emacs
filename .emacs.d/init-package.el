;; ============================================================================= 
;; init-package.el
;; =============================================================================

(require 'package)
(setq package-archives '(("elpa" . "http://tromey.com/elpa/") 
                          ("gnu" . "http://elpa.gnu.org/packages/")
                          ("marmalade" . "http://marmalade-repo.org/packages/")
						  ("melpa" . "http://melpa.milkbox.net/packages/")
						  ("org" . "http://orgmode.org/elpa/")))
 
(defun require-package (package &optional min-version no-refresh)
"Ask elpa to install given PACKAGE."
(if (package-installed-p package min-version)
    t
  (if (or (assoc package package-archive-contents) no-refresh)
      (package-install package)
    (progn
      (package-refresh-contents)
      (require-package package min-version t)))))

(when (< emacs-major-version 24)
  (add-to-list 'package-load-list '(zenburn-theme nil) 'append))
(when (>= emacs-major-version 24)
  (add-to-list 'package-load-list '(color-theme nil) 'append)
  (add-to-list 'package-load-list '(zenburn nil) 'append))
  
(package-initialize)

(require-package 'yasnippet)
(require-package 'auto-complete)       ;; auto completion
(require-package 'auto-complete-clang) ;; auto completion for C++ using CLang
(require-package 'magit)
(require-package 'highlight-80+)
(require-package 'highlight-parentheses)
(require-package 'highlight-symbol)
(require-package 'inf-ruby)
(require-package 'ruby-mode)
(require-package 'magit)

(when (< emacs-major-version 24)
  (require-package 'color-theme)
  (require-package 'zenburn))
(when (>= emacs-major-version 24)
  (require-package 'zenburn-theme))

(provide 'init-package)
