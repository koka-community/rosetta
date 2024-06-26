/*----------------------------------------------------------------------------
   Copyright 2024, Koka-Community Authors

   Licensed under the MIT License ("The License"). You may not
   use this file except in compliance with the License. A copy of the License
   can be found in the LICENSE file at the root of this distribution.
----------------------------------------------------------------------------*/

import std/num/random
import std/num/float64
import std/os/readline

type expr
  Num(i: int)
  Add(e1: expr, e2: expr)
  Sub(e1: expr, e2: expr)
  Mul(e1: expr, e2: expr)
  Div(e1: expr, e2: expr)

fun genNum()
  random-int() % 9 + 1

fun parseFact(s: string): <div,exn> (expr, string)
  match s.head
    "(" -> 
      val (e, rest) = s.tail.parseExpr()
      match rest.head
        ")" -> (e, rest.tail)
        _ -> throw("expected ')'")
    x | x.head-char.default('_').is-digit -> (Num(x.parse-int.unjust), s.tail)
    _ -> throw("No factor")

fun parseTerm(s): <div,exn> (expr, string)
  val (e', n) = s.parseFact()
  match n.head
    "*" -> 
      val (e'', n') = n.tail.parseTerm()
      (Mul(e', e''), n')
    "/" ->
      val (e'', n') = n.tail.parseTerm()
      (Div(e', e''), n')
    _ -> (e', n)

fun parseExpr(s): <div,exn> (expr, string)
  val (e', n) = s.parseTerm()
  match n.head
    "+" -> 
      val (e'', n') = n.tail.parseExpr()
      (Add(e', e''), n')
    "-" ->
      val (e'', n') = n.tail.parseExpr()
      (Sub(e', e''), n')
    _ -> (e', n)

fun numbers(e: expr): div list<int>
  match e
    Num(i) -> [i]
    Add(e1, e2) -> numbers(e1) ++ numbers(e2)
    Sub(e1, e2) -> numbers(e1) ++ numbers(e2)
    Mul(e1, e2) -> numbers(e1) ++ numbers(e2)
    Div(e1, e2) -> numbers(e1) ++ numbers(e2)

fun check(e: expr, l: list<int>): <div,exn> ()
  val ns = numbers(e)
  if (ns.length == 4) then
    if l.all(fn(n) ns.any(fn(x) x == n)) then
      ()
    else
      throw("wrong numbers")
  else
    throw("wrong number of numbers")

fun evaluate(e: expr): float64
  match e
    Num(i) -> i.float64
    Add(e1, e2) -> evaluate(e1) + evaluate(e2)
    Sub(e1, e2) -> evaluate(e1) - evaluate(e2)
    Mul(e1, e2) -> evaluate(e1) * evaluate(e2)
    Div(e1, e2) -> evaluate(e1) / evaluate(e2)

fun main()
  println("\nGoal: ")
  println("- Create an expression that evaluates to 24")
  println("- Using the four given numbers each number once")
  println("- Using the operators (+-/*) with no spaces")
  println("Example 2 3 4 1: (2+3)*4*1\n")
  println("Here are your numbers!")
  var l: list<int> := Nil
  repeat(4) fn()
    val n = genNum()
    l := Cons(n, l)
    (n.show ++ " ").print
  println("")
  var found := False
  while { !found } fn()
    val (expr, r) = readline().parseExpr()
    if r.count > 0 then
      println("Expected EOF but got: " ++ r ++ " please try again")
      return ()
    expr.check(l)
    val result = expr.evaluate()
    if result == 24.0 then
      println("You got it!")
      found := True
    else
      println("Try again, your expression evaluated to: " ++ result.show)
  