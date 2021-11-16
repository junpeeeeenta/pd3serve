(in-package :cl-user)
(defpackage pd3serve.web
  (:use #:cl
        #:caveman2
        #:pd3serve.config
        #:pd3serve.view
        #:pd3serve.db
        #:datafly
        #:sxql
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

(defroute ("/EPs/:EPName" :method :POST) (&key |file| EPName)
  (cond ((eq EPName nil) (setq EPName (second |file|)))
        ((string= EPName '":EPName") (setq EPName (cl-ppcre:regex-replace ".xml" (second |file|) ""))))
  (let
      ((fileName EPName) 
      (fileContent (flexi-streams:octets-to-string (slot-value (first |file|) 'flexi-streams::vector) :external-format :utf8))) 
    (format t "~A~%~A~%" fileName fileContent)
    (let ((filePath (concatenate 'string "~/common-lisp/pd3serve/ep-list/" fileName ".xml")))
      (with-open-file (out filePath :direction :output :if-does-not-exist :create :if-exists :supersede :external-format :utf8)
	(write-sequence fileContent out))
      ))
  (format nil "~A~%" "Uploaded!")
  )

(defroute ("/EPs" :method :GET) ()
  (let ((eps-string (string "[")) (path-to-eps (directory #P "~/common-lisp/pd3serve/ep-list/*.xml*")) (eps-list (list)))
    (let ((len (length path-to-eps)))
      (dotimes (i len)
	(let ((path-to-ep (nth i path-to-eps)))
	  (setq path-to-ep (cl-ppcre:regex-replace ".xml" (file-namestring path-to-ep) ""))
	  (setq eps-list (append eps-list (list path-to-ep)))
	(unless (= i (- len 1))
	 (setq eps-string (concatenate 'string  eps-string path-to-ep ",")))))
      (format nil "~A" (encode-json eps-list))
  )))

(defroute ("/EPs/:EPName" :method :DELETE) (&key EPName)
  (let ((filePath (concatenate 'string "~/common-lisp/pd3serve/ep-list/" EPName ".xml")))
    (let ((q (probe-file filePath)))
      (delete-file q)))
  (format nil "~A~%" "Deleted!"))

(defroute ("/EPs/:EPName/actions" :method :GET)(&key EPName)
  (setf (getf (response-headers *response*) :content-type) "application/json")
  (pd3:read-drawio-file (format nil "~A~A~A" "~/common-lisp/pd3serve/ep-list/" EPName  ".xml"))
  (show-all-objects pd3::*actions*))
(defroute ("/EPs/:EPName/arcs" :method :GET)(&key EPName)
  (setf (getf (response-headers *response*) :content-type) "application/json")
  (pd3:read-drawio-file (format nil "~A~A~A" "~/common-lisp/pd3serve/ep-list/" EPName  ".xml"))
  (show-all-objects pd3::*arcs*))
(defroute ("/EPs/:EPName/containers" :method :GET)(&key EPName)
  (setf (getf (response-headers *response*) :content-type) "application/json")
  (pd3:read-drawio-file (format nil "~A~A~A" "~/common-lisp/pd3serve/ep-list/" EPName  ".xml"))
  (show-all-objects pd3::*containers*))

(defroute ("/EPs/:EPName" :method :GET)(&key EPName)
  (setf (getf (response-headers *response*) :content-type) "application/json")
  (pd3:read-drawio-file (format nil "~A~A~A" "~/common-lisp/pd3serve/ep-list/" EPName  ".xml"))
  (let ((objectsJson (string "[")) (len-action (length pd3::*actions*)) (len-arc (length pd3::*arcs*)) (len-container (length pd3::*containers*)))
	   (dotimes (i len-action)
	     (setq objectsJson (concatenate 'string objectsJson (encode-json (symbol-value (nth i pd3::*actions*))) ",")))
	   (dotimes (i len-arc)
	     (setq objectsJson (concatenate 'string objectsJson (encode-json (symbol-value (nth i pd3::*arcs*))) ",")))
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

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*)
  )


