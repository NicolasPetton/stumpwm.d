(in-package :stumpwm)

(defun sysfs-battery-files ()
  "Return the battery path of each battery file in sysfs."
  (mapcar (lambda (dirname)
            (merge-pathnames (make-pathname :name "uevent")
                             dirname))
          (remove-if-not (lambda (dir)
                           (cl-ppcre::scan-to-strings "BAT.*" (namestring dir)))
                         (list-directory "/sys/class/power_supply"))))


(defun read-battery-file (filename)
  (let ((result '()))
    (with-open-file (file filename)
      (let ((line (read-line file nil nil)))
        (loop while line
           do
             (setq result (cons (stumpwm::split-string line "=") result))
             (setf line (read-line file nil nil)))))
    result))

(defun parse-battery-info (raw)
  `((energy-now . ,(parse-integer (or (cadr (assoc "POWER_SUPPLY_ENERGY_NOW" raw :test #'string=))
                                      (cadr (assoc "POWER_SUPPLY_CHARGE_NOW" raw :test #'string=)))))
    (energy-full . ,(parse-integer (or (cadr (assoc "POWER_SUPPLY_ENERGY_FULL" raw :test #'string=))
                                        (cadr (assoc "POWER_SUPPLY_CHARGE_FULL" raw :test #'string=)))))))

(defun parse-battery-files ()
  (mapcar #'parse-battery-info
          (mapcar #'read-battery-file (sysfs-battery-files))))

(defun battery-percentages ()
  (mapcar (lambda (data)
            (* (/ (cdr (assoc 'energy-now data))
                  (cdr (assoc 'energy-full data)))
               100.0))
          (parse-battery-files)))

(defun power-ac-p ()
  (string= (with-open-file (file (pathname "/sys/class/power_supply/AC/online"))
             (read-line file nil nil))
           "1"))

(defun battery-percentage ()
  (let ((percentages (battery-percentages)))
    (round (/ (apply #'+ percentages) (length percentages)))))

(defun format-battery-percentage (ml)
  "Return a string to be used in the mode-line."
  (declare (ignore ml))
  (let ((percentage (battery-percentage)))
    (if (power-ac-p)
        "BAT: AC"
        (format nil "BAT: ^[~A~3D%^] "
                (bar-zone-color percentage 90 50 10 t)
                (round percentage)))))

;; Install formatters.
(pushnew '(#\b format-battery-percentage) *screen-mode-line-formatters* :test 'equal)
