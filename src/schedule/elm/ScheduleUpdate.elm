module ScheduleUpdate exposing (Msg(StoreSchedule, NoMsg, ClickMovie), update)
import ScheduleModel exposing (Model, Schedule, Movie)
import Debug
import SchedulePort exposing(onClickMovie)

type Msg = NoMsg | StoreSchedule Schedule | ClickMovie Movie
update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
 let
  j = case msg of
    NoMsg -> Debug.log "NoMsg" msg
    ClickMovie movie -> Debug.log movie.title NoMsg
    _ -> Debug.log "Some Message" NoMsg
 in
  case msg of
    NoMsg ->
      ( model, Cmd.none )
    StoreSchedule schedule ->
      ( schedule, Cmd.none )
    ClickMovie movie ->
      ( model, onClickMovie movie )