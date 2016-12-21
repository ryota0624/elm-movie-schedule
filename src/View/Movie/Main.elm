module View.Movie.Main exposing (..)

import Model.Movie exposing (Movie)
import Html exposing (div, img, text, hr, span)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import Update.Movie as Update exposing (Msg(ReviewMovie, None))
import Model.Review as Review


view : Movie -> Html.Html Update.Msg
view movie =
    div []
        [ text movie.title
        , movie.base
            |> Maybe.map (\{ thumbnaiUrl } -> img [ src <| "http://www.aeoncinema.com" ++ thumbnaiUrl ] [])
            |> Maybe.withDefault (div [] [])
        ]


reviewModal : Int -> Movie -> Html.Html Update.Msg
reviewModal point movie =
    let
        whiteStar =
            repeatString point "☆"

        blackStar =
            repeatString (5 - point) "★"

        suffixList =
            List.range 1 5

        reviewEvent : Int -> Msg
        reviewEvent index =
            let
                reviewMovie =
                    \point ->
                        ReviewMovie movie.id (Review.Review point "")
            in
                movie.review
                    |> Maybe.map (\{ point } -> reviewMovie point)
                    |> Maybe.withDefault (reviewMovie index)

        reviewStars =
            whiteStar
                ++ blackStar
                |> String.split ""
                |> List.indexedMap (,)
                |> List.map (\( index, star ) -> span [ onClick (reviewEvent (index + 1)) ] [ text star ])
    in
        div [] reviewStars


repeatString : Int -> String -> String
repeatString n str =
    List.range 1 n |> List.map (\n -> str) |> List.foldr (++) ""
