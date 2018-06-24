(in-package :cl-generator)

(defstruct iter
  (cur nil :type function)
  (next nil :type (or null function)))

(defstruct pass
  (cont nil :type (or null function))
  (results nil :type list))

(defmethod iter-id ((end null))
  (make-iter :cur (lambda () (iter-id end))))

(defmethod iter-id ((cont function))
  (let ((iter (make-iter :cur (lambda () (iter-id cont)))))
    (setf (iter-next iter) (gen-next iter cont))
    iter))

(defmethod pass-next ((pass null)))

(defmethod pass-next ((pass pass))
  (pass-cont pass))

(defmethod gen-next ((iter iter) (cont function))
  (lambda ()
    (let* ((res (funcall cont))
           (next (gen-next iter (pass-next res))))
      (setf (iter-next iter) next)
      (setf (iter-cur iter) (lambda () (iter-id (pass-next res))))
      (values-list (if (null next) nil (pass-results res))))))

(defmethod gen-next ((iter iter) (pass pass))
  (gen-next iter (pass-cont pass)))

(defmethod gen-next ((iter iter) (end null)))

(defmacro gen-pass (expr cont)
  (let ((list (gensym)))
    `(let ((,list (multiple-value-list ,expr)))
       (make-pass :cont ,cont :results ,list))))

(defmacro isolate-cont (&body body)
  `(without-call/cc (iter-id (lambda () (progn ,@body)))))

(defmacro yield (&optional expr)
  (declare (ignore expr))
  (error "yield is not defined"))

(defmacro yield* (expr)
  (declare (ignore expr))
  (error "yield* is not defined"))

(defmacro local-macros (&body body)
  (let ((k1 (gensym))
        (k2 (gensym))
        (x (gensym))
        (cont (gensym "cont")))
    `(macrolet ((yield (&optional expr)
                  (let ((,k1 (gensym)))
                    `(call/cc (with-call/cc (lambda (,,k1) (gen-pass ,expr ,,k1))))))
                )
       ,@body)))

(defmacro enable-yield (&body body)
  `(with-call/cc (local-macros ,@body) nil))

(defmacro lambda* (args &body body)
  `(lambda ,args (isolate-cont (enable-yield () ,@body))))

(defmacro defun* (name args &body body)
  `(defun ,name ,args (isolate-cont (enable-yield () ,@body))))

(defmacro defmacro* (name args &body body)
  `(defmacro ,name ,args `(isolate-cont (enable-yield () ,,@body))))
