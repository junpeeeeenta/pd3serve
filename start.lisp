(load #P"~/common-lisp/PD3/pd3.asd")
(asdf:load-system :pd3)
(ql:quickload :caveman2)
(ql:quickload :pd3serve)
(pd3serve:start :port 8080 :debug t)
(pd3:read-drawio-file "~/common-lisp/PD3/expertB.xml")
