struct item
  name: string 
  weight: int
  value: int

// Automatically generated.
// Equality comparison of the `item` type.
pub fun item/(==)(this : item, other : item) : e bool
  match (this, other)
    (Item(name, weight, value), Item(name', weight', value')) -> name == name' && weight == weight' && value == value'

// Automatically generated.
// Shows a string representation of the `item` type.
pub fun item/show(this : item) : e string
  match this
    Item(name, weight, value) -> "Item(name: " ++ name.show ++ ", weight: " ++ weight.show ++ ", value: " ++ value.show ++ ")"

val items = [
  Item("map", 9, 150), 
  Item("compass", 13, 35),
  Item("water", 153, 200),
  Item("sandwich", 50, 160),
  Item("glucose", 15, 60),
  Item("tin", 68, 45),
  Item("banana", 27, 60),
  Item("apple", 39, 40),
  Item("cheese", 23, 30),
  Item("beer", 52, 10),
  Item("suntan cream", 11, 70),
  Item("camera", 32, 30),
  Item("T-shirt", 24, 15),
  Item("trousers", 48, 10),
  Item("umbrella", 73, 40),
  Item("waterproof trousers", 42, 70),
  Item("waterproof overclothes", 43, 75),
  Item("note-case", 22, 80),
  Item("sunglasses", 7, 20),
  Item("towel", 18, 12),
  Item("socks", 4, 50),
  Item("book", 30, 10)
].vector

effect dyn
  fun memoed(item-idx: int, max-weight: int): bool
  ctl dep(item-idx: int, max-weight: int): result
  fun set-memoed(item-idx: int, max-weight: int, v: result): result

effect choose
  ctl choose(): bool

alias result = (int, int, list<item>)

fun memo(item-idx: int, max-weight: int, needs-choice: bool, action: (bool) -> <pure,dyn> result): <dyn,pure> result
  if memoed(item-idx, max-weight) then
    dep(item-idx, max-weight)
  else 
    if needs-choice then 
      with handler
        ctl choose()
          val r1 = resume(True)
          val r2 = resume(False)
          val v1 : int = r1.tuple3/fst 
          set-memoed(item-idx, max-weight, if v1 > r2.fst then r1 else r2)
      action(choose())
    else
      val res = action(False)
      set-memoed(item-idx, max-weight, res)
      res

fun dyn-prog(item-idx: int, max-weight: int): <dyn,pure> result
  if item-idx == -1 || max-weight == 0 then (0, 0, [])
  else 
    // trace(item-idx.show ++ " " ++ max-weight.show)
    val i = items[item-idx]
    val w = i.weight
    val needs-choice = w <= max-weight
    with choice <- memo(item-idx, max-weight, needs-choice)
    if choice then
      val v = i.value
      val (v', w', items') = dyn-prog(item-idx - 1, max-weight - w)
      (v' + v, w' + w, Cons(i, items'))
    else 
      dyn-prog(item-idx - 1, max-weight)

type depend<v,e>
  NotVisited
  Pending(deps : list<((int, int, list<v>)) -> e ()>)
  Done(result: (int, int, list<v>))

fun knapsack(items: vector<item>, total: int)
  val table = vector-init(items.length, fn(_) vector-init(total + 1, fn(_) ref(NotVisited)))
  with return(x)
    match !table[items.length - 1][total]
      Done((v, w, i)) -> (v, w, i.reverse)
  with handler
    fun memoed(i, w) 
      match !table[i][w]
        NotVisited -> 
          table[i][w].set(Pending([]))
          False
        _ -> True
    ctl dep(i, w)
      match !table[i][w]
        Pending(l) -> 
          table[i][w].set(Pending(Cons(resume, l)))
        Done(result) -> resume(result)
    fun set-memoed(i, w, v)
      match !table[i][w]
        Pending(deps) -> 
          table[i][w].set(Done(v))
          deps.foreach(fn(r) {r(v); ()})
      v
    return(_) ()
  dyn-prog(items.length - 1, total)

fun main()
  knapsack(items, 400)
