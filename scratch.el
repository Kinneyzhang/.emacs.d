(message "hello emacs")
"hello emacs"

(defun hello-world (name)
  "this is a function for print hello message"
  (message "hello %s" name))
(hello-world "kinney")
"hello kinney"

(setq name "kinney")
(message name)
"kinney"

(defvar ask "what's your name?"
  "a variable to ask a question.")
ask
"what's your name?"

(defun circle-area (radix)
  "this is a function to calculate circle's area"
  (let* ((pi 3.14)
	 (area (* pi radix radix)))
    (message "半径为 %.2f 的圆的面积为 %.2f " radix area)))
(circle-area 2)
"半径为 2 的圆的面积为 13 "

;;相当于匿名函数
(funcall (lambda (obj)
  "this is a lambda function."
  (message "hello %s" obj)) "emacs")
"hello emacs"
(setq foo (lambda (obj)
	    (message "hello %s" obj)))
(funcall foo "kinney")
"hello kinney"

(progn
  (setq name "kinney")
  (message "hello %s" name))
"hello kinney"

(defun my-max (a b)
  "this is a function to get the max num"
  (if (> a b)
      a b))
(my-max 15 12)
15

(defun fib (n)
  (cond ((= n 0) 0)
	((= n 1) 1)
	(t (+ (fib (- n 1))
	      (fib (- n 2))))))
(fib 10)
55

(defun factorial (n)
  (let ((res 1))
    (while (> n 1)
      (setq res (* res n)
	    n (- n 1)))
    res))
(factorial 4)
24

(defun square-number-p (n)
  (and (>= n 0)
       (= (/ n (sqrt n)) (sqrt n))))
(square-number-p 5)

(/ 0.0 0.0)
-0.0e+NaN

?A
65

?a
97

?\a
7

?\n
10

?\M-A

;;to string
(concat '(?a ?b ?c ?d ?e))
"abcde"
(concat [?a ?b ?c ?d ?e])
"abcde"
;;to vector
(vconcat "abcde")
[97 98 99 100 101]
;;to list
(append "abcde" nil)
(97 98 99 100 101)
(append [?a ?b ?c ?d] nil)
(97 98 99 100)

;;正则查找

;;cons cell and lis
;;cons cell由两部分组成: car cdr
;引用列表只返回，不求值
'((+ 1 2) 4)
((+ 1 2) 4)
;;按cdr可把列表分为三类
'(1 2 3)
'(1 2 . 3)
'(1 . #1=(2 3 . #1#))
;;列表当数组，堆栈，集合，关联表，树....

;;序列：列表和数组(向量，字符串...)的统称
(safe-length '( 1 2 3 4))
4
; 列表取值nth, 数组取值 aref, 序列通用：elt
(nth 4 '(2 3 4 5 6 7))
6
(aref [1 2 3 4] 2)
3
(aref "emacs" 2)
97
(elt '(a b c d) 2)
c

;;符号...
;;============================hack by myself=====================================
(defun monthly-log-table-create ()
  (interactive)
  (let ((x 0)
	(y 0))
    (setq header-list '("Date" "Event" "Monthly Task")
	  week-list '("Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun"))
    (org-table-create-or-convert-from-region "3x5")
    (while (< x (safe-length header-list))
      (org-cycle)
      (insert (nth x header-list))
      (setq x (1+ x)))
    (while (< y 5)
      (org-cycle)
      (insert (concat (number-to-string (1+ y)) " " (nth (mod y 7) week-list)))
      (org-cycle)
      (org-cycle)
      (setq y (1+ y)))
    ))

(setq current-day (substring (current-time-string) 0 3))
(setq current-month (substring (current-time-string) 4 7))
(setq current-date (substring (current-time-string) 9 10))
(setq current-time (substring (current-time-string) 11 19))
(setq current-year (substring (current-time-string) 20 24))

Mon Apr  1 11:22:30 2019

(defun is-leap-year (&optional year)
  "judge if the year is a leap year"
  (let ((result nil))
      (if (stringp year)
       (setq year (string-to-number year))
     year)
      (if (or (and (= 0 (% year 4)) (not (= 0 (% year 100)))) (= 0 (% year 400)))
       (setq result "yes")
       (setq result "no"))
      result))

(progn
  (setq current-year (substring (current-time-string) 20 24))
  (is-leap-year current-year))


(save-current-buffer
  (set-buffer "*scratch*")
  (goto-char (point-min))
  (set-buffer "*Messages*"))

(save-excursion
  (set-buffer "*scratch*")
  (goto-char (point-min))
  (set-buffer "*Messages*"))


(defun mark-whole-sexp ()
  (interactive)
  (let ((bound (bounds-of-thing-at-point 'sexp)))
    (if bound
        (progn
          (goto-char (car bound))
          (set-mark (point))
          (goto-char (cdr bound)))
      (message "No sexp found at point!"))))


(setq org-capture-templates
      '(("t" "Todo" entry (file+function "~/org/gtd.org" )
	 "* ● %?\n  %i\n"
	 :empty-lines 1)))

(defun org-capture-todo-insert ()
  (setq current-day (format-time-string "%b %d %a"))
  (setq current-monthly (format-time-string "%B"))
  )
