;;; poptoshell.el --- get to the process buffer and input mark

;; Copyright (C) 1999-2011 Free Software Foundation, Inc. and Ken Manheimer

;; Author: Ken Manheimer <ken dot manheimer at gmail...>
;; Maintainer: Ken Manheimer <ken dot manheimer at gmail...>
;; Created: 1999 -- first public release
;; Keywords: processes
;; Website: http://myriadicity.net/software-and-systems/craft/crafty-hacks/emacs-sundries/poptoshell.el/view
;;
;;; Commentary:
;;
;; I bind to M-<space>, via eg: (global-set-key "\M- " 'pop-to-shell)
;; See the pop-to-shell docstring for details.
;;
;; klm, 02/09/1999.

(defvar non-interactive-process-buffers '("*compilation*" "*grep*"))

(require 'comint)
(require 'shell)

(provide 'poptoshell)

(defcustom pop-to-shell-frame nil
  "*If non-nil, jump to a frame already showing the shell, if any.

Otherwise, open a new window in the current frame."
  :type 'boolean
  :group 'allout)

(defun pop-to-shell (&optional arg)

  "Like 'shell' command, but:

 - goes to the process mark in current buffer, if it is associated
   with a process \(and not among those named on
   `non-interactive-process-buffers'), or 
 - goes to a window that is already showing a shell buffer, if any
   \(leaving the cursor in the current position - repeating the
    invocation will then go to the process mark)
 - pops open a new shell buffer, if necessary
 - resumes the process, if it's stopped
 - A repeat count prompts for the buffer name to use \(which will be
   bracketed by asterisks - a regrettable comint requirement\).

Thus you can use this command from within the shell buffer to get to
the shell input point, or from outside the shell buffer to pop to a
shell buffer, without displacing the current buffer."

  (interactive "P")

  (if (not (boundp 'shell-buffer-name))
      (setq shell-buffer-name "*shell*"))

  (let* ((from (current-buffer))
	 (temp (if arg
		   (read-from-minibuffer
		    (format "Shell buffer name [%s]: " shell-buffer-name))
		 shell-buffer-name))
	 ;; Make sure it is bracketed with asterisks; silly.
	 (target-shell-buffer-name (if (string= temp "")
				       shell-buffer-name
				     (bracket-asterisks temp)))
	 (curr-buff-proc (or (get-buffer-process from)
                             (and (boundp 'erc-process)
                                  erc-process)))
	 (buff (if (and curr-buff-proc
			(not (member (buffer-name from)
				     non-interactive-process-buffers)))
		   from
		 (get-buffer target-shell-buffer-name)))
	 (inwin nil)
	 (num 0)
	 already-there)
    (if (and curr-buff-proc
	     (not arg)
	     (eq from buff)
	     (not (eq target-shell-buffer-name (buffer-name from))))
	;; We're in a buffer with a shell process, but not named shell
	;; - stick with it, but go to end:
	(setq already-there t)
      (cond
       ;;;					; Force other:
       ;;;(arg (switch-to-buffer shell-buffer-name))
					; Already in the shell buffer:
       ((string= (buffer-name) target-shell-buffer-name)
	(setq already-there t))
       ((or (not buff)
	    (not (catch 'got-a-vis
                   (my-walk-windows
                    (function (lambda (win)
                                (if (and (eq (window-buffer win) buff)
                                         (equal (frame-parameter
                                                 (selected-frame) 'display)
                                                (frame-parameter
                                                 (window-frame win) 'display)))
                                    (progn (setq inwin win)
                                           (throw 'got-a-vis win))
                                  (setq num (1+ num)))))
                    nil 'visible t)
                   nil)))
	;; No preexisting shell buffer, or not in a visible window:
	(pop-to-buffer target-shell-buffer-name pop-up-windows))
       ;; Buffer exists and already has a window - jump to it:
       (t (if (and pop-to-shell-frame
                   inwin
                   (not (equal (window-frame (selected-window))
                               (window-frame inwin))))
              (select-frame-set-input-focus (window-frame inwin)))
	  (if (not (string= (buffer-name (current-buffer))
			    target-shell-buffer-name))
	      (pop-to-buffer target-shell-buffer-name t))))
      (condition-case err
	  (if (not (comint-check-proc (current-buffer)))
	      (start-shell-in-buffer (buffer-name (current-buffer))))
	(file-error
	 ;; Whoops - can't get to the default directory, keep trying
	 ;; superior ones till we get somewhere that's acceptable:
	 (while (and (not (string= default-directory ""))
		     (not (condition-case err (progn (shell) t)
			    (file-error nil))))
	   (setq default-directory
		 (file-name-directory
		  (substring default-directory
			     0
			     (1- (length default-directory)))))))
	))
    ;; If the destination buffer has a stopped process, resume it:
    (let ((process (get-buffer-process (current-buffer))))
      (if (and process (equal 'stop (process-status process)))
          (continue-process process)))
    (if (and (not already-there)
	     (not (equal (current-buffer) from)))
	t
      (goto-char (point-max))
      (and (get-buffer-process from)
           (goto-char (process-mark (get-buffer-process from)))))
    )
  )
(defun my-walk-windows (func &optional minibuf all-frames selected)
  (if (featurep 'xemacs)
      (walk-windows func minibuf all-frames (selected-device))
    (walk-windows func minibuf all-frames)))

(defun my-set-mouse-position (window x y)
  "Adapt for both xemacs and fsf emacs"
  (if (string= (substring (emacs-version) 0 6) "XEmacs")
      (set-mouse-position window x y)
    (let ((frame (window-frame window)))
      (select-frame-set-input-focus frame))))

(defun bracket-asterisks (name)
  "Return a copy of name, ensuring it has an asterisk at the beginning and end."
  (if (not (string= (substring name 0 1) "*"))
      (setq name (concat "*" name)))
  (if (not (string= (substring name -1) "*"))
      (setq name (concat name "*")))
  name)
(defun unbracket-asterisks (name)
  "Return a copy of name, removing asterisks at beg and end, if any."
  (if (string= (substring name 0 1) "*")
      (setq name (substring name 1)))
  (if (string= (substring name -1) "*")
      (setq name (substring name 0 -1)))
  name)
(defun start-shell-in-buffer (buffer-name)
  ;; Damn comint requires buffer name be bracketed by "*" asterisks.
  (require 'comint)
  (require 'shell)

  (let* ((buffer buffer-name)
	 (prog (or explicit-shell-file-name
		   (getenv "ESHELL")
		   (getenv "SHELL")
		   "/bin/sh"))		     
	 (name (file-name-nondirectory prog))
	 (startfile (concat "~/.emacs_" name))
	 (xargs-name (intern-soft (concat "explicit-" name "-args"))))
    (setq buffer (set-buffer (apply 'make-comint
				    (unbracket-asterisks buffer-name)
				    prog
				    (if (file-exists-p startfile)
					startfile)
				    (if (and xargs-name
					     (boundp xargs-name))
					(symbol-value xargs-name)
				      '("-i")))))
    (set-buffer buffer-name)
    (shell-mode)))
