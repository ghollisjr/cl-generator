# cl-generator
generator in common lisp

## about
supports common lisp multiple values

## provides

### cl-generator
* `yield`
* `lambda*`
* `defun*`
* `defmacro*`
* `yield*`
* `iter-value`, `iter-next`

### cl-generator-util
* `for`

## usage
``` lisp
(require 'cl-generator)
(use-package 'cl-generator)
(use-package 'cl-generator-util)
```

### yield
``` lisp
(defun* test (x)
  (print (yield x)))

(funcall (test 0))
```

``` lisp
(defun* matryoshka (x)
  (yield (yield (yield x))))
```
the same thing as in javascript
``` javascript
function* matryoshka(x) {
	return yield yield yield x;
}
```
### lambda*
``` lisp
(lambda* ()
  (let ((i 0))
    (loop while (< i 10)
       do (yield i)
         (incf i))))
```

### defun*
``` lisp
(defun* test ()
  (let ((i 0))
    (loop while (< i 10)
       do (yield i)
         (incf i))))

(test)
```

### defmacro*
``` lisp
(defmacro* test (f)
  `(let ((i 0))
     (loop while (< i 10)
        do (funcall ,f i)
          (incf i))))

(test (lambda (x) (yield x)))
```

### yield*
``` lisp
(defun* a ()
  (yield 1)
  (yield 2)
  (print "end"))

(defun* b ()
  (yield* '(7 8 9))
  (yield* (a)))

(defun* c ()
  (yield* (list (yield 1) (yield 2))))
```

``` lisp
(defun* a ()
  (yield 1)
  (yield 2)
  (values 3 4 5))

(defun* b ()
  (yield (yield* (a))))
```

### for
``` lisp
(defun* number-generator (x)
  (let ((i 0))
    (loop while (< i x)
       do (yield i)
         (incf i))))

(for (x (number-generator 10)) (print x))
```

### iter-value, iter-next
``` lisp
(defun* ten-generator ()
  (let ((i 0))
    (loop while (< i 10)
       do (yield i)
         (incf i))))
(defparameter x (funcall (ten-generator)))
(loop until (null (iter-next x))
   do (print (iter-value x))
     (setf x (funcall (iter-next x))))
```

## test

### require
``` lisp
(require 'cl-generator-test)
```
### run tests
``` lisp
(cl-generator-test:run)
```

## LICENSE
MIT
