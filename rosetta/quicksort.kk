/*----------------------------------------------------------------------------
   Copyright 2024, Koka-Community Authors

   Licensed under the MIT License ("The License"). You may not
   use this file except in compliance with the License. A copy of the License
   can be found in the LICENSE file at the root of this distribution.
----------------------------------------------------------------------------*/

fun qsort( xs : list<int> ) : div list<int> {
  match(xs) {
    Cons(x,xx) -> {
      val ys = xx.filter fn(el) { el < x }
      val zs = xx.filter fn(el) { el >= x }
      qsort(ys) ++ [x] ++ qsort(zs)
    }
    Nil -> Nil
  }
}
fun qsort2( xs : list<int> ) : div list<int> {
  match(xs) {
    Cons(x,xx) -> {
      val (ys, zs) = xx.partition fn(el) { el < x }
      qsort(ys) ++ [x] ++ qsort(zs)
    }
    Nil -> Nil
  }
}

fun main() {
  val arr = [24,63,77,26,84,64,56,80,85,17]
  println(arr.qsort2.show)
}