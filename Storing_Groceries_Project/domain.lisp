(in-package :shop2-user)

(
defdomain atHome
(
  (:operator
 	(!takeOff ?a ?t)
	((knowLocation ?a) (on(?a ?t)) (at ?t))
	((on(?a ?t))) 
	((have ?a)) 
  1.0)

 (:operator
 	(!walkFromTo ?a ?b)
	((at ?a) (knowLocation ?b))
	((at ?a)) 
	((at ?b)) 
  1.0)

 (:operator
 	(!findLocation ?a)
	((not(knowLocation ?a)))
	() 
	((knowLocation ?a)) 
  1.0)

  (:operator 
	(!open ?a) 
	((at ?a) (close ?a)) 
	((close ?a)) 
	((open ?a))
  1.0)

  (:operator 
	(!putOn ?a ?s)	
	((have ?a))
	((have ?a))
 	((on(?s ?a)))
  1.0)

  (:operator 
	(!checkNoObjectToBeMovedLeft ?t)	
	((at ?t)(nothingTakable ?object ?t))
	()
 	((isEmpty(?t)))
  1.0)

 (:operator 
	(!checkStillObjectToBeMovedLeft ?t)	
	((at ?t)(takable ?object ?t))
	()
 	((notEmpty(?t)))
  1.0)

 (:operator 
	(!checkCurrentLocation ?t)	
	((at ?t))
	()
 	((knowCurrentLocation))
  1.0)

 (:operator 
	(!checkIfCategoryFit ?object ?shelf)	
	((fit-category ?object ?shelf))
	()
 	()
  1.0)


 (:operator 
	(!foundAllShelfs ?cupboard)	
	(not((missing-shelf ?cupboard ?shelf)))
	()
 	()
  1.0)

 (:operator 
	(!end)	
	()
	()
 	()
  1.0)


;---------------------------------------------------------------------------------------
; methods

;---------------------------------------------------------------------------------------
; move objects


; move (not last) object

  (:method 
	(takeObjectFromTableToShelf ?object ?table ?cupboard ?startpoint)
    	((takable ?object ?table)(at ?startpoint))
    	(:ordered
		(walkToLocation ?startpoint ?table)	
		(takeObject ?object ?table)
		(!checkStillObjectToBeMovedLeft ?table)	
		(walkToLocation ?table ?cupboard)
 		(putInCupboard  ?object ?cupboard)
	)
  )

; move last object

  (:method 
	(takeObjectFromTableToShelf ?object ?table ?cupboard ?startpoint)
    	((takable ?object ?table)(at ?startpoint))
    	(:ordered
		(walkToLocation ?startpoint ?table) 		
		(takeObject ?object ?table)
		(!checkNoObjectToBeMovedLeft ?table)
		(walkToLocation ?table ?cupboard)
 		(putInCupboard  ?object ?cupboard)
	)
  )


;---------------------------------------------------------------------------------------
; recusive call to move all objects

  (:method 
	(start ?table ?cupboard)
    	()
    	(
		(!checkCurrentLocation ?at)
		(preserveRoom ?table ?cupboard)
		(openCupboard ?cupboard ?at ?table)
		(movingAllObjectsFromTo ?table ?cupboard)		
	)
  )

; recursive method call to move all objects

  (:method 
	(movingAllObjectsFromTo ?from ?to)
    	((at ?currentLocation) (on(?obj ?from)))
    	(:ordered
		(takeObjectFromTableToShelf ?obj ?from ?to ?currentLocation)
		(movingAllObjectsFromTo ?from ?to)			
	)
  )

; end of recursive call

(:method 
        (movingAllObjectsFromTo ?from ?to)
            ((isEmpty(?from)))
            (
		(!end)
	    )
)

; this method is called is there is no object on the table in the beginning

  (:method 
	(movingAllObjectsFromTo ?from ?to)
    	((at ?currentLocation))
    	(:ordered
		(walkToLocation ?currentLocation ?from) 	
		(!checkNoObjectToBeMovedLeft ?table)
		(!end)			
	)
  ) 

;---------------------------------------------------------------------------------------

; preserveRoom in the beginning

  (:method 
	(preserveRoom ?table ?cupboard)
    	((isTable ?table)(isCupboard ?cupboard))
    	(:ordered 		
		(!findLocation ?table)
 		(!findLocation ?cupboard)
	)
  )

  (:method 
	(preserveRoom  ?table ?cupboard)
    	((isTable ?table)(isCupboard ?cupboard)(knowLocation table)(knowLocation cupboard))
    	(		
	)
  )

  (:method 
	(preserveRoom  ?table ?cupboard)
    	((isTable ?table)(isCupboard ?cupboard)(knowLocation cupboard))
    	(:ordered 		
		(!findLocation ?table)
	)
  )

  (:method 
	(preserveRoom  ?table ?cupboard)
    	((isTable ?table)(isCupboard ?cupboard)(knowLocation table))
    	(:ordered 		
 		(!findLocation ?cupboard)
	)
  )

  (:method 
	(openCupboard ?cupboard ?at ?table)
    	((close ?cupboard))
    	(:ordered 
		(walkToLocation ?at ?cupboard)	
 		(!open ?cupboard)
		(findAllShelfs ?cupboard)
		(walkToLocation ?cupboard ?table)
	)
  )

  (:method 
	(openCupboard ?cupboard ?at ?table)
    	((open ?cupboard))
    	(
		(findAllShelfs ?cupboard)
		(walkToLocation ?at ?table)	
	)
  )

  (:method 
	(findAllShelfs ?cupboard)
    	((has(?cupboard ?shelf)))
    	(
		(!findLocation ?shelf)
		(findAllShelfs ?cupboard)	
	)
  )

  (:method 
	(findAllShelfs ?cupboard)
    	()
    	(
		(!foundAllShelfs ?cupboard)	
	)
  )

	

;---------------------------------------------------------------------------------------


; walking

  (:method 
	(walkToLocation ?l1 ?l2)
    	(at ?l2)
    	()
  )

  (:method 
	(walkToLocation ?l1 ?l2)
    	(knowLocation ?l2)
    	(		
 		(!walkFromTo ?l1 ?l2)
	)
  )



;---------------------------------------------------------------------------------------
; taking object


  (:method 
	(takeObject ?object ?table)
    	((knowLocation ?object))
    	(
 		(!takeOff ?object ?table)
	)
  )

  (:method 
	(takeObject ?object ?table)
    	((unknownLocation ?object))
    	(:ordered 		
		(!findLocation ?object)
 		(!takeOff ?object ?table)
	)
  )



;---------------------------------------------------------------------------------------
; put in cupboard

   (:method 
	(putInCupboard ?object ?cupboard)
    	((open ?cupboard)(at ?cupboard) (has(?cupboard ?shelf))(noCat ?object ?shelf))
    	(
 		(!putOn ?object ?shelf)
	)
  )


   (:method 
	(putInCupboard ?object ?cupboard)
    	((open ?cupboard)(at ?cupboard) (has(?cupboard ?shelf)))
    	(
		(!checkIfCategoryFit ?object ?shelf)
 		(!putOn ?object ?shelf)
	)
  )



;---------------------------------------------------------------------------------------
; axioms


(:- (fit-category ?x ?y) ((not((noCat ?x ?y)))(category ?x ?d)(category ?y ?d)  (not(=(?d noCategory)))))
(:- (noCat ?x ?y) ((not(category ?x ?d))(not(category ?y ?c))))
(:- (missing-shelf ?cupboard ?shelf) ((has(?cupboard ?shelf)) (not(knowLocation ?y))))
(:- (unknownLocation ?object) ((not(knowLocation ?object))))
(:- (takable ?object ?table)((on(?object ?table))(isTable ?table)(category ?object ?c)(categoryShouldBeMoved ?c)))
(:- (takable ?object ?table)((on(?object ?table))(isTable ?table)(objectShouldBeMoved ?object)))
(:- (nothingTakable ?object ?table)((on(?object ?table))(category ?object ?c) (not(categoryShouldBeMoved ?c)) (not(objectShouldBeMoved ?object))))
(:- (nothingTakable ?object ?table)( not(on(?object ?table)))  )

)
)

