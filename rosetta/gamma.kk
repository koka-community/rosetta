/*----------------------------------------------------------------------------
   Copyright 2024, Koka-Community Authors

   Licensed under the MIT License ("The License"). You may not
   use this file except in compliance with the License. A copy of the License
   can be found in the LICENSE file at the root of this distribution.
----------------------------------------------------------------------------*/

import std/num/float64

fun gamma-lanczos(x)
  val g = 7.0
  // Coefficients used by the GNU Scientific Library
  val c = [0.99999999999980993, 676.5203681218851, -1259.1392167224028,
      771.32342877765313, -176.61502916214059, 12.507343278686905,
      -0.13857109526572012, 9.9843695780195716e-6, 1.5056327351493116e-7]
  fun ag(z: float64, d: int)
    if d == 0 then c[0].unjust + ag(z, 1)
    elif d < 8 then c[d].unjust / (z + d.float64) + ag(z, d.inc)
    else c[d].unjust / (z + d.float64)
  fun gamma(z)
    val z' = z - 1.0
    val p = z' + g + 0.5
    sqrt(2.0 * pi) * pow(p, (z' + 0.5)) * exp(0.0 - p) * ag(z', 0)
  gamma(x)

val e = exp(1.0)
fun gamma-stirling(x)
  sqrt(2.0 * pi / x) * pow(x / e, x)

fun gamma-stirling2(x')
  // Extended Stirling method seen in Abramowitz and Stegun 
  val d = [1.0/12.0, 1.0/288.0, -139.0/51840.0, -571.0/2488320.0]
  fun corr(z, x, n)
    if n < d.length - 1 then d[n].unjust / x + corr(z, x*z, n.inc)
    else d[n].unjust / x
  fun gamma(z)
    gamma-stirling(z)*(1.0 + corr(z, z, 0))
  gamma(x')

fun mirror(gma, z)
  if z > 0.5 then gma(z) else pi / sin(pi * z) / gma(1.0 - z)

fun main()
  println("z\tLanczos\t\t\tStirling\t\tStirling2")
  for(1, 20) fn(i)
    val z = i.float64 / 10.0
    println(z.show(1) ++ "\t" ++ mirror(gamma-lanczos, z).show ++ "\t" ++
        mirror(gamma-stirling, z).show ++ "\t" ++ mirror(gamma-stirling2, z).show)
  for(1, 7) fn(i)
    val z = 10.0 * i.float64
    println(z.show ++ "\t" ++ gamma-lanczos(z).show ++ "\t" ++
        gamma-stirling(z).show ++ "\t" ++ gamma-stirling2(z).show)