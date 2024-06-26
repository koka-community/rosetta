/*----------------------------------------------------------------------------
   Copyright 2024, Koka-Community Authors

   Licensed under the MIT License ("The License"). You may not
   use this file except in compliance with the License. A copy of the License
   can be found in the LICENSE file at the root of this distribution.
----------------------------------------------------------------------------*/

import std/num/random
import std/os/readline

effect exit
  final ctl exit(): ()

type player
  Player
  Computer

fun other(p: player): player
  match p
    Player -> Computer
    Computer -> Player

fun show(p: player): string
  match p
    Player -> "Player"
    Computer -> "Computer"

fun get-selection(max-int: int)
  val l = readline().trim()
  val i = l.parse-int()
  match i
    Just(x) | x >= 1 && x <= max-int -> x
    _ ->
      if (l == "q") then exit()
      println("Please enter a number between 1 and " ++ max-int.show ++ " or press q to quit")
      get-selection(max-int)

fun play(p: player, total: int)
  println("Total: " ++ total.show)
  match total
    21 ->
      // The player who reaches 21 wins the game, which is the player in the last loop
      println(p.other.show ++ " wins!")
      return ()
    _ -> ()
  val max = if total + 3 > 21 then 21 - total else 3
  match p
    Player ->
      println("Player's turn")
      val selection = get-selection(max)
      play(p.other, total + selection)
    Computer ->
      println("Computer's turn")
      val selection = (random-int() % max) + 1
      println("Computer chooses " ++ selection.show)
      play(p.other, total + selection)

fun main()
  with final ctl exit() ()
  "21 is a two player game. The game is played by choosing a number (1, 2, 3) to".println
  "be added to the running total. The game is won by the player whose chosen number".println
  "causes the running total to reach exactly 21. The running total starts at zero.".println
  "".println
  "You can quit the game at any time by typing 'q'.".println
  val playerGoesFirst = random-bool()
  val p1 = if playerGoesFirst then Player else Computer
  play(p1, 0)
