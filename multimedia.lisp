(in-package :stumpwm)
(load-user-module "utils")

(defun brightness-adjust (delta)
  (run-shell-command (concat "exec xbacklight " delta))
  (echo-progress (brightness-get) :label "Brightness"))

(defun brightness-get ()
  (read-from-string (run-shell-command "xbacklight" t)))

(defcommand brightness-inc () ()
  (brightness-adjust "+10"))

(defcommand brightness-dec () ()
  (brightness-adjust "-10"))

(defun volume-get ()
  (let ((output (run-shell-command "amixer -D pulse get Master" t)))
    (multiple-value-bind (result matches)
        (cl-ppcre:scan-to-strings "([0-9]+)%" output)
      (read-from-string (aref matches 0)))))

(defun volume-adjust (delta)
  "DELTA should be like \"5%+\"."
  (run-shell-command (format nil "amixer -D pulse set Master ~D" delta))
  ;; (run-shell-command "play ~/.stumpwm.d/sounds/drip.ogg")
  (echo-progress (volume-get) :label "Volume" :width 40))

(defcommand volume-inc () ()
  (volume-adjust "5%+"))

(defcommand volume-dec () ()
  (volume-adjust "5%-"))

(defcommand volume-inc-small () ()
  (volume-adjust "1%+"))

(defcommand volume-dec-small () ()
  (volume-adjust "1%-"))

(defcommand volume-toggle () ()
  (run-shell-command "exec amixer set Master toggle"))

(defcommand screenshot () ()
  (run-shell-command "scrot"))

(defcommand screenshot-part () ()
  (run-shell-command "scrot -s"))
