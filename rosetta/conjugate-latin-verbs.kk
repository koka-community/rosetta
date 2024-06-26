/*----------------------------------------------------------------------------
   Copyright 2024, Koka-Community Authors

   Licensed under the MIT License ("The License"). You may not
   use this file except in compliance with the License. A copy of the License
   can be found in the LICENSE file at the root of this distribution.
----------------------------------------------------------------------------*/

effect yield<a>
  ctl yield(a: a): ()

fun conjugate(infinitive: string)
  if infinitive.count < 4 then
    yield("Can not conjugate \"" ++ infinitive ++ "\" not long enough for a regular verb")
    return ()
  val ending = infinitive.last(3)
  val conjugations = match ending.string
    "are" -> ["o", "as", "at", "amus", "atis", "ant"]
    "ēre" -> ["eo", "es", "et", "emus", "etis", "ent"]
    "ere" -> ["o", "is", "it", "imus", "itis", "unt"]
    "ire" -> ["io", "is", "it", "imus", "itis", "iunt"]
    _ -> 
      yield("Can not conjugate \"" ++ infinitive ++ "\" not a regular verb ending")
      []
  val root = ending.before.string
  conjugations.foreach fn(c)
    yield(root ++ c)

fun main()
  with handler
    fun yield(a: string)
      println(a)
  ["amare", "vidēre", "ducere", "audire", "qwerty", "are"].foreach fn(word)
    (word ++ ":").println
    word.conjugate