/*----------------------------------------------------------------------------
   Copyright 2024, Koka-Community Authors

   Licensed under the MIT License ("The License"). You may not
   use this file except in compliance with the License. A copy of the License
   can be found in the LICENSE file at the root of this distribution.
----------------------------------------------------------------------------*/

fun encode(s : string, shift : int)
  fun encode-char(c) 
    if c < 'A' || (c > 'Z' && c < 'a') || c > 'z' return c
    val base = if c < 'Z' then (c - 'A').int else (c - 'a').int
    val rot  = (base + shift) % 26
    (rot.char + (if c < 'Z' then 'A' else 'a'))
  s.map(encode-char)

fun decode(s: string, shift: int)
  s.encode(0 - shift)

fun trip(s: string, shift: int)
  s.encode(shift).decode(shift)

fun main()
  "HI".encode(2).println
  "HI".encode(20).println
  "HI".trip(10).println
  val enc = "The quick brown fox jumped over the lazy dog".encode(11)
  enc.println
  enc.decode(11).println