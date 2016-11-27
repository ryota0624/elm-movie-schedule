module Date.Extra.Period exposing
  ( add
  , DeltaRecord
  , diff
  , Period (..)
  , toTicks
  , zeroDelta
  )

{-| Period is a fixed length of time. It is an elapsed time concept, which
does not include the concept of Years Months or Daylight saving variations.

Name of type concept copied from NodaTime.

@docs add
@docs diff
@docs Period
@docs DeltaRecord
@docs zeroDelta
@docs toTicks

Copyright (c) 2016 Robin Luiten
-}

import Date exposing (Date)

import Date.Extra.Core as Core


{-| A Period.

Week is a convenience for users if they want to use it, it does
just scale Day in functionality so is not strictly required.

DELTARECORD values are multiplied addend on application.
-}
type Period
  = Millisecond
  | Second
  | Minute
  | Hour
  | Day
  | Week
  | Delta DeltaRecord


{-| A multi granularity period delta. -}
type alias DeltaRecord =
  { week : Int
  , day : Int
  , hour : Int
  , minute : Int
  , second : Int
  , millisecond : Int
  }


{-| All zero delta.
Useful as a starting point if you want to set a few fields only.
-}
zeroDelta : DeltaRecord
zeroDelta =
  { week = 0
  , day = 0
  , hour = 0
  , minute = 0
  , second = 0
  , millisecond = 0
  }


{-| Return tick counts for periods.
Useful to get total ticks in a Delta.
-}
toTicks : Period -> Int
toTicks period =
  case period of
    Millisecond -> Core.ticksAMillisecond
    Second -> Core.ticksASecond
    Minute -> Core.ticksAMinute
    Hour -> Core.ticksAnHour
    Day -> Core.ticksADay
    Week -> Core.ticksAWeek
    Delta delta ->
        (Core.ticksAMillisecond * delta.millisecond)
      + (Core.ticksASecond * delta.second)
      + (Core.ticksAMinute * delta.minute)
      + (Core.ticksAnHour * delta.hour)
      + (Core.ticksADay * delta.day)
      + (Core.ticksAWeek * delta.week)


{-| Add Period count to date. -}
add : Period -> Int -> Date -> Date
add period =
  addTimeUnit (toTicks period)


{- Add time units. -}
addTimeUnit : Int -> Int -> Date -> Date
addTimeUnit unit addend date =
  date
    |> Core.toTime
    |> (+) (addend * unit)
    |> Core.fromTime


{-| Return a Period representing date difference. date1 - date2.

If  you add the result of this function to date2 with addend of 1
will return date1.
 -}
diff : Date -> Date -> DeltaRecord
diff date1 date2 =
  let
    ticksDiff = Core.toTime date1 - Core.toTime date2
    hourDiff = Date.hour date1 - Date.hour date2
    minuteDiff = Date.minute date1 - Date.minute date2
    secondDiff = Date.second date1 - Date.second date2
    millisecondDiff = Date.millisecond date1 - Date.millisecond date2
    ticksDayDiff =
        ticksDiff
      - (hourDiff * Core.ticksAnHour)
      - (minuteDiff * Core.ticksAMinute)
      - (secondDiff * Core.ticksASecond)
      - (millisecondDiff * Core.ticksAMillisecond)
    onlyDaysDiff = ticksDayDiff // Core.ticksADay
    (weekDiff, dayDiff) =
      if onlyDaysDiff < 0 then
        let
          absDayDiff = abs onlyDaysDiff
        in
          ( negate (absDayDiff // 7)
          , negate (absDayDiff % 7)
          )
      else
        ( onlyDaysDiff // 7
        , onlyDaysDiff % 7
        )
  in
    { week = weekDiff
    , day = dayDiff
    , hour = hourDiff
    , minute = minuteDiff
    , second = secondDiff
    , millisecond = millisecondDiff
    }
