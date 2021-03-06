(defsystem "pd3serve"
  :version "0.1.0"
  :author "jumpei goto"
  :license ""
  :depends-on ("clack"
               "lack"
               "pd3serve-errors"
               "caveman2"
               "envy"
               "cl-ppcre"
               "uiop"

               ;; for @route annotation
               "cl-syntax-annot"

               ;; HTML Template
               "djula"

               ;; for DB
               "datafly"
               "sxql"

	       ;; for PD3
	       "pd3"
	       "drawio"
	       "xmlreader"
	       "line-reader")
  :components ((:module "src"
                :components
                ((:file "main" :depends-on ("config" "view" "db"))
                 (:file "web" :depends-on ("view"))
                 (:file "view" :depends-on ("config"))
                 (:file "db" :depends-on ("config"))
                 (:file "config"))))
  :description ""
  :in-order-to ((test-op (test-op "pd3serve-test"))))
