(in-package :cl-user)
(defpackage pd3serve2.web
  (:use #:cl
        #:caveman2
        #:pd3serve2.config
        #:pd3serve2.view
        #:pd3serve2.db
        #:datafly
        #:sxql
	#:pd3)
  (:export :*web*))
(in-package :pd3serve2.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;;
;; Routing rules

(defroute "/" ()
  (render #P"index.html"))

(defroute "/input" ()
  (render #P"input.html"))

(defroute ("/submitted" :method :GET) (&key |file|)
  (format nil "~A" |file|))

(defroute ("/getpd3" :method :GET) (&key (|filename|))
  (format nil "~A" |filename|)
  (format nil "~A" (pd3:read-drawio-file "~/common-lisp/PD3/expertB.xml"))
  )

(defroute ("/read-drawio-file" :method :GET) (&key (|filename| "expertB.xml"))
  (pd3:read-drawio-file (format nil "~A~A" "~/common-lisp/PD3/" |filename|))
  (format nil "~A~%" "Done!")
  )

(defroute ("/show/:number/:class" :method :GET) (&key number class)
  (when (and (string= number "all") (string= class "actions"))
    ;; (with-input-from-string (*standard-input* (pd3:show :all :actions))
    ;;   (format t "~A" (read))))
    (let ((all-actions  "a"))
      (print all-actions)))
  ;(format nil "~A ~A" number class)
  ;(describe 'print)
  ;(print "a")
  ;(format nil "~A~%" "test")
					
  )

(defroute ("/test/:number/:class" :method :GET) (&key |number| |class|)
  (format t "~A ~A" |number| |class|) 
  (when (eq |number| 'all)
      (pd3:show :all :actions))
 )

;(defroute "/welcome" (&key (|name| "Guest"))
 ; (format nil "Welcome, ~A~%" |name|))

(defroute "/welcome/:name/:san" (&key name san)
  (format nil "Welcome, ~A-~A~%" name san))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
