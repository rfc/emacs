;; ============================================================================= 
;; init-python.el
;; =============================================================================

(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))

;; Comint
;; ---------------------------------------------------
(require 'comint)
(define-key comint-mode-map (kbd "M-") 'comint-next-input)
(define-key comint-mode-map (kbd "M-") 'comint-previous-input)
(define-key comint-mode-map [down] 'comint-next-matching-input-from-input)
(define-key comint-mode-map [up] 'comint-previous-matching-input-from-input)

;; Auto-pair
;; ---------------------------------------------------
;(autopair-global-mode)
;(add-hook 'lisp-mode-hook
;          '(lambda () (setq autopair-dont-activate t)))
;
;(autoload 'autopair-global-mode "autopair" nil t)
;(autopair-global-mode)
;(add-hook 'lisp-mode-hook
;          '(lambda () (setq autopair-dont-activate t)))
;
;(add-hook 'python-mode-hook
;          '(lambda ()
;              (push '(?' . ?')
;                    (getf autopair-extra-pairs :code))
;              (setq autopair-handle-action-fns
;                    (list 'autopair-default-handle-action
;                          'autopair-python-triple-quote-action))))
(add-hook 'before-save-hook 'delete-trailing-whitespace)                                    

;; Debugging
;; ---------------------------------------------------
(defvar python-mode-map)
(defun python-add-breakpoint ()
  "Inserts a python breakpoint using 'ipdb'"
  (interactive)
  (back-to-indentation)
  (split-line)
  (insert "import ipdb; ipdb.set_trace()")
  (highlight-lines-matching-regexp "^[ 	]*import ipdb; ipdb.set_trace()"))
(define-key python-mode-map (kbd "<f2>") 'python-add-breakpoint)

(provide 'init-python)
