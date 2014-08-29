;;; resurrect.el

;: Koji Mitsuda <fbkante2u atmark gmail.com>
;; Keywords: convenience
;; Version: 0.9

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

;; To use resurrect, just add the following code into your .emacs:
;;
;;    (require 'resurrect)
;;    (resurrect-mode 1)
;;

;;直前にkill-bufferしたファイルを開く。
;;recentfに依存している。
;;recentf-excludeに登録されているファイルは無視する。
(require 'recentf)

(defvar resurrect-history nil)
;;無制限に長くなっても仕方ないので、制限をつける。nilなら無制限。
(defvar resurrect-history-size 10)

;;直前にkillしたファイルを開く
(defun resurrect-file ()
  (interactive)
  (if (null resurrect-history)
      (error "Resurrect history empty")
    (find-file (car resurrect-history))))

(defun resurrect-find-file ()
  (let* ((fname (buffer-file-name))
	 (list (mapcar (lambda (f) (if (equal f fname) nil f)) resurrect-history)))
    (setq resurrect-history (delq nil list))))

(defun resurrect-kill-buffer ()
  (let ((fname (buffer-file-name)))
    (when (and fname (recentf-include-p fname))
      (push fname resurrect-history)))
  (when resurrect-history-size
    (setq resurrect-history (recentf-trunc-list resurrect-history resurrect-history-size))))

(defun resurrect-enable ()
  (add-hook 'kill-buffer-hook 'resurrect-kill-buffer)
  (add-hook 'find-file-hook 'resurrect-find-file)
  (setq resurrect-history nil))

(defun resurrect-disable ()
  (remove-hook 'kill-buffer-hook 'resurrect-kill-buffer)
  (remove-hook 'find-find-hook 'recurrect-find-file))

(define-minor-mode resurrect-mode
  "resurrect mode"
  :global t
  (if resurrect-mode (resurrect-enable) (resurrect-disable)))

(provide 'resurrect)
