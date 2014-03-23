;; ============================================================================= 
;; init-cc.el
;; =============================================================================

(require 'cc-mode)

(setq-default c-basic-offset 4)
(setq c-default-style "stroustrup"
	c-basic-offset 4)

(define-key c-mode-base-map (kbd "RET") 'newline-and-indent)

(c-add-style "my-style" 
	'("stroustrup"
		(indent-tabs-mode . nil)        			; use spaces rather than tabs
	  (c-basic-offset . 4)            			; indent by four spaces
	  (c-offsets-alist . ((inline-open . 0) ; custom indentation rules
			(brace-list-open . 0)
			(statement-case-open . +)))))

(defun my-c++-mode-hook ()
  (c-set-style "my-style")        ; use my-style defined above
  (auto-fill-mode)         
  (c-toggle-auto-hungry-state 1))

(add-hook 'c++-mode-hook 'my-c++-mode-hook)

(defun my-c-mode-cedet-hook ()
 (local-set-key "." 'semantic-complete-self-insert)
 (local-set-key ">" 'semantic-complete-self-insert))
(add-hook 'c-mode-common-hook 'my-c-mode-cedet-hook)

;; Show the current function in the mode line
;; -------------------------------------------
(add-hook 'c-mode-common-hook 
  (lambda ()
    (which-function-mode t)))
    
;; Switch between header and implementation
;; -------------------------------------------
(add-hook 'c-mode-common-hook
  (lambda() 
    (local-set-key  (kbd "C-c o") 'ff-find-other-file)))

;; Highlight FIXME, TODO, BUG
;; -----------------------------------------
(add-hook 'c-mode-common-hook
    (lambda ()
    (font-lock-add-keywords nil
    '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))))
    