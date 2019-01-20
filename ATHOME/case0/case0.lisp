(in-package :shop2-user)
(defproblem case0 atHome
(	
	(knowLocation table)	
	(knowLocation cupboard)	
	(knowLocation shelf)
	(close cupboard)
	(at table)
	(isTable table)
	(isCupboard cupboard)
	(has(cupboard shelf))
	) ((start table cupboard)))



(find-plans 'case0 :verbose :plans :which :FIRST)

