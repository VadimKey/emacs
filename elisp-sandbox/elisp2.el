;; 5.3.1 optional arguments
;; &optional keyword
(defun beg-of-buf (&optional arg)
  "jump to the beginning of the buffer or to N/10 offset from beginning
if \\[universal argument]] prefix is used. also mark is set at previous position"
  (interactive "P") ;; P means pass a prefix argument in raw form
  (or (consp arg)
      (and transient-mark-mode mark-active)
      (push-mark))

  (let ((size (- (point-max) (point-min) ) ) )
    (goto-char (if (and arg (not (consp arg) ) )
                   (+ (point-min)
                      (if (> size 10000)
                          ;; avoid overflow for large buffer sizes
                          (* (prefix-numeric-value arg)
                             (/ size 10) )
                        (/ (+ 10 (* size (prefix-numeric-value arg)))
                           10)))
                 (point-min))))
  (if (and arg (not (consp arg))) (forward-line 1)))

(defun ex-5-5 (&optional arg)
  "checks if argument is >= than fill-column, if argument is not provided use 56)"
  (interactive)
  (unless arg (setq arg 56))
  (if (>= arg fill-column)
      (message "%s >= fill-column" arg)
    (message "%s < fill-column" arg)))

(ex-5-5 140)
(ex-5-5)
(ex-5-5 10)

;;
;; Chapter 6
;;
;; narrowing C-x n n
;; widening  C-x n w
;;
;; if save-excursion is used together (strictly one after another)
;; with save-restriction then save-excursion should go first
;;
(defun quelle-ligne ()
  "print the current line number (in the buffer) of point"
  (interactive)
  (save-restriction
    (widen)
    (save-excursion
      (beginning-of-line)
      (message "ligne %d" (1+ (count-lines 1 (point)))))))

(defun premiere-60 ()
  "Display the first 60 chars of the original buffer"
  (interactive)
  (save-restriction
    (widen)
    (save-excursion
      (message "First 60 chars of this buffer: %s"
               (buffer-substring 1 60)))))

;;
;; Chapter 7 - fundamental functions
;; car, cdr, cons
;;

;; cons - construct
;; car  - contents of the address part of the register
;; cdr  - pronounced 'could-er', acronym of "contents of the decrement part of the register"
;; car / cdr comes from IBM 704 time (1954) LISP was created on IBM704 in 1958

;; CAR of a list is the 1st item in the list
(car '(rose violet daisy buttercup))

;; nth (returns nth element of the list)
(nth 0 '(rose violet daisy buttercup))
(nth 2 '(rose violet daisy buttercup))

;; CDR the list without the first element
(cdr '(rose violet daisy buttercup))

(cdr (cdr '(pine fir oak maple)))

;; nthcdr
(nthcdr 2 '(pine fir oak maple)) ;; the same as example above with cdr
(nthcdr 0 '(pine fir oak maple))
(nthcdr 4 '(pine fir oak maple))
(nthcdr 14 '(pine fir oak maple))

(car '((lion tiger cheetah)
       (gazelle antelope zebra)
       (whale dolphin seal)))

;; cons
(cons 'pine '(fir oak maple))

(cons 'butterup () )

(cons 'daisy '(buttercup))

;; length
(length '(rose violet daisy buttercup))

;; setcar - replace the first item in the list
;; create a list of animals
(setq animals (list 'antelope 'giraffe 'lion 'tiger))

animals

;; replace antelope by hippopotamus
(setcar animals 'hippopotamus)

animals

;; setcdr
;; replace rest of the list
(setq domesticated-animals (list 'horse 'cow 'sheep 'goat))
domesticated-animals

(setcdr domesticated-animals '(cat dog))
domesticated-animals

;; Excercises
(cons 'owl (cons 'eagle (cons 'magpie (cons 'crow ()))))
(cons animals animals)

(setq birds '(owl eagle magpie crow))
birds
(setcar birds 'salmon)
birds
(setcdr birds '(carp cod))
birds

;;
;; Chapter 8. Cutting and Storing Text
;;
(nthcdr 1 '("another piece" "a piece of text" "previous piece"))
(car (nthcdr 1 '("another piece" "a piece of text" "previous piece")))
;;
;; 8.1 zap-to-char
;;

(defun test-search (string)
  "Search for a string"
  (interactive "sSearch for: ")
  (when (search-forward string)
      (message "Found!")))

(defun third-kill-ring ()
  "Prints third argument in kill ring"
  (if (< (length kill-ring) 3)
      (message "Kill-ring size less than 3")
    (car (nthcdr 3 kill-ring))))

(third-kill-ring)

;;
;; Chapter 11. Loops and Recursion
;;
max-lisp-eval-depth ;; 1600

(setq animals '(gazelle giraffe lion tiger))

(defun print-elements-of-list (list)
  "print each element of LIST on a line of its own"
  (while list
    (print (car list))
    (setq list (cdr list))))

(print-elements-of-list animals)

(defun triangle (number-of-rows)
  "add up the number of pebbles in a triangle.
the first row has one pebble, the second row two pebbles,
the third row three pebbles, ans so on.
the argument is NUMBER-OF-ROWS."
  (let ((total 0)
        (row-number 1))
    (while (<= row-number number-of-rows)
      (setq total (+ total row-number))
      (setq row-number (1+ row-number)))
    total))

(triangle 3)

(defun triangle2 (number)
  (let ((total 0))
    (while (> number 0)
      (setq total (+ total number))
      (setq number (1- number)))
    total))

(triangle2 4)

(defun reverse-list (list)
  (let (value)
    (dolist (element list value)
      (setq value (cons element value)))))

(setq animals '(gazelle giraffe lion tiger))
(reverse-list animals)

(defun triangle3 (number-of-rows)
  (let ((total 0))
    (dotimes (number number-of-rows)
      (setq total (+ total (1+ number))))
    total))

(triangle3 10)

(defun find-two-blank-lines ()
  (interactive)
  (re-search-forward "^[ \t]*\n\\([ \t]*\n\\)+"))

(defun find-duplicated-words ()
  (interactive)
  (re-search-forward "\\b\\(\\w+\\)\\s-+\\1\\b"))

(defun count-words-example (beginning end)
  (interactive "r")
  (message "Counting words in region ... ")

  ;;; 1. setup appropriate conditions
  (save-excursion
    (goto-char beginning)
    (let ((count 0))

      ;;; 2. run the while loop
      (while (and (< (point) end) (re-search-forward "\\w+\\W*" end t))
        (setq count (1+ count)))

      ;;; 3. send a message to the user
      (cond ((zerop count)(message "The region does NOT have any words."))
            ((= 1 count)  (message "The region has 1 word."))
            (t            (message "The region has %d words." count))
            )
      )
    )
  )

(defun count-words-in-defun ()
  (beginning-of-defun)
  (let ((count 0)
        (end (save-excursion (end-of-defun) (point))))
    (while
        (and (< (point) end)
             (re-search-forward
              "\\(\\w\\|\\s_\\)+[^ \t\n]*[ \t\n]*"
              end t))
      (setq count (1+ count)))
    count))

(count-words-in-defun)

(defun count-words-defun ()
  (interactive)
  (message "Counting words and symbols in function definition ... ")
  (let ((count (count-words-in-defun)))
    (cond
     ((zerop count) (message "The definition does NOT have any words or symbols."))
     ((= 1 count) (message "The definition has 1 word or symbol."))
     (t (message "The definition has %d words or symbols." count)))))

(defun lengths-list-file (filename)
  (message "Working on `%s' ... " filename)
  (save-excursion
    (let ((buffer (find-file-noselect filename))
          (lengths-list))
      (set-buffer buffer)
      (setq buffer-read-only t)
      (widen)
      (goto-char (point-min))
      (while (re-search-forward "^(defin" nil t)
        (setq lengths-list (cons (count-words-in-defun) lengths-list)))
      (kill-buffer buffer)
      lengths-list)))

(lengths-list-file "elisp2.el")
