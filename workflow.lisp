(in-package :stumpwm)

;;; Note: placement rules are saved using the `remember' command, then dumped to
;;; file using `dump-window-placement-rules' and the desktop (frame
;;; configuration) with `dump-desktop'.  This file also includes a function
;;; `create-window-placement-rules' to help with the creation of placement rules
;;; from the current windows.

(load-user-module "slack")

(defcommand brest-setup () ()
  (brest-monitor-setup)
  (clear-window-placement-rules)
  (restore-from-file "~/.stumpwm.d/dumps/brest-office.desktop")
  (restore-window-placement-rules "~/.stumpwm.d/dumps/brest-office.rules")
  (refresh-heads)  ; otherwise I get errors sometimes, do that before placing
                   ; windows
  (place-existing-windows)
  (firefox)
  (slack)
  (skype)
  (run-or-raise "xterm" '(:class "Xterm"))
  (emacs)
  (set-xrate))

(defcommand brest-monitor-setup () ()
  (run-shell-command "~/.screenlayout/brest-office.sh"))

(defcommand laptop-setup () ()
  (clear-window-placement-rules)
  (restore-from-file "~/.stumpwm.d/dumps/laptop.desktop")
  (restore-window-placement-rules "~/.stumpwm.d/dumps/laptop.rules")
  (refresh-heads) ; otherwise I get errors sometimes, do that before placing
                  ; windows
  (place-existing-windows)
  (firefox)
  (emacs)
  (set-xrate))

(defcommand start-brest () ()
  "This command sets up windows and frames for work, and start slack, etc."
  (work-clock-in)
  (brest-setup)
  ;; (slack-hello)
  )

(defcommand stop-work () ()
  "The end of the day has come, time to go home!"
  ;; (slack-bye)
  (delete-all-windows "Skype")
  (work-clock-out)
  (xlock))

(defcommand lunch () ()
  (work-clock-out)
  ;; (slack-lunch)
  (xlock))

(defcommand back-from-lunch () ()
  (work-clock-in)
  ;; (slack-back-from-lunch)
  )

(defun delete-all-windows (window-class)
  "Delete all window of class WINDOW-CLASS."
  (dolist (win (group-windows (current-group)))
    (when (string= (window-class win) window-class)
      (delete-window win))))

(defun create-window-placement-rules ()
  "Create window placement rules for all windows in the current group."
  (clear-window-placement-rules)
  (dolist (win (group-windows (current-group)))
    (make-rule-for-window win nil nil)))

(defun slack-hello ()
  (slack-say "Hello guys!")
  (slack-set-active)
  (unless (slack-running-p)
    (slack)))

(defun slack-lunch ()
  (slack-say "Lunch time!")
  (slack-set-away))

(defun slack-back-from-lunch () ()
       (slack-say "Back from lunch!")
       (slack-set-active))

(defun slack-bye ()
  (slack-say "Time to go! See you guys tomorrow!")
  (slack-set-away)
  (slack-kill))

(defun set-xrate ()
  ;; for some reason I have to reevaluate tnis
  (run-shell-command "xset r rate 200 100"))

(defun work-clock-in ()
  (run-shell-command "emacsclient -ne \"(work-clock-in)\""))

(defun work-clock-out ()
  (run-shell-command "emacsclient -ne \"(work-clock-out)\""))
