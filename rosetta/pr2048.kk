/*----------------------------------------------------------------------------
   Copyright 2024, Koka-Community Authors

   Licensed under the MIT License ("The License"). You may not
   use this file except in compliance with the License. A copy of the License
   can be found in the LICENSE file at the root of this distribution.
----------------------------------------------------------------------------*/

import std/num/random
import std/num/float64
import std/os/readline
import std/core/undiv

val empty = list(0, 15).map(fn(_) 0)
fun win(l)
  l.any(fn(x) x == 2048)

fun stack(l)
  match l
    Cons(0, tl) -> tl.stack ++ [0]
    Cons(hd, tl) -> Cons(hd, tl.stack)
    Nil -> Nil

fun join(l: list<int>)
  match l
    Cons(a, Cons(b, c)) | a == b -> Cons((a + b), c.join) ++ [0]
    Cons(a, b) -> Cons(a, b.join)
    Nil -> Nil

fun hit(l)
  l.stack.join

fun hitBack(l)
  l.reverse.hit.reverse

fun splitBy(l: list<a>, i: int): div list<list<a>>
  val (a, b) = l.split(i)
  match b
    Cons -> Cons(a, b.splitBy(i))
    Nil -> Cons(a, Nil)

fun transpose(l: list<list<a>>): <exn> list<list<a>>
  match l
    Cons(Cons(a, b), c) -> Cons(Cons(a, c.map(fn(x) x.head.unjust)), transpose(Cons(b, c.map(fn(x) x.tail)).pretend-decreasing))
    Cons(Nil, b) -> transpose(b)
    Nil -> Nil

fun rows(l)
  l.splitBy(4)

fun left(l)
  l.rows.map(hit).concat

fun right(l)
  l.rows.map(hitBack).concat

fun up(l)
  l.rows.transpose.map(hit).transpose.concat

fun down(l)
  l.rows.transpose.map(hitBack).transpose.concat

fun (==)(l1: list<int>, l2: list<int>): bool
  match l1
    Cons(a, b) -> match l2
      Cons(c, d) -> a == c && b == d
      Nil -> False
    Nil -> match l2
      Cons -> False
      Nil -> True

fun lose(l)
  l.left == l && l.right == l && l.up == l && l.down == l

fun numZeros(l: list<int>): int 
  l.filter(fn(x) x == 0).length

fun insert(l: list<int>, what: int, toWhere: int)
  match l
    Cons(0, tail) | tail.numZeros == toWhere -> Cons(what, tail)
    Cons(head, tail) -> Cons(head, tail.insert(what, toWhere))
    Nil -> Nil

fun spawnOn(l)
  val newTileValue = if random-int() % 10 == 0 then 4 else 2
  val newPosition = random-int() % (l.numZeros - 1)
  l.insert(newTileValue, newPosition)

fun show-board(l: list<int>): div string
  "\n" ++ l.rows.map(fn(r) r.map(fn(x) x.show.pad-left(4)).join("")).intersperse("\n").join("") ++ "\n"

fun quit(l)
  []

fun quitted(l)
  l.is-nil

fun dispatch(c)
  match c
    'i' -> up
    'j' -> left
    'k' -> down
    'l' -> right
    'q' -> quit
    _ -> 
      println("Unknown command: keys are ijkl to move, q to quit")
      id

fun key()
  readline().head-char.default('_')

fun turn(l)
  l.show-board.println 
  val next = dispatch(key())(l)
  if !(next == l) && next.quitted.not then
    spawnOn(next)
  else
    next

fun play(state)
  if state.win || state.lose || state.quitted then 
    if state.quitted then
      "You quit!".println
    else if state.win then
      "You won!".println
    else
      "You lost!".println
  else 
    "play".println
    play(turn(state))

fun main()
  print("ijkl to move, q to quit\n")
  val initial = empty.spawnOn
  println("Starting game...")
  play(initial)
