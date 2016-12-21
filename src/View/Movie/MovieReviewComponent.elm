module View.Movie.MovieReviewComponent exposing (..)

import Model.Review exposing (Review, Describe, Point)
import Model.Movie exposing (Movie, ID)
import Html exposing (div, span, text, textarea, br, button)
import Html.Events exposing (onClick, onInput)


type alias Model =
    { movieId : ID
    , editingReview : Review
    }


type Msg
    = EditDescribe Describe
    | EditPoint Point
    | SubmitReview ID Review


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EditDescribe describe ->
            { model | editingReview = Review model.editingReview.point describe } ! []

        EditPoint point ->
            { model | editingReview = Review point model.editingReview.describe } ! []

        _ ->
            model ! []


initialModel : ID -> Model
initialModel id =
    Model id (Review 0 "")


init : Model
init =
    Model "" (Review 0 "")


view : Model -> Html.Html Msg
view model =
    div []
        [ reviewPointView model
        , br [] []
        , reviewDescribeView model
        , br [] []
        , reviewSubmitView model
        ]


repeatString : Int -> String -> String
repeatString n str =
    List.range 1 n |> List.map (\n -> str) |> List.foldr (++) ""


reviewPointView : Model -> Html.Html Msg
reviewPointView model =
    let
        whiteStar =
            repeatString model.editingReview.point "☆"

        blackStar =
            repeatString (5 - model.editingReview.point) "★"

        reviewStars =
            whiteStar
                ++ blackStar
                |> String.split ""
                |> List.indexedMap (,)
                |> List.map (\( index, star ) -> span [ onClick <| EditPoint (index + 1) ] [ text star ])
    in
        div [] reviewStars


reviewDescribeView : Model -> Html.Html Msg
reviewDescribeView { editingReview } =
    textarea [ onInput EditDescribe ] [ text editingReview.describe ]


reviewSubmitView : Model -> Html.Html Msg
reviewSubmitView { movieId, editingReview } =
    button [ onClick <| SubmitReview movieId editingReview ] [ text "submit" ]
