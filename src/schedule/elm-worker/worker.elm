port module WorkerPort exposing (..)

import Platform
import Json.Decode
import ScheduleModel exposing (Schedule)
import Maybe

port storeFromPort: (Schedule -> msg) -> Sub msg
type Msg = Nill | Store Schedule

type alias Model = 
  {
    schedule: Maybe Schedule
  }

subscriptions : Model -> Sub Msg
subscriptions model = Sub.batch [ storeFromPort Store ]

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
    Store schedule -> ( { model | schedule = Maybe.Just(schedule) }, Cmd.none)
    _ -> (model, Cmd.none)

init: Model -> (Model, Cmd Msg)
init model = (model, Cmd.none)

main = Platform.programWithFlags
  {
    init = init
   ,update = update
   ,subscriptions = subscriptions
  }