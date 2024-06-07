/*----------------------------------------------------------------------------
   Copyright 2024, Koka-Community Authors

   Licensed under the MIT License ("The License"). You may not
   use this file except in compliance with the License. A copy of the License
   can be found in the LICENSE file at the root of this distribution.
----------------------------------------------------------------------------*/

fun hailstone(n, s)
  if n == 1 then s ++ ctx Cons(n, _)
  else
    val next = if n % 2 == 1 then 3 * n + 1 else n / 2 
    hailstone(next, s ++ ctx Cons(n, _))

fun hailstone_length(n)
  if n == 1 then 1
  else 1 + hailstone_length(if n % 2 == 1 then 3 * n + 1 else n / 2)

fun hailstone_max(ns: list<int>)
  var max := (-1, 0)
  ns.foreach() fn(a)
    val len = hailstone_length(a)
    if len > max.snd then
      max := (a, len)
    else
      ()
  max

fun main()
  val n = 1000000
  val (i, len) = hailstone_max(list(1, 99999))
  println("The longest hailstone sequence starting with a number up to " ++ n.show ++ " is " ++ i.show ++ " which is " ++ len.show ++ " elements long.")
  val h27 = hailstone(27, ctx _) ++. Nil
  val l = h27.length
  println("Hailstone 27 has length " ++ l.show)
  println("Hailstone 27 starts with:")
  h27.take(4).show.println
  println("Hailstone 27 ends with:")
  h27.drop(l - 4).show.println
