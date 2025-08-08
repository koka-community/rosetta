/*----------------------------------------------------------------------------
   Copyright 2024, Koka-Community Authors

   Licensed under the MIT License ("The License"). You may not
   use this file except in compliance with the License. A copy of the License
   can be found in the LICENSE file at the root of this distribution.
----------------------------------------------------------------------------*/

import std/time/date
import std/time/calendar
import std/time/instant
import std/time/utc

fun main()
  for(2008, 2121) fn(year)
    val i = instant(year, 12, 25, cal=cal-gregorian)
    val dow  = (i.days+6)%7  // plus 6 since 2000-01-01 epoch was a Saturday    
    match dow.weekday
      Sun -> println(year.show)
      _      -> ()