/*----------------------------------------------------------------------------
   Copyright 2024, Koka-Community Authors

   Licensed under the MIT License ("The License"). You may not
   use this file except in compliance with the License. A copy of the License
   can be found in the LICENSE file at the root of this distribution.
----------------------------------------------------------------------------*/

type state
  Open
  Closed

fun toggle(self: state): state
  match self
    Open   -> Closed
    Closed -> Open

inline extern unsafe-assign : forall<a> ( v : vector<a>, i : ssize_t, x : a ) -> total ()
  c "kk_vector_unsafe_assign"

// fun main()
//   val doors = vector(100, Closed)
//   for(0,99) fn(pass)
//     var door := pass
//     while { door < 99 }
//       doors.unsafe-assign(door.ssize_t, doors[door].toggle)
//       door := door + (pass+1)
//   doors.foreach-indexed fn(idx, it)
//     match it
//       Open   -> println("door " ++ (idx + 1).show ++ " is open")
//       Closed -> println("door " ++ (idx + 1).show ++ " is closed")

 
fun main()
  val doors = list(0,99,1,fn(i) Closed)
  val transformed = list(1,99).foldl(doors) fn(drs, pass)
    drs.map-indexed fn(i, door)
      if ((i + 1) % pass) == 0 then door.toggle else door
  transformed.foreach-indexed fn(idx, it)
    match it
      Open   -> println("door " ++ (idx + 1).show ++ " is open")
      Closed -> println("door " ++ (idx + 1).show ++ " is closed")

