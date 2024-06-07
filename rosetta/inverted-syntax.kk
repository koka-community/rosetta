/*----------------------------------------------------------------------------
   Copyright 2024, Koka-Community Authors

   Licensed under the MIT License ("The License"). You may not
   use this file except in compliance with the License. A copy of the License
   can be found in the LICENSE file at the root of this distribution.
----------------------------------------------------------------------------*/
fun (=:)(c: c, v: local-var<h, c>): <local<h>> ()
  v := c

fun (-)(c: c, b: bool): e maybe<c>
  if b then Just(c) else Nothing

fun main()
  var x := 4
  6 =: std/core/types/@byref(x)
  x.println
  val res = "Yes" - True
  match res
    Just(a) -> println(a)
    Nothing -> throw("Nothing")