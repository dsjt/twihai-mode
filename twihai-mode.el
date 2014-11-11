;;; twihai-mode.el --- twitter haijin

;; Copyright (C) 2014  Ishida Tatsuhiro

;; Author: Ishida Tatsuhiro <toot.daiylfalaiydt@gmail.com>
;; Keywords: tools, games

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:

(requrie 'twittering-mode)

(defvar twihai-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "<C-return>") 'twihai-send-tweet)
    map))

(defvar tweet-border "-----------------------------\n")

(defvar twihai-prompt t)

(define-minor-mode twihai-mode
  ""
  :keymap twihai-mode-map
  :init-value nil
  :lighter " ƒcƒC”p"
  (unless
      (and
       (eq 0 (current-column))
       (save-excursion
             (let* ((end (point))
                    (beg (progn (search-backward tweet-border nil t)
                                (point)))
                    (str (buffer-substring-no-properties beg end)))
               (equal str tweet-border))))
    (insert tweet-border)))

(defun twihai-send-tweet ()
  (interactive)
  (save-excursion
    (end-of-line)
    (let ((beg (point)))
      (cond
       ((search-backward tweet-border nil t)
        (forward-line 1)
        (twihai-tweet-region beg (point) twihai-prompt))
       (t (message "no tweet border.")))))
  (insert (concat "\n" tweet-border)))

(defun twihai-tweet-region(beg end &optional noprompt)
  (interactive "rp")
  (let ((tw-string (buffer-substring-no-properties beg end)))
    (if (or noprompt (y-or-n-p (format "post \"%s\"?" tw-string)))
        (progn (twittering-update-status-from-pop-up-buffer tw-string)
               (twittering-edit-post-status)))))

(provide 'twihai-mode)
;;; twihai-mode.el ends here

