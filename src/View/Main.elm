module View.Main exposing (..)

import Html exposing (..)
import Model.Main exposing (..)
import Update.Main exposing (..)
import View.Schedule.Main as ScheduleView
import Routing.Main exposing (Route(MovieRoute, ScheduleRoute, NotFoundRoute))
import View.Movie.Main as MovieView
import Dict


view : Model -> Html Msg
view model =
    case model.route of
        ScheduleRoute ->
            model.schedule
                |> Maybe.map (ScheduleView.view >> Html.map ScheduleMsg)
                |> Maybe.withDefault (div [] [])

        MovieRoute id ->
            model.movieList
                |> Dict.get id
                |> Maybe.map (MovieView.view >> Html.map MovieMsg)
                |> Maybe.withDefault (div [] [ text id ])

        NotFoundRoute ->
            div [] [ text "nomatch" ]
