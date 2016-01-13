(in-package :stumpwm)

;;; Note: placement rules are saved using the `remember' command, then dumped to
;;; file using `dump-window-placement-rules' and the desktop (frame
;;; configuration) with `dump-desktop'.

(load-user-module "slack")

(defcommand brest-setup () ()
  (run-shell-command "~/.screenlayout/brest-office.sh")
  (clear-window-placement-rules)
  (restore-from-file "~/.stumpwm.d/dumps/laptop.desktop")
  (restore-window-placement-rules "~/.stumpwm.d/dumps/laptop.rules")
  (place-existing-windows)
  (firefox)
  (slack)
  (skype)
  (emacs)
  (run-or-raise "xterm" '(:class "Xterm"))
  (set-xrate))

(defcommand laptop-setup () ()
  (clear-window-placement-rules)
  (restore-from-file "~/.stumpwm.d/dumps/laptop.desktop")
  (restore-window-placement-rules "~/.stumpwm.d/dumps/laptop.rules")
  (place-existing-windows)
  (firefox)
  (emacs)
  (set-xrate))

(defcommand start-brest () ()
  "This command sets up windows and frames for work, and start slack, etc."
  (slack-hello)
  (work-clock-in)
  (brest-setup))

(defcommand stop-work () ()
  "The end of the day has come, time to go home!"
  (slack-bye)
  (delete-all-windows "Skype")
  (work-clock-out)
  (xlock))

(defcommand lunch () ()
  (slack-lunch)
  (work-clock-out)
  (xlock))

(defcommand back-from-lunch () ()
  (work-clock-in)
  (slack-back-from-lunch))

(defun delete-all-windows (window-class)
  (dolist (win (group-windows (current-group)))
    (when (string= (window-class win) window-class)
      (delete-window win))))

(defun slack-hello () ()
  (slack-say "Hello guys!")
  (unless (slack-running-p)
    (slack)))

(defun slack-lunch () ()
  (slack-say "Lunch time!"))

(defun slack-back-from-lunch () ()
  (slack-say "Back from lunch!"))

(defun slack-bye () ()
  (slack-say "Time to go! See you guys tomorrow!")
  (slack-kill))

(defun set-xrate ()
  ;; for some reason I have to reevaluate tnis
  (run-shell-command "xset r rate 200 100"))

(defun work-clock-in ()
  (run-shell-command "emacsclient -e \"(work-clock-in)\""))

(defun work-clock-out ()
  (run-shell-command "emacsclient -e \"(work-clock-out)\""))
