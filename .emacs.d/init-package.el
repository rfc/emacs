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

(package-initialize)

(require-package 'auto-complete)
(require-package 'auto-complete-clang)
(require-package 'autopair)
(require-package 'dropdown-list)
(require-package 'ecb)
(require-package 'fill-column-indicator)
(require-package 'flymake-cursor)
(require-package 'go-mode)
(require-package 'highlight-parentheses)
(require-package 'highlight-symbol)
(require-package 'inf-ruby)
(require-package 'magit)
(require-package 'python-mode)
(require-package 'ruby-mode)
(require-package 'web-mode)
(require-package 'window-numbering)
(require-package 'yasnippet)
(require-package 'zenburn-theme)
