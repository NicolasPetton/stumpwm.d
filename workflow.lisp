(in-package :stumpwm)

;;; Note: placement rules are saved using the `remember' command, then dumped to
;;; file using `dump-window-placement-rules' and the desktop (frame
;;; configuration) with `dump-desktop'.  This file also includes a function
;;; `create-window-placement-rules' to help with the creation of placement rules
;;; from the current windows.

;; (load-user-module "slack")

(defcommand brest-setup () ()
  (clear-window-placement-rules)
  (run-shell-command "~/.screenlayout/brest-office.sh" t)
  ;; otherwise I get errors sometimes, do that before placing windows
  (refresh-heads)

  (restore-from-file "~/.stumpwm.d/dumps/brest-office.desktop")
  (restore-window-placement-rules "~/.stumpwm.d/dumps/brest-office.rules")
  (place-existing-windows)

  (skype)
  (firefox)
  (slack)
  (run-or-raise "xterm" '(:class "Xterm"))
  (emacs)

  (enable-mode-line (current-screen)
                    (nth 0 (screen-heads (current-screen)))
                    nil)
  (enable-mode-line (current-screen)
                    (nth 1 (screen-heads (current-screen)))
                    t)
  (set-xrate))

(defcommand laptop-setup () ()
  (clear-window-placement-rules)
  (run-shell-command "~/.screenlayout/laptop.sh" t)
  ;; otherwise I get errors sometimes, do that before placing windows
  (refresh-heads)

  (restore-from-file "~/.stumpwm.d/dumps/laptop.desktop")
  (restore-window-placement-rules "~/.stumpwm.d/dumps/laptop.rules")
  (place-existing-windows)

  (firefox)
  (emacs)

  (enable-mode-line (current-screen)
                    (nth 0 (screen-heads (current-screen)))
                    t)

    (set-xrate))

(defcommand work-start-brest () ()
  "This command sets up windows and frames for work, and start slack, etc."
  (work-start)
  (brest-setup))

(defcommand work-stop () ()
  "The end of the day has come, time to go home!"
  (delete-all-windows "Skype")
  (work-stop)
  (xlock))

(defcommand lunch () ()
  (work-lunch)
  (xlock))

(defcommand back-from-lunch () ()
  (work-back-from-lunch))

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

(defun set-xrate ()
  ;; for some reason I have to reevaluate this
  (run-shell-command "xset r rate 250 50"))

(defun work-start ()
  (run-shell-command "emacsclient -ne \"(work-start)\""))

(defun work-stop ()
  (run-shell-command "emacsclient -ne \"(work-stop)\""))

(defun work-lunch ()
  (run-shell-command "emacsclient -ne \"(work-lunch)\""))

(defun work-back-from-lunch ()
  (run-shell-command "emacsclient -ne \"(work-back-from-lunch)\""))
