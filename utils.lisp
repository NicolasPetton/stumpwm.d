(in-package :stumpwm)

(defmacro defapp (command &optional win-class)
  (unless win-class
    (setf win-class command))
  `(defcommand ,(intern (string-upcase command)) () ()
     ,(format nil "Run ~A unless it is already running, in which case focus it." command)
     (run-or-raise ,command '(:class ,(string-capitalize win-class)))))

;; prompt the user for an interactive command. The first arg is an
;; optional initial contents.
(defcommand colon1 (&optional (initial "")) (:rest)
  (let ((cmd (read-one-line (current-screen) ": " :initial-input initial)))
    (when cmd
      (eval-command cmd t))))

(defcommand (fprev tile-group) () ()
"Cycle through the frame tree to the previous frame."
  (focus-prev-frame (current-group)))

(defun global-set-key (key command)
  (define-key *top-map* key command))

(defun delete-all-windows-matching (properties)
  (mapcar #'delete-window (find-matching-windows properties t t)))

(defun pass (key)
  (string-trim " 
" (run-shell-command (format nil "pass ~A" key) t)))

(defcommand xlock () ()
  (run-shell-command "exec xlock -mode blank"))

(defun curl-get (url &optional get-result)
  (run-shell-command (format nil "curl \"~A\"" url) get-result))

(defun echo-progress (val &key label width)
  (message "~A ~A% ~A"
           (if label (concat label ":") "")
           (round val)
           (progress-string val width)))

(defun progress-string (val &optional width)
  (let* ((width (or width 20))
         (progress (round (* width (/ val 100))))
         (rest (- width progress)))
    (concat "|"
            (apply #'concat (loop repeat progress collect "="))
            ">"
            (apply #'concat (loop repeat rest collect " "))
            "|")))

;; Web jump (works for DuckDuckGo and Imdb)
(defmacro make-web-jump (name prefix)
  `(defcommand ,(intern name) (search) ((:rest ,(concatenate 'string name " search: ")))
    (substitute #\+ #\Space search)
    (run-shell-command (concatenate 'string ,prefix search))))

(make-web-jump "duck" "firefox http://www.duckduckgo.com/?q=")
(make-web-jump "imdb" "firefox http://www.imdb.com/find?q=")

;; Idea from <https://github.com/stumpwm/stumpwm/wiki/FAQ>.
(defun key-seq-msg (key key-seq cmd)
  "Show a message with current incomplete key sequence."
  (declare (ignore key))
  (or (eq *top-map* *resize-map*)
      (stringp cmd)
      (let ((*message-window-gravity* :bottom-left))
        (message "~A" (print-key-seq (reverse key-seq))))))
;; (add-hook *key-press-hook* #'key-seq-msg)

