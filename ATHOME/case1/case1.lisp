
(in-package :shop2-user)
(defproblem case1 ATHOME
(	(on(obj table))
	(knowLocation obj)
	(knowLocation table)	
	(knowLocation cupboard)	
	(knowLocation shelf)
	(close cupboard)
	(at table)
	(isTable table)
	(isCupboard cupboard)
	(has(cupboard shelf))
	(objectShouldBeMoved obj)
	) ((start table cupboard)))


;(find-plans 'case1 :verbose :plans :which :all :optimize-cost t)
(find-plans 'case1 :verbose :plans :which :FIRST)
