module ScheduleComponent exposing (..)

import Html
import ScheduleModel exposing (Schedule, Model, Movie)
import ScheduleUpdate exposing (Msg(StoreSchedule, NoMsg), update)
import ScheduleView exposing(view)
import SchedulePort exposing(schedule)

init: Model -> (Model, Cmd Msg)
init model = (model, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model = Sub.batch [ schedule StoreSchedule ]

main =
  Html.programWithFlags
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }