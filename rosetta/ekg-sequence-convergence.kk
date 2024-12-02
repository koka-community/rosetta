/*----------------------------------------------------------------------------
   Copyright 2024, Koka-Community Authors

   Licensed under the MIT License ("The License"). You may not
   use this file except in compliance with the License. A copy of the License
   can be found in the LICENSE file at the root of this distribution.
----------------------------------------------------------------------------*/

// TODO: Move gcd and quicksort to stdlib
fun gcd( x : int, y : int ) {
  if (x>y) then gcd(x - y, y)
  elif (x < y) then gcd(x,y - x)
  else x
}

alias elem = int;

reference type pad
  Pad

reference type unit2
  Unit2(a : pad, b : pad)

type maybe2<a>
  Nothing2
  Just2(a : a, b : pad)

type sublist<a>
  SCons(a : a, cs : sublist<a>)
  STuple(a : a, b : a)

type partition<a>
  Sublist(c : sublist<a>, bdl : partition<a>)
  Singleton(c : a, bdl : partition<a>)
  End

fip fun quicksort(xs : list<elem>) : div list<elem>
  quicksort-go(xs, End)

fip fun quicksort-go(xs : list<elem>, b : partition<elem>) : div list<elem>
  match xs
    Cons(p, xx) ->
      val (lo, hi) = split-list(p, xx, Done, b, Unit2(Pad,Pad))
      quicksort-go(lo, hi)
    Nil -> quicksort-app(b)

fip fun quicksort-app(bdl : partition<elem>) : div list<elem>
  match bdl
    Singleton(p, b) -> Cons(p,quicksort-app(b))
    Sublist(xs, bdl') -> match xs
      SCons(p, xx) ->
        val (lo, hi) = split-sublist(p, xx, Done, bdl', Unit2(Pad,Pad), Unit2(Pad,Pad))
        quicksort-go(lo, hi)
      STuple(a, b) -> if a <= b then Cons(a, Cons(b, quicksort-app(bdl')))
                                else Cons(b, Cons(a, quicksort-app(bdl')))
    End -> Nil

type accum<a>
  MkLo(x : a, k : accum<a>)
  MkHi(x : a, k : accum<a>)
  Done

fip fun split-list(p : elem, xs : list<elem>, k : accum<elem>, b : partition<elem>, u : unit2)  : div (list<elem>, partition<elem>)
  match xs
    Cons(x, xx) -> if x < p then split-list(p, xx, MkLo(x, k), b, u)
                            else split-list(p, xx, MkHi(x, k), b, u)
    Nil ->
      val (lo, hi) = split-app1(k, Nil, Nothing2, b)
      (lo, Singleton(p, hi))

fip fun split-sublist(p : elem, xs : sublist<elem>, k : accum<elem>, b : partition<elem>, u : unit2, u1 : unit2) : <div> (list<elem>, partition<elem>)
  match xs
    SCons(x, xx) -> if x < p then split-sublist(p, xx, MkLo(x, k), b, u, u1)
                             else split-sublist(p, xx, MkHi(x, k), b, u, u1)
    STuple(x, y) -> split-list(p, Cons(x, Cons(y, Nil)), k, b, u)

fip fun split-app1(k : accum<elem>, lo : list<elem>, hi : maybe2<elem>, b : partition<elem>) : <div> (list<elem>, partition<elem>)
  match k
    MkLo(x, k) -> split-app1(k, Cons(x, lo), hi, b)
    MkHi(x, k) -> match hi
      Nothing2    -> split-app1(k, lo, Just2(x, Pad), b)
      Just2(y, _) -> split-app2(k, lo, STuple(y,x), b, Unit2(Pad,Pad))
    Done -> match hi
      Just2(x, _) -> (lo, Singleton(x, b))
      Nothing2    -> (lo, b)

fip fun split-app2(k : accum<elem>, lo : list<elem>, hi : sublist<elem>, b : partition<elem>, u : unit2) : (list<elem>, partition<elem>)
  match k
    MkLo(x, k) -> split-app2(k, Cons(x,lo), hi, b, u)
    MkHi(x, k) -> split-app2(k, lo, SCons(x,hi), b, u)
    Done       -> (lo, Sublist(hi, b))

fun ekg(limit: int, seen: ctx<list<int>>, last: int, iter: int = 1): div list<int>
  if iter >= limit then seen ++. Nil
  else 
    var v := 2
    val curSeq = (seen ++. Nil)
    var res := Nothing
    while {res.is-nothing}
      if !curSeq.any(fn(v1) v1 == v) && gcd(v, last) != 1 then
        res := Just(v)
      else
        v := v + 1
    ekg(limit, seen ++ ctx Cons(v, _), last=v, iter=iter+1)

fun doEkg(n: int, limit: int): <div> list<int>
  Cons(1, ekg(limit, ctx Cons(n, _), n, 1))

fun (==)( ids1 : list<int>, ids2 : list<int> ) : bool
  match ids1
    Nil -> match ids2
      Nil -> True
      Cons(_,_) -> False
    Cons(i1,is1) -> match(ids2)
      Cons(i2,is2) -> (i1 == i2 && is1 == is2)
      Nil -> False

fun converged(i: int, l1: list<int>, l2: list<int>, l1acc : list<int>, l2acc : list<int>): pure maybe<int>
  match (l1, l2)
    (Cons(x1, x1s), Cons(y1, y1s)) ->
      if x1 == y1 && l1acc == l2acc then
        Just(i)
      else
        converged(i + 1, x1s, y1s, Cons(x1, l1acc).quicksort, Cons(y1, l2acc).quicksort)
    (_, _) -> Nothing

fun main()
  [2, 5, 7, 9, 10].foreach fn(n)
    val res = doEkg(n, 9)
    ("EKG(" ++ n.show ++ "): " ++ res.show).println
  val ekg5 = doEkg(5, 99)
  val ekg7 = doEkg(7, 99)
  var found := False
  match converged(2, ekg5.tail, ekg7.tail, Nil, Nil)
    Just(i) -> ("EKG(5) and EKG(7) Converged at index " ++ i.show ++ ".").println
    Nothing -> ("No convergence found in the first 100 terms.").println