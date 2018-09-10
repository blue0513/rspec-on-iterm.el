;;; rspec-on-iterm.el --- execute rspec on iterm2

;;; Commentary:
;; Add the following to your Emacs init file:
;;
;; (require 'rspec-on-iterm)

;;; Code:

;; You should create iterm.el reffered from
;; https://gist.github.com/johnmastro/88cc318f4ce33b626c9d
;; If you need, add Path

(add-to-list 'load-path "~/.emacs.d/iterm")
(require 'iterm)
(defun iterm-send-string (str)
  (let* ((str (iterm-maybe-remove-empty-lines str))
	 (str (iterm-handle-newline str))
	 (str (iterm-escape-string str)))
    (shell-command (concat "osascript "
			   "-e 'tell app \"iTerm2\"' "
			   "-e 'tell current window' "
			   "-e 'tell current session' "
			   "-e 'write text \"" str "\"' "
			   "-e 'end tell' "
			   "-e 'end tell' "
			   "-e 'end tell' "))))

;; Ref: https://stackoverflow.com/a/23960720/8888451
(defun git-dir-path ()
  (let* ((path buffer-file-name)
	 (root (file-truename (vc-git-root path)))
	 (filename (file-name-nondirectory path))
	 (filename-length (length filename)))
    (let ((chunk (file-relative-name path root)))
      (substring chunk 0 (- (length chunk) filename-length)))))

(defun executable-rspec-string()
  (let* ((path buffer-file-name)
	 (filename (file-name-nondirectory path))
	 (line-number (number-to-string (line-number-at-pos)))
	 (target-dir (file-truename (vc-git-root path))))
    (concat "cd " target-dir ";"
	    "RAILS_ENV=test rspec " (git-dir-path) filename ":" line-number)))

;;;###autoload
(defun send-executable-text-to-iterm()
  (interactive)
  (let* ((str (executable-rspec-string)))
    (iterm-send-string str)))

;;;###autoload
(defun copy-executable-text()
  (interactive)
  (let* ((str (executable-rspec-string)))
    (kill-new str)))

(provide 'rspec-on-iterm)

;;; rspec-on-iterm.el ends here
