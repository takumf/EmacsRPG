;;; Basic d20 Character Generator, extensible example.

(defun d6 ()
  "Roll 1d6"
  (+ (random 6) 1))

(defun stat-roll ()
  "Returns sum of 3d6 stat generation"
  (+ (d6) (d6) (d6)))

;; Pretty self-explanatory, names of character atributes
(defvar *stat-names* '("STR" "DEX" "CON" "INT" "WIS" "CHA"))

(defun generate-stats ()
  "Very basic way of generating all statistics of (N)PC"
  (dolist (i *stat-names*)
    (insert i "\t" (number-to-string (stat-roll)) "\n")))

(defun roll-me-a-character ()
  (switch-to-buffer-other-window "*character-generator*")
					;(erase-buffer)
  (generate-stats)
    (insert "\n"))
