import std/num/float64

effect special<a>
  val special : a

fun square()
  float64/(*)(special, special)

fun sqrt()
  special.sqrt()

fun main()
  with val special = 3.0
  println(square())
  println(sqrt())