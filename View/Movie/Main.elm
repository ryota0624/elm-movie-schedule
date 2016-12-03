module View.Movie.Main exposing (..)

import Model.Movie exposing (Movie)
import Html exposing (div, img, text)
import Html.Attributes exposing (src)
import Update.Movie exposing (update, Msg)


view : Movie -> Html.Html Msg
view movie =
    div []
        [ text movie.title
        , movie.base
            |> Maybe.map (\base -> img [ src <| "http://www.aeoncinema.com" ++ base.thumbnaiUrl ] [])
            |> Maybe.withDefault (div [] [])
        ]
