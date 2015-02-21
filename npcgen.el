;;; NPC generator for Basic d20 system.

(defun d6 ()
  (+ (random 6) 1))

(defun roll-stat ()
  (+ (d6) (d6) (d6)))

(defun mod-stat (stat)
  (check-type stat integer)
  (cond ((<= stat 1) -5)
	((and (>= stat 2) (<= stat 19)) (- (floor (/ stat 2)) 5))
	(5)))


(defvar *gender* 0)
(defvar *pronoun* '("His" "Her"))
(defvar *stat-full-names* '("Strength" "Dexterity" "Constitution"
			    "Intelligence" "Wisdom" "Charisma"))
(defvar *stat-names* '("STR" "DEX" "CON" "INT" "WIS" "CHA"))
(defvar *stat-values* '())
(defvar *stat-mods* '())

(defun generate-abilities ()
  (dotimes (i 6)
    (push (roll-stat) *stat-values*)))

(defun generate-all ()
  (purge-all)
  (generate-abilities)
  (dolist (i *stat-values*)
    (push (mod-stat i) *stat-mods*))
  (setf *stat-mods* (reverse *stat-mods*)))

(defun validate (stat-mods)
  (let ((mods stat-mods))
    (if (or (> (apply '+ mods) 0)
	    (> (nth 0 (sort mods '<)) 1))
	t
      nil)))

(defun purge-all ()
  (setf *stat-values* '())
  (setf *stat-mods* '()))

(defun describe-stat (modifier)
  (cond ((= modifier -5) "Abysymal")
	((= modifier -4) "Awful")
	((= modifier -3) "Bad")
	((= modifier -2) "Poor")
	((= modifier -1) "Medicore")
	((= modifier 0) "Fair")
	((= modifier 1) "Good")
	((= modifier 2) "Great")
	((= modifier 3) "Exceptional")
	((= modifier 4) "Amazing")
	("Phenomenal")))

(defun meaning-stat (modifier)
  (cond ((= modifier -5) "Severely Handicapted")
	((= modifier -4) "Severely Impaired")
	((= modifier -3) "Impaired")
	((= modifier -2) "Significantly Below Average")
	((= modifier -1) "Below Average")
	((= modifier 0) "Average")
	((= modifier 1) "Above Average")
	((= modifier 2) "Significantly Above Average")
	((= modifier 3) "Gifted")
	((= modifier 4) "Highly Gifted")
	("Excetionally Gifted")))

(defun describe-character ()
  (let ((index 0))
    (setf *gender* (random 2))
    (while (< index 6)
      (insert (nth *gender* *pronoun*) " "
	      (nth index *stat-full-names*) " is rather "
	      (describe-stat (nth index *stat-mods*)) " making "
	      (nth *gender* *pronoun*) " quite "
	      (meaning-stat (nth index *stat-mods*)) " for "
	      (nth *gender* *pronoun*) " kind.\n")
      (setf index (+ index 1)))))

(defun output-character-stats ()
  (let ((index 0))
    (generate-all)
    (if (validate *stat-mods*)
	(progn
	  (switch-to-buffer-other-window "*character*")
	  (erase-buffer)
	  (while (< index 6)
	    (insert (nth index *stat-names*)
		    "\t"
		    (number-to-string (nth index *stat-values*))
		    "\t"
		    (number-to-string (nth index *stat-mods*))
		    "\n")
	    (setf index (+ index 1)))
	  (insert "\n\n")
	  (describe-character))
      (output-character-stats))))

