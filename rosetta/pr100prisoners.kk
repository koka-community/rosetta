/*----------------------------------------------------------------------------
   Copyright 2024, Koka-Community Authors

   Licensed under the MIT License ("The License"). You may not
   use this file except in compliance with the License. A copy of the License
   can be found in the LICENSE file at the root of this distribution.
----------------------------------------------------------------------------*/

import std/num/random
import std/num/float64

value struct drawer
  num: int
  open: bool = False

inline extern unsafe-assign : forall<a> ( v : vector<a>, i : ssize_t, x : a ) -> total ()
  c "kk_vector_unsafe_assign"

fun createDrawers()
  val drawers = vector(100, Drawer(0,open=True))
  for(0, 99) fn(i)
    var found := False
    while {!found}
      val r = random-int() % 100
      if drawers[r].open then
        drawers.unsafe-assign(r.ssize_t, Drawer(i))
        found := True
      else
        ()
  drawers

fun closeAll(d:vector<drawer>)
  for(0,99) fn(i)
    d.unsafe-assign(i.ssize_t, d[i](open=False))

effect fail
  final ctl failed(): a 

fun open-random(drawers: vector<drawer>)
  val r = random-int() % 100
  val opened = drawers[r]
  if opened.open then
    open-random(drawers)
  else
    drawers.unsafe-assign(r.ssize_t, opened(open=True))
    opened.num

fun random-approach(drawers: vector<drawer>)
  for(0, 99) fn(i)
    var found := False
    for(0, 49) fn(j)
      val opened = open-random(drawers)
      if opened == i then
        found := True
      else
        ()
    if !found then
      failed()
    else
      drawers.closeAll()

fun optimal-approach(drawers: vector<drawer>)
  for(0, 99) fn(i)
    var found := False
    var drawer := i;
    for(0, 49) fn(j)
      val opened = drawers[drawer]
      if opened.open then
        failed()
      if opened.num == i then
        found := True
      else
        drawers.unsafe-assign(drawer.ssize_t, opened(open=True))
        drawer := opened.num
    if !found then
      failed()
    else
      drawers.closeAll()
      ()

fun run-trials(f, num-trials)
  var num_success := 0
  for(0,num-trials - 1) fn(i)
    val drawers = createDrawers()
    with handler
      return(x) -> 
        num_success := num_success + 1
      final ctl failed() -> 
        ()
    f(drawers)
  num_success

fun main()
  val num_trials = 1000
  val num_success_random = run-trials(random-approach, num_trials)
  val num_success_optimal = run-trials(optimal-approach, num_trials)
  println("Number of trials: " ++ num_trials.show)
  println("Random approach: wins " ++ num_success_random.show ++ " (" ++ (num_success_random.float64 * 100.0 / num_trials.float64).show(2) ++ "%)")
  println("Optimal approach: wins " ++ num_success_optimal.show ++ " (" ++ (num_success_optimal.float64 * 100.0 / num_trials.float64).show(2) ++ "%)")