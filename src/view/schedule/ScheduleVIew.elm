module ScheduleView exposing (view)

import Html exposing (Html, text, table, thead, tbody, th, tr, td, img, div, br)
import Schedule exposing (Schedule)
import Movie exposing (Movie)
import ScheduleUpdate exposing (Msg(NoMsg, ClickMovie, ClickPrevDate, ClickNextDate), State)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import List
import Date
import Date.Extra.Format as Format exposing (format, formatUtc, utcIsoString)


tableHeadFromList : List String -> Html Msg
tableHeadFromList list =
    thead []
        [ tr [] (List.map (\str -> th [] [ text str ]) list) ]


tableRow : Movie -> Html Msg
tableRow movie =
    tr [ onClick <| ClickMovie (movie) ]
        [ td [] [ text movie.id ]
        , td [] [ text movie.title ]
        , td [] [ img [ src <| "http://www.aeoncinema.com" ++ movie.thumbnailUrl ] [] ]
        ]


tableBody : List model -> (model -> Html Msg) -> Html Msg
tableBody list modelToView =
    tbody [] (List.map modelToView list)


scheduleView : Schedule -> Html Msg
scheduleView model =
    case model.movies of
        [] ->
            div [] [ text "loading" ]

        _ ->
            table []
                [ tableHeadFromList [ "id", "title", "poster" ]
                , tableBody model.movies tableRow
                ]


dateView : Date.Date -> Html Msg
dateView date =
    div []
        [ div [ onClick <| ClickPrevDate date ] [ text "<" ]
        , div [] [ text <| utcIsoString (date) ]
        , div [ onClick <| ClickNextDate date ] [ text ">" ]
        ]


view : State -> Html Msg
view state =
    let
        currentScheduleView =
            Maybe.withDefault (div [] [ text "loading..." ]) (Maybe.map scheduleView state.schedule)

        viewChildren =
            Maybe.withDefault [] (Maybe.map (\date -> [ dateView date, br [] [], currentScheduleView ]) state.currentDate)
    in
        div [] viewChildren
