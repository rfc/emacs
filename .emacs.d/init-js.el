;; ============================================================================= 
;; init-js.el
;; =============================================================================

(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$'" . js2-mode))
(setq js-indent-level 4)

(provide 'init-js)
