module View.Schedule.Main exposing (..)

import Model.Schedule exposing (Schedule, MovieValueObject)
import Html exposing (div, Html, text, a, img)
import Html.Events exposing (onClick)
import Html.Attributes exposing (src)
import Update.Schedule exposing (Msg(..))


view : Schedule -> Html Msg
view schedule =
    div []
        (schedule.movies
            |> List.map movieView
        )


movieView : MovieValueObject -> Html Msg
movieView movie =
    div [ onClick (MovieDetail movie) ]
        [ div [] [ text movie.title ]
        , (img [ src <| "http://www.aeoncinema.com" ++ movie.thumbnaiUrl ] [])
        ]
