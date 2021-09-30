(in-package :cl-user)
(defpackage pd3serve.web
  (:use #:cl
        #:caveman2
        #:pd3serve.config
        #:pd3serve.view
        #:pd3serve.db
        #:datafly
        #:sxql
	#:pd3
	#:cl-ppcre)
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

(defroute "/upload" ()
  (render #P"input.html"))

(defroute ("/ep" :method :POST) (&key |file|)
  (let ((fileName (second |file|)) (fileContent (flexi-streams:octets-to-string (slot-value (first |file|) 'flexi-streams::vector) :external-format :utf8)))
    
    (format t "~A~%~A~%" fileName fileContent)
    (let ((filePath (concatenate 'string "~/common-lisp/pd3serve/ep-list/" fileName)))
      (with-open-file (out filePath :direction :output :if-does-not-exist :create :if-exists :supersede :external-format :utf8)
	(write-sequence fileContent out))
      ))
  (format nil "~A~%" "Uploaded!")
  )

(defroute ("/ep" :method :GET) ()
  (let ((eps-string (string "")) (path-to-eps (directory #P"~/common-lisp/pd3serve/ep-list/*.xml*")))
    (dolist (path-to-ep path-to-eps)
      (setq path-to-ep (cl-ppcre:regex-replace ".xml" (file-namestring path-to-ep) ""))
      (setq eps-string (concatenate 'string  eps-string path-to-ep (format nil "~%")))
      )
    (format nil "~A" eps-string)
    )
  )

(defroute ("/ep/:name/actions" :method :GET)(&key name)
  (setf (getf (response-headers *response*) :content-type) "application/json")
  (pd3:read-drawio-file (format nil "~A~A~A" "~/common-lisp/pd3serve/ep-list/" name  ".xml"))
  (show-all-objects pd3::*actions*))
(defroute ("/ep/:name/flows" :method :GET)(&key name)
  (setf (getf (response-headers *response*) :content-type) "application/json")
  (pd3:read-drawio-file (format nil "~A~A~A" "~/common-lisp/pd3serve/ep-list/" name  ".xml"))
  (show-all-objects pd3::*flows*))
(defroute ("/ep/:name/containers" :method :GET)(&key name)
  (setf (getf (response-headers *response*) :content-type) "application/json")
  (pd3:read-drawio-file (format nil "~A~A~A" "~/common-lisp/pd3serve/ep-list/" name  ".xml"))
  (show-all-objects pd3::*containers*))

(defroute ("/ep/:name" :method :GET)(&key name)
  (setf (getf (response-headers *response*) :content-type) "application/json")
  (pd3:read-drawio-file (format nil "~A~A~A" "~/common-lisp/pd3serve/ep-list/" name  ".xml"))
  (let ((objectsJson (string "[")) (len-action (length pd3::*actions*)) (len-flow (length pd3::*flows*)) (len-container (length pd3::*containers*)))
	   (dotimes (i len-action)
	     (setq objectsJson (concatenate 'string objectsJson (encode-json (symbol-value (nth i pd3::*actions*))) ",")))
	   (dotimes (i len-flow)
	     (setq objectsJson (concatenate 'string objectsJson (encode-json (symbol-value (nth i pd3::*flows*))) ",")))
	   (dotimes (i len-container)
	     (setq objectsJson (concatenate 'string objectsJson (encode-json (symbol-value (nth i pd3::*containers*)))))
	     (unless (= i (- len-container 1))
	       (setq objectsJson (concatenate 'string objectsJson ","))))
	   (setq objectsJson (concatenate 'string objectsJson "]"))
	   (format nil "~A~%" objectsJson)))

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
	))
(defroute ("/show/all" :method :GET)()
  (setf (getf (response-headers *response*) :content-type) "application/json")
  (let ((objectsJson (string "[")) (len-action (length pd3::*actions*)) (len-flow (length pd3::*flows*)) (len-container (length pd3::*containers*)))
	   (dotimes (i len-action)
	     (setq objectsJson (concatenate 'string objectsJson (encode-json (symbol-value (nth i pd3::*actions*))) ",")))
	   (dotimes (i len-flow)
	     (setq objectsJson (concatenate 'string objectsJson (encode-json (symbol-value (nth i pd3::*flows*))) ",")))
	   (dotimes (i len-container)
	     (setq objectsJson (concatenate 'string objectsJson (encode-json (symbol-value (nth i pd3::*containers*)))))
	     (unless (= i (- len-container 1))
	       (setq objectsJson (concatenate 'string objectsJson ","))))
	   (setq objectsJson (concatenate 'string objectsJson "]"))
	   (format nil "~A~%" objectsJson)))


(defun show-all-objects (objects)
   (let ((objectsJson (string "[")) (len (length objects)))
	   (dotimes (i len)
	     (setq objectsJson (concatenate 'string objectsJson (encode-json (symbol-value (nth i objects)))))
	     (unless (= i (- len 1))
	       (setq objectsJson (concatenate 'string objectsJson ","))))
	   (setq objectsJson (concatenate 'string objectsJson "]"))
	   (format nil "~A~%" objectsJson)))
(defun show-a-object (object)
  (format nil "~A~%" (encode-json (symbol-value (first object)))))

(defun replace-all (string part replacement &key (test #'char=))
"Returns a new string in which all the occurences of the part 
is replaced with replacement."
    (with-output-to-string (out)
      (loop with part-length = (length part)
            for old-pos = 0 then (+ pos part-length)
            for pos = (search part string
                              :start2 old-pos
                              :test test)
            do (write-string string out
                             :start old-pos
                             :end (or pos (length string)))
            when pos do (write-string replacement out)
            while pos))) 
;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*)
  )


