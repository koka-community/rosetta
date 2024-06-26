/*----------------------------------------------------------------------------
   Copyright 2024, Koka-Community Authors

   Licensed under the MIT License ("The License"). You may not
   use this file except in compliance with the License. A copy of the License
   can be found in the LICENSE file at the root of this distribution.
----------------------------------------------------------------------------*/

import std/core/undiv

type btdigit
  Pos
  Zero
  Neg

alias btern = list<btdigit>

fun to_string(n: btern): string
  join(
    n.reverse.map fn(d)
      match d
        Pos -> "+"
        Zero -> "0"
        Neg -> "-"
  )

fun from_string(s: string): exn btern
  var sl := Nil
  s.foreach fn(c)
    match c
      '+' -> sl := Cons(Pos, sl)
      '0' -> sl := Cons(Zero, sl)
      '-' -> sl := Cons(Neg, sl)
      _ -> throw("Invalid Character")
  sl

fun to_int(n: btern): int
  match n
    Nil -> 0
    Cons(Zero, Nil) -> 0
    Cons(Pos, rst) -> 1+3*rst.to_int
    Cons(Neg, rst) -> -1+3*rst.to_int
    Cons(Zero, rst) -> 3*rst.to_int

fun from_int(n: int): <exn> btern
  if n == 0 then [] else
    match n % 3
      0 -> Cons(Zero, from_int((n/3).pretend-decreasing))
      1 -> Cons(Pos, from_int(((n - 1)/3).pretend-decreasing))
      2 -> Cons(Neg, from_int(((n+1)/3).pretend-decreasing))
      _ -> throw("Impossible")

fun (+)(n1: btern, n2: btern): <exn,div> btern
  match (n1, n2)
    ([], a) -> a
    (a, []) -> a
    (Cons(Pos, t1), Cons(Neg, t2)) -> 
      val sum = t1 + t2
      if sum.is-nil then [] else Cons(Zero, sum)
    (Cons(Neg, t1), Cons(Pos, t2)) ->
      val sum = t1 + t2
      if sum.is-nil then [] else Cons(Zero, sum)
    (Cons(Zero, t1), Cons(Zero, t2)) ->
      val sum = t1 + t2
      if sum.is-nil then [] else Cons(Zero, sum)
    (Cons(Pos, t1), Cons(Pos, t2)) -> Cons(Neg, t1 + t2 + [Pos])
    (Cons(Neg, t1), Cons(Neg, t2)) -> Cons(Pos, t1 + t2 + [Neg])
    (Cons(Zero, t1), Cons(h, t2)) -> Cons(h, t1 + t2)
    (Cons(h, t1), Cons(Zero, t2)) -> Cons(h, t1 + t2)
    _ -> throw("Impossible")

fun neg(n: btern)
  n.map fn(d)
    match d
      Pos -> Neg
      Zero -> Zero
      Neg -> Pos

fun (-)(n1: btern, n2: btern): <exn,div> btern
  n1 + neg(n2)

fun (*)(n1, n2)
  match n2
    [] -> []
    [Pos] -> n1
    [Neg] -> n1.neg
    (Cons(Pos, t)) -> Cons(Zero, t*n1) + n1
    (Cons(Neg, t)) -> Cons(Zero, t*n1) - n1
    (Cons(Zero, t)) -> Cons(Zero, t*n1)

fun main()
  val a = "+-0++0+".from_string
  val b = (-436).from_int
  val c = "+-++-".from_string
  val d = a * (b - c)
  println("a = " ++ a.to_int.show ++ "\nb = " ++ b.to_string ++ "\nc = " ++ c.to_int.show ++ "\na * (b - c) = " ++ d.to_string ++ " = " ++ d.to_int.show )