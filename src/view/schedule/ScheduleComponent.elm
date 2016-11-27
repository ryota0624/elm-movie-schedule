module ScheduleComponent exposing (..)

import Html
import ScheduleUpdate exposing (Msg(StoreSchedule, NoMsg, SetTime), update, State, now)
import Schedule exposing (Schedule)
import ScheduleView exposing(view)
import SchedulePort exposing(schedule)

init: { schedule: Schedule } -> (State, Cmd Msg)
init { schedule } =
    ({ schedule = schedule, currentDate = Maybe.Nothing }, now)

subscriptions : State -> Sub Msg
subscriptions model = Sub.batch [ schedule StoreSchedule ]

main =
  Html.programWithFlags
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }