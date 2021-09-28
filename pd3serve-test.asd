(defsystem "pd3serve-test"
  :defsystem-depends-on ("prove-asdf")
  :author "jumpei goto"
  :license ""
  :depends-on ("pd3serve"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "pd3serve"))))
  :description "Test system for pd3serve"
  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
