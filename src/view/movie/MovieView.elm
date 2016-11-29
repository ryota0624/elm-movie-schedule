module MovieView exposing (view)

import MovieUpdate exposing (update, Msg(..))
import Html exposing (Html, text, div, br, button)
import Html.Events exposing (onClick)
import Movie exposing (Movie)
import MovieComponentState exposing (State)
import Review exposing (Review)


pointButton : Int -> Html Msg
pointButton point =
    button [ onClick <| ClickPointButton <| point ] []


pointSelectorView : Int -> Html Msg
pointSelectorView pointRange =
    let
        points =
            List.range 1 pointRange
    in
        div [] (List.map pointButton points)


movieView : Movie -> Html Msg
movieView { title, story } =
    div []
        [ text title
        , br [] []
        , text <| Maybe.withDefault "..loading" story
        , br [] []
        ]


makeStar : Int -> Html Msg
makeStar starNum =
    div [] (List.repeat starNum (text "☆"))


reviewView : Review -> Html Msg
reviewView review =
    div [] [ makeStar <| review.point, button [ onClick <| RemoveReview <| review ] [ text "reset review" ] ]


fivePointView : Html Msg
fivePointView =
    pointSelectorView 5


view : State -> Html Msg
view { movie, review } =
    case movie of
        Maybe.Just movie ->
            div []
                [ movieView movie
                , Maybe.withDefault fivePointView (Maybe.map (\review -> reviewView review) review)
                , div [ onClick ClickBackButton ] [ text "もどる" ]
                ]

        Maybe.Nothing ->
            text "loading"
