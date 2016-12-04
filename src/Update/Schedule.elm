module Update.Schedule exposing (Msg(..), update, getSchedule)

import Model.Schedule exposing (ScheduleModel, Schedule, decodeModelDTO, decodeSchedule, MovieValueObject)
import Http
import Navigation


type Msg
    = UpdateSchedule (Result Http.Error Schedule)
    | MovieDetail MovieValueObject


update : Msg -> ScheduleModel -> ( ScheduleModel, Cmd Msg )
update msg model =
    case msg of
        UpdateSchedule result ->
            case result of
                Ok schedule ->
                    Maybe.Just schedule ! []

                Err err ->
                    model ! []

        MovieDetail movie ->
            model ! [ Navigation.newUrl <| "#movies/" ++ movie.id ]


getSchedule : Cmd Msg
getSchedule =
    let
        url =
            "/schedule"
    in
        Http.send UpdateSchedule (Http.get url decodeSchedule)
