module App exposing (..)

import Dict
import Navigation exposing (Location)
import Model.Main exposing (Model)
import Routing.Main exposing (Route(ScheduleRoute, MovieRoute), parseLocation)
import Update.Movie exposing (getMovie)
import Update.Schedule exposing (getSchedule)
import Update.Main exposing (Msg(ScheduleMsg, OnLocationChange, MovieMsg), update)
import View.Main exposing (view)


initialModel : Route -> Model
initialModel route =
    { schedule = Maybe.Nothing
    , route = route
    , movieList = Dict.empty
    }


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            parseLocation location

        cmd =
            case currentRoute of
                ScheduleRoute ->
                    Cmd.map ScheduleMsg getSchedule

                MovieRoute id ->
                    Cmd.map MovieMsg (getMovie id Nothing)

                _ ->
                    Cmd.none
    in
        ( initialModel currentRoute, cmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
