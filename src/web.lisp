(in-package :cl-user)
(defpackage pd3serve.web
  (:use #:cl
        #:caveman2
        #:pd3serve.config
        #:pd3serve.view
        #:pd3serve.db
        #:datafly
        #:sxql
	#:pd3)
  (:export :*web*))
(in-package :pd3serve.web)

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

(defroute ("/load" :method :GET) (&key (|filename| "expertB.xml"))
  (pd3:read-drawio-file (format nil "~A~A" "~/common-lisp/PD3/" |filename|))
  (format nil "~A~%" "COMPLETE!")
  )

(defroute ("/show/:quantity/:object" :method :GET) (&key quantity object)
  (setf (getf (response-headers *response*) :content-type) "application/json")
  (cond ((and (string= quantity "all") (string= object "actions"))
	 (show-all-objects pd3::*actions*))
	((and (string= quantity "all") (string= object "flows"))
	 (show-all-objects pd3::*flows*))
	((and (string= quantity "all") (string= object "containers"))
	 (show-all-objects pd3::*containers*))
  	((and (string= quantity "a") (string= object "action"))
  	 (show-a-object pd3::*actions*))
	((and (string= quantity "a") (string= object "flow"))
  	 (show-a-object pd3::*flows*))
	((and (string= quantity "a") (string= object "container"))
  	 (show-a-object pd3::*containers*))
	)
  )
(defroute ("/show/all" :method :GET)()
  (setf (getf (response-headers *response*) :content-type) "application/json")
  (let ((objects-json (string "[")) (len-action (length pd3::*actions*)) (len-flow (length pd3::*flows*)) (len-container (length pd3::*containers*)))
	   (dotimes (i len-action)
	     (setq objects-json (concatenate 'string objects-json (encode-json (symbol-value (nth i pd3::*actions*))) ",")))
	   (dotimes (i len-flow)
	     (setq objects-json (concatenate 'string objects-json (encode-json (symbol-value (nth i pd3::*flows*))) ",")))
	   (dotimes (i len-container)
	     (setq objects-json (concatenate 'string objects-json (encode-json (symbol-value (nth i pd3::*containers*)))))
	     (unless (= i (- len-container 1))
	       (setq objects-json (concatenate 'string objects-json ","))))
	   (setq objects-json (concatenate 'string objects-json "]"))
	   (format nil "~A~%" objects-json)))


(defun show-all-objects (objects)
   (let ((objects-json (string "[")) (len (length objects)))
	   (dotimes (i len)
	     (setq objects-json (concatenate 'string objects-json (encode-json (symbol-value (nth i objects)))))
	     (unless (= i (- len 1))
	       (setq objects-json (concatenate 'string objects-json ","))))
	   (setq objects-json (concatenate 'string objects-json "]"))
	   (format nil "~A~%" objects-json)))
(defun show-a-object (object)
  (format nil "~A~%" (encode-json (symbol-value (first object)))))
;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*)
  )
