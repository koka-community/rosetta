type tree
  Node(left: tree, right: tree)
  Leaf(value: int)

fun next(t : list<tree>)
  match t
    [] -> Nothing
    Cons(h, t) -> 
      match h
        Leaf(x) -> Just((x, t))
        Node(a, b) -> next(Cons(a,Cons(b,t)))

fun same-fringe(t1: tree, t2: tree)
  fun recur(t1': list<tree>, t2': list<tree>)
    match (next(t1'), next(t2'))
      (Nothing, Nothing) -> True
      (Nothing, _) -> False
      (_, Nothing) -> False
      (Just((a, b)), Just((c, d))) -> a == c && recur(b, d)
  recur([t1], [t2])

val u = Node(Leaf(1), Node(Leaf(2), Leaf(3)))
val v = Node(Node(Leaf(1), Leaf(2)), Leaf(3))
val w = Node(Node(Leaf(3), Leaf(2)), Leaf(1))

fun check(a, b)
  if same-fringe(a,b) then "same".println else "different".println
  if same-fringe-iterator(a,b) then "samei".println else "differenti".println

fun main()
  check(u, v)
  check(v, u)
  check(v, w)

// Effectful iterator
effect iter
  ctl yield(t: int): ()

fun iterate(t: tree)
  match t
    Node(l, r) -> 
      iterate(l)
      iterate(r)
    Leaf(i) ->
      yield(i)

// First class iterator
named effect iterator
  fun next-i(): maybe<int>

// Generic first class iterator adaptor (take an iterate function, and reify it into a pull-based model)
fun iterator(data: b, action: ev<iterator> -> <div|e> a, ?iterate: b -> iter ()): <div|e> a 
  var cont := Nothing
  var start := True
  var value := Nothing
  fun run(a)
    with handler 
      ctl yield(i)
        cont := Just(resume)
        value := Just(i)
      return(_)
        cont := Nothing
        value := Nothing
    a()
  with x <- named handler
    fun next-i()
      if start then
        start := False 
        run({iterate(data)})
        value
      else 
        match cont
          Nothing -> Nothing
          Just(resume) -> 
            resume(())
            value
  action(x)

// Use iterators to iterate over the trees
fun same-fringe-iterator(t1: tree, t2: tree)
  with i1 = t1.iterator
  with i2 = t2.iterator
  fun recur()
    match (i1.next-i, i2.next-i)
      (Nothing, Nothing) -> True
      (Nothing, _) -> False
      (_, Nothing) -> False
      (Just(int1), Just(int2)) -> int1 == int2 && recur()
  recur()





