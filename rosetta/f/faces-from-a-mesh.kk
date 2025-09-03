/*----------------------------------------------------------------------------
   Copyright 2024, Koka-Community Authors

   Licensed under the MIT License ("The License"). You may not
   use this file except in compliance with the License. A copy of the License
   can be found in the LICENSE file at the root of this distribution.
----------------------------------------------------------------------------*/

alias perimeter = list<int>
struct face 
  side: char
  peri: perimeter
alias edge = (int, int)

fun isSame(p1: perimeter, p2: perimeter, noSwitch: list<int> = []): div bool
  match (p1, p2)
    ([], []) -> True
    (Cons(x1, xs1), Cons(x2, xs2)) | x1 == x2 -> isSame(xs1, xs2)
    _ -> 
      match p2
        Nil -> False
        Cons(x2, xs2) -> 
          if noSwitch.any(fn(x') x' == x2) then False else p1.isSame(xs2 ++ [x2], Cons(x2, noSwitch))

fun show(f: face)
  val Face(c, p) = f
  c.show ++ " " ++ p.show

fun findRemove(l: list<a>, acc: ctx<list<a>>, pred: (a) -> bool): maybe<(a, list<a>)>
  match l
    [] -> Nothing
    Cons(x, xs) -> match pred(x)
      True -> Just((x, acc ++. xs))
      False -> findRemove(xs, acc ++ ctx Cons(x, hole), pred)

fun toPerimeter(search: int, edges: list<edge>, acc: ctx<perimeter>): <div,exn> perimeter
  match edges
    [] -> acc ++. Cons(search, Nil) // Assume the search matches the first edge's missing
    _ -> match edges.findRemove(ctx hole, fn((a, b)) a == search || b == search)
      Just(((a, b), xs')) -> if search == a then 
          toPerimeter(b, xs', acc ++ ctx Cons(a, hole))
        else 
          toPerimeter(a, xs', acc ++ ctx Cons(b, hole))
      Nothing -> throw("Cannot find the next edge for " ++ search.show ++ " current perimeter is " ++ (acc ++. Nil).show ++ " and the rest of the edges are: " ++ edges.show-list(fn(s) s.show-tuple(show, show)))

fun main()
  val fp = [(('P', [8, 1, 3]), ('R', [1, 3, 8])), 
            (('U', [18, 8, 14, 10, 12, 17, 19]), ('V', [8, 14, 10, 12, 17, 19, 18]))]
  fp.foreach() fn((f1, f2))
    val same = f1.snd.isSame(f2.snd)
    print(f1.show ++ (if same then " is " else " is not ") ++ "the same as " ++ f2.show ++ "\n")
  val fe = [('E', [(1, 11), (7, 11), (1, 7)]),
              ('F', [(11, 23), (1, 17), (17, 23), (1, 11)]),
              ('G', [(8, 14), (17, 19), (10, 12), (10, 14), (12, 17), (8, 18), (18, 19)]),
              ('H', [(1, 3), (9, 11), (3, 11), (1, 11)])]
  fe.foreach() fn((f, edges))
    match edges
      [] -> ()
      Cons((initX, _), edges') ->
        val p = toPerimeter(initX, edges', ctx hole)
        print(f.show ++ " perimeter is " ++ p.show ++ "\n")