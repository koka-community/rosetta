effect exit<a>
  final ctl exit(a: a): b

fun find-first(): string
  with handler
    final ctl exit(a: string) a
    return(x) "not found"
  for(0, 10) fn(i)
    if i == 9 then exit("Found 9")

effect loop
  final ctl lbreak(): ()
  final ctl lcontinue(): ()

fun loop(check: () -> <div|e> bool, body: () -> <div,loop|e> ()): <div|e> ()
  if check() then
    val next = handle(body)
      final ctl lbreak() (fn() ())
      final ctl lcontinue() (fn() loop(check, body)) // Continue the loop
      return(x) (fn() loop(check, body))
    next()
  else
    ()

fun main()
  find-first().println
  var i := 0
  loop { i < 10 } {
    i := i + 1
    // We can early return from the inner lambda (continue) 
    if i == 4 then return () 
    // Adding local breaks could be done by returning `True` / `False`:
    //   This would require us to always return `True` if we want to continue
    // The following are non-local:
    //   They can be used in nested calls to exit from the innermost loop on the stack.
    if i == 5 then lcontinue() 
    if i == 8 then lbreak()
    println(i)
  }
  println(i)