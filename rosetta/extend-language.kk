fun if4(cond1: bool, cond2: bool, both: () -> e a, first: () -> e a, second: () -> e a, none: () -> e a): e a 
  if (cond1 && cond2) then both()
  elif cond1 then first()
  elif cond2 then second()
  else none()

fun test(first, second)
  if4(first, second) { // Both
    println("Both conditions are true")
  } { // First
    println("Only the first condition is true")
  } { // Second
    println("Only the second condition is true")
  } { // None
    println("No conditions are true")
  }

  match (first, second)
    (True, True) -> println("Both conditions are true")
    (True, False) -> println("Only the first condition is true")
    (False, True) -> println("Only the second condition is true")
    (False, False) -> println("No conditions are true")
  

fun main()
  test(True, True)    // Both
  test(True, False)   // First
  test(False, True)   // Second
  test(False, False)  // None