;;; Dice roller for old World of Darkness in Elisp

;; How to use it:
;; M-:
;; (load-file "wod.el")
;; M-:
;;; If not specialised
;; (roll nrAtrDice nrSkillDice DC)
;;; If specialised
;; (roll nrAtrDice nrSkillDice DC t)

;; wod-examples.txt provides some outputs.

(defvar *rolls* '())
(defvar *re-rolls* '())
(defvar *fail* 0)
(defvar *win* 0)

(defun d10 ()
  (+ (random 10) 1))

(defun nd10 (n)
  (dotimes (i n)
    (push (d10) *rolls*)))

(defun clear-rolls ()
  (setf *fail* 0)
  (setf *win* 0)
  (setf *rolls* '())
  (setf *re-rolls* '()))

(defun roll (atr skill dc &optional specialist)
  "Roll ATRibute SKILL (for) DC, add t at the end if character is a specialist"
  (clear-rolls)

  (check-type atr integer)
  (check-type skill integer)
  (check-type dc integer)

  (assert (and (>= atr 1) (>= skill 0)))
  (assert (and (>= dc 3) (<= dc 9)))

  (check-type specialist boolean)

  (nd10 (+ atr skill))
  (dolist (i *rolls*)
    (cond ((and (equal i 10) specialist) (push (d10) *re-rolls*))
	  ((equal i 1) (setf *fail* (+ *fail* 1)))
	  ((>= i dc) (setf *win* (+ *win* 1)))))

  (dolist (i *re-rolls*)
    (if (>= i dc)
	(setf *win* (+ 1 *win*))))
  
  (progn
    (switch-to-buffer-other-window "*results*")
    (insert "###########\n")
					;    (erase-buffer)
    
    (insert "Here are all rolls for DC " (number-to-string dc) "\n\t")

    (dolist (i *rolls*)
      (insert (number-to-string i) " "))
    
    (insert "\n\n")
    
    (if (and specialist (> (length *re-rolls*) 0))
	(progn
	  (insert "Specialist got the following re-rolls:\n\t")
	  (dolist (i *re-rolls*)
	    (insert (number-to-string i) " "))
	  (insert "\n\n")))
    
    (insert "Number of successes\t" (number-to-string *win*) "\n"
	    "Number of failures\t" (number-to-string *fail*) "\n"
	    "Evaluation: \t\t"(number-to-string (- *win* *fail*)) "\n\n\t"
	    (cond ((equal (- *win* *fail*) 0) "Neither success not failure.")
		  ((> *win* *fail*) "You have succeeded.")
		  ((< *win* *fail*) "You have failed.")))
    (insert "\n\n")))

(defun test ()
  "This function is for testing, simply generates 50 ouputs of roll function with different inputs."
  (dotimes (i 50)
    (roll (+ 1 (random 6)) (random 5) (+ 3 (random 6)) (oddp i))))
