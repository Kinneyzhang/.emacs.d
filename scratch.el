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

;; (defun create-monthly-log-table ()
;;   (interactive)
;;   (let (())
;;     (setq header '("Date" "Event" "Monthly Task"))
;;     (setq week '("Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun"))
;;     (while header
;;       (org-cycle)
;;       (insert header))))
