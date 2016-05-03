(in-package :stumpwm)

(defmacro defapp (command &optional win-class)
  (unless win-class
    (setf win-class command))
  `(defcommand ,(intern (string-upcase command)) () ()
     ,(format nil "Run ~A unless it is already running, in which case focus it." command)
     (run-or-raise ,command '(:class ,(string-capitalize win-class)))))

(defmacro without-windows-placement-rules (&rest body)
  `(let ((rules *window-placement-rules*))
    (clear-window-placement-rules)
    ,@body
    (run-with-timer 1 nil (lambda ()
       (setf *window-placement-rules* rules)))))

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
  (run-shell-command "exec xlock -mode blank -dpmsoff 10"))

(defun curl-get (url &optional collect-output (max-time 10))
  (run-shell-command (format nil "curl -m ~A \"~A\"" max-time url)
                     collect-output))

(defun popup ()
  "Split vertically or horizontally depending on the context."
  (let* ((group (current-group))
        (frame (tile-group-current-frame group)))
    (if (> (frame-width frame) (frame-height frame))
        (hsplit)
        (vsplit))
    (fnext)))

(defmacro with-popup (&rest body)
  "Split depending on the context and evaluate BODY."
  `(progn
     (popup)
     ,@body))

(defun echo-progress (val &key label width)
  (message "~A ~A% ~A"
           (if label (concat label ":") "")
           (round val)
           (progress-string val width)))

(defun progress-string (val &optional width)
  (let* ((width (or width 20))
         (progress (round (* width (/ val 100))))
         (rest (- width progress)))
    (concat "["
            (apply #'concat (loop repeat progress collect "|"))
            "|"
            (apply #'concat (loop repeat rest collect " "))
            "]")))

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

