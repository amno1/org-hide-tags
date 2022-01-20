;;; org-hide-tags.el --- Hide org-babel source code markers  -*- lexical-binding: t; -*-

;; Copyright (C) 2021  Arthur Miller

;; Author: Arthur Miller <arthur.miller@live.com>
;; Keywords: convenience, outlines, tools

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;; Author: Arthur Miller
;; Version: 0.0.1
;; Keywords: tools convenience
;; Package-Requires: ((emacs "24.1"))
;; URL: https://github.com/amno1/org-hide-tags

;;; Commentary:

;; A minor mode to help reduce clutter in org-mode files by
;; hiding/unhiding leading tags in headings in org-mode.
;;
;; To hide all markers turn on org-hbm-mode by
;;
;;          `M-x org-hide-tags-mode.'
;;
;; To turn it off execute the same command.

;;; Issues

;;; Code:
(require 'org)

(defgroup org-hide-tags nil
  "Hide tags in org-headings."
  :prefix "org-hide-tags-"
  :group 'org)

(defvar org-leading-stars-re "^[ \t]*\\*+"
  "Regex used to recognize leading stars in org-headings.")

(defun org-hide-tags--update-headings (visibility)
  "Update invisible property to VISIBILITY for markers in the current buffer."
  (save-excursion
    (goto-char (point-min))
    (with-silent-modifications
      (while (re-search-forward org-leading-stars-re nil t)
        (goto-char (line-end-position))
        (if (re-search-backward org-tag-line-re (line-beginning-position) t)
            (put-text-property
             (match-beginning 1) (match-end 1) 'invisible visibility))
          (forward-line)))))

;;;###autoload
(define-minor-mode org-hide-tags-mode
  "Hide/show babel source code blocks on demand."
  :global nil :lighter " Org-hls"
  (unless (derived-mode-p 'org-mode)
    (error "Not in org-mode"))
  (cond (org-hide-tags-mode
         (org-hide-tags--update-headings t))
        (t (org-hide-tags--update-headings nil))))

(provide 'org-hide-tags)

;;; org-hide-tags.el ends here
