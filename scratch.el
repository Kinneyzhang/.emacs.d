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
    (message "半径为 %.2f 的圆的面积为 %.2f " radix area)))e
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
