module Update.Schedule exposing (Msg(..), update, getSchedule, Model)

import Model.Schedule exposing (Schedule, Schedule, decodeModelDTO, decodeSchedule, MovieValueObject)
import Http
import Navigation
import MasterPorts exposing (sendPort)


type Msg
    = UpdateSchedule (Result Http.Error Schedule)
    | MovieDetail MovieValueObject


type alias Model =
    Maybe Schedule


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateSchedule result ->
            case result of
                Ok schedule ->
                    Maybe.Just schedule ! []

                Err err ->
                    model ! []

        MovieDetail movie ->
            model ! [ Navigation.newUrl <| "#movies/" ++ movie.id, sendPort ( "type", movie.title ) ]


getSchedule : Cmd Msg
getSchedule =
    let
        url =
            "/schedule"
    in
        Http.send UpdateSchedule (Http.get url decodeSchedule)
