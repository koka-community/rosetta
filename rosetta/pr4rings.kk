/*----------------------------------------------------------------------------
   Copyright 2024, Koka-Community Authors

   Licensed under the MIT License ("The License"). You may not
   use this file except in compliance with the License. A copy of the License
   can be found in the LICENSE file at the root of this distribution.
----------------------------------------------------------------------------*/

fun is_unique(a: int, b: int, c: int, d: int, e: int, f: int, g: int)
  a != b && a != c && a != d && a != e && a != f && a != g &&
  b != c && b != d && b != e && b != f && b != g &&
  c != d && c != e && c != f && c != g &&
  d != e && d != f && d != g &&
  e != f && e != g &&
  f != g

fun is_solution(a: int, b: int, c: int, d: int, e: int, f: int, g: int)
  val bcd = b + c + d
  val ab = a + b
  if ab != bcd then return False
  val def = d + e + f
  if bcd != def then return False
  val fg = f + g
  return def == fg

fun four_squares(low: int, high: int, unique:bool=True)
  var count := 0
  for(low, high) fn(a)
    for(low, high) fn(b)
      for(low, high) fn(c)
        for(low, high) fn(d)
          for(low, high) fn(e)
            for(low, high) fn(f)
              for(low, high) fn(g)
                if (!unique || is_unique(a, b, c, d, e, f, g)) && is_solution(a, b, c, d, e, f, g) then
                  count := count + 1
                  if unique then
                    println([a, b, c, d, e, f, g].show)
                  else
                    ()
  val uniquestr = if unique then "unique" else "non-unique"
  println(count.show ++ " " ++ uniquestr ++ " solutions in " ++ low.show ++ " to " ++ high.show ++ " range\n")

fun main()
  four_squares(1, 7)
  four_squares(3, 9)
  four_squares(0, 9, False)
  