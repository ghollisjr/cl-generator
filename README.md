# cl-generator

## provides

### cl-generator
* `lambda*`
* `defun*`
* `defmacro*`
* `yield`

### cl-generator-util
* `for`

## usage
``` lisp
(require 'cl-generator)
(use-package 'cl-generator)
(use-package 'cl-generator-util)
(cl-generator:header)
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

### for
``` lisp
(defun* number-generator (x)
  (let ((i 0))
    (loop while (< i x)
       do (yield i)
         (incf i))))

(for (x (number-generator 10)) (print x))
```

## LICENSE
MIT
