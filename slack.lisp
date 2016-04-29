;;; Convenience function wrapping the slack REST API

(in-package :stumpwm)

(ql:quickload :do-urlencode)
(load-user-module "utils")

(defvar *slack-token-file* "~/.priv/slack_token")

(defun slack-token ()
  (with-open-file (in *slack-token-file* :direction :input)
    (with-standard-io-syntax
      (read-line in))))

(defun slack-say (message)
  (let ((token (slack-token))
        (team "foretagsplatsen")
        (channel "C02N47RE1"))
    (curl-get (format nil
                      "https://~A.slack.com/api/chat.postMessage?token=~A&channel=~A&text=~A&as_user=true"
                      team
                      token
                      channel
                      (do-urlencode:urlencode message)))))

(defun slack-set-presence (presence)
  (let ((token (slack-token))
        (team "foretagsplatsen")
        (channel "C02N47RE1"))
    (curl-get (format nil
                      "https://~A.slack.com/api/presence.set?presence=~A&token=~A&channel=~A&as_user=true"
                      team
                      presence
                      token
                      channel))))

(defun slack-set-away ()
  (slack-set-presence "away"))

(defun slack-set-active ()
  (slack-set-presence "active"))

(defun slack-running-p ()
  (find-matching-windows '(:class "Slack") t t))

(defcommand slack () ()
  "Start slack unless it is already running, in which case focus it."
  (run-or-raise "slack" '(:class "Slack")))

(defun slack-kill ()
  (delete-all-windows-matching '(:class "Slack")))
