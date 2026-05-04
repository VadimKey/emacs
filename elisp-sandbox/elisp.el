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
      (while (re-search-forward "^(defun" nil t)
        (setq lengths-list (cons (count-words-in-defun) lengths-list)))
      (kill-buffer buffer)
      lengths-list)))

(lengths-list-file "elisp2.el")
(lengths-list-file "/usr/share/emacs/30.2/lisp/emacs-lisp/debug.el.gz")

(defun lengths-list-many-files (list-of-files)
  (let (lengths-list)
    (while list-of-files
      (setq lengths-list
            (append
             lengths-list
             (lengths-list-file
              (expand-file-name (car list-of-files)))))
      (setq list-of-files (cdr list-of-files)))
    lengths-list))
  

(lengths-list-many-files '("elisp2.el" "/usr/share/emacs/30.2/lisp/emacs-lisp/debug.el.gz"))


(insert-rectangle '("first" "second" "third"))

(apply 'max '(4 8 5))

(defun column-of-graph (max-graph-height actual-height)
  (let ((insert-list nil)
        (number-of-top-blanks
         (- max-graph-height actual-height)))
    ;;; Fill in asterisks
    (while (> actual-height 0)
      (setq insert-list (cons "*" insert-list))
      (setq actual-height (1- actual-height)))

    ;;; Fill in blanks
    (while (> number-of-top-blanks 0)
      (setq insert-list (cons " " insert-list))
      (setq number-of-top-blanks (1- number-of-top-blanks)))

    ;; Return the whole list
    insert-list))

(column-of-graph 5 3)



(defun triangle-bugged (number)
  "Return sum of numbers 1 through NUMBER inclusive."
  (let ((total 0))
    (while (> number 0)
      (setq total (+ total number))
      (setq number (1= number))) ; Error here
    total))

(triangle-bugged 4)

(defvar Y-axis-tic " - " "String that follows number in a Y axis label.")
(defvar Y-axis-label-spacing 5 "Number of lines from one Y axis label to next.")

;;;
;;; Plot graph
;;;
(defun Y-axis-element (number full-Y-label-width)
  "Construct NUMBERed label element.
A numbered element looks like this ` 5 - ',
and is padded as needed so all line up with
the element for the largest number."
  (let* ((leading-spaces
          (- full-Y-label-width
             (length
              (concat (number-to-string number)
                      Y-axis-tic)))))
  (concat
   (make-string leading-spaces ? )
   (number-to-string number)
   Y-axis-tic)))

(defun Y-axis-column (height width-of-label)
  "Construct list of Y axis labels and blank strings.
For HEIGHT of line above base and WIDTH-OF-LABEL."
  (let (Y-axis)
    (while (> height 1)
      (if (zerop (% height Y-axis-label-spacing))
          ;; Insert label.
          (setq Y-axis
                (cons
                 (Y-axis-element height width-of-label)
                 Y-axis))
        ;; Else, insert blanks.
        (setq Y-axis
              (cons
               (make-string width-of-label ? )
               Y-axis)))
      (setq height (1- height)))

    ;; Insert base line.
    (setq Y-axis
          (cons (Y-axis-element 1 width-of-label) Y-axis))
    (nreverse Y-axis)))

(Y-axis-column 12 6)

(defun print-Y-axis (height full-Y-label-width)
  "Insert Y axis using HEIGHT and FULL-Y-LABEL-WIDTH.
Height must be the maximum height of the graph.
Full width is the width of the highest label element."
  ;; Value of height and full-Y-label-width
  ;; are passed by print-graph
  (let ((start (point)))
    (insert-rectangle
     (Y-axis-column height full-Y-label-width))
    ;; Place point ready for inserting graph.
    (goto-char start)
    ;; Move point forward by value of full-Y-label-width
    (forward-char full-Y-label-width)))

(defvar graph-symbol "*" "String used as symbol in graph, usually an asterisk.")
(defvar graph-blank " " "String used as blank in graph, usually a blank space.
graph-blank must be the same number of columns wide
as graph-symbol.")

(defvar X-axis-label-spacing
  (if (boundp 'graph-blank)
      (* 5 (length graph-blank)) 5)
  "Number of units from one X axis label to next.")


(defvar X-axis-tic-symbol "|" "String to insert to point to a column in X axis.")

(defun print-X-axis-tic-line (number-of-X-tics X-axis-leading-spaces X-axis-tic-element)
  "Print ticks for X axis."
  (insert X-axis-leading-spaces)
  (insert X-axis-tic-symbol) ; Under first column.
  ;; Insert second tick in the right spot.
  (insert (concat
           (make-string
            (-  (* symbol-width X-axis-label-spacing)
                ;; Insert white space up to second tic symbol.
                (* 2 (length X-axis-tic-symbol)))
            ? )
           X-axis-tic-symbol))
  ;; Insert remaining ticks.
  (while (> number-of-X-tics 1)
    (insert X-axis-tic-element)
    (setq number-of-X-tics (1- number-of-X-tics))))


(defun X-axis-element (number)
  "Construct a numbered X axis element."
  (let ((leading-spaces
         (- (* symbol-width X-axis-label-spacing)
            (length (number-to-string number)))))
    (concat (make-string leading-spaces ? )
            (number-to-string number))))

(defun print-X-axis-numbered-line (number-of-X-tics X-axis-leading-spaces)
  "Print line of X-axis numbers"
  (let ((number X-axis-label-spacing))
    (insert X-axis-leading-spaces)
    (insert "1")
    (insert (concat
             (make-string
              ;; Insert white space up to next number.
              (- (* symbol-width X-axis-label-spacing) 2)
              ? )
             (number-to-string number)))
    ;; Insert remaining numbers.
    (setq number (+ number X-axis-label-spacing))
    (while (> number-of-X-tics 1)
      (insert (X-axis-element number))
      (setq number (+ number X-axis-label-spacing))
      (setq number-of-X-tics (1- number-of-X-tics)))))

(defun print-X-axis (numbers-list)
  "Print X axis labels to length of NUMBERS-LIST."
  (let* ((leading-spaces
          (make-string full-Y-label-width ? ))
         ;; symbol-width is provided by graph-body-print
         (tic-width (* symbol-width X-axis-label-spacing))
         (X-length (length numbers-list))
         (X-tic
          (concat
           (make-string
            ;; Make a string of blanks.
            (- (* symbol-width X-axis-label-spacing)
               (length X-axis-tic-symbol))
            ? )
           ;; Concatenate blanks with tic symbol.
           X-axis-tic-symbol))
         (tic-number
          (if (zerop (% X-length tic-width))
              (/ X-length tic-width)
            (1+ (/ X-length tic-width)))))
    (print-X-axis-tic-line tic-number leading-spaces X-tic)
    (insert "\n")
    (print-X-axis-numbered-line tic-number leading-spaces)))

(progn
  (let ((full-Y-label-width 5)
        (symbol-width 1))
    (print-X-axis
     '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16))))


