module ReviewsView exposing (view)

import ReviewsState exposing (State)
import ReviewsUpdate exposing (update, Msg(..))
import Movie exposing (Movie)
import Review exposing (Review)
import Html exposing (..)
import Html.Events exposing (onClick)


movies : List ( Movie, Review ) -> Html Msg
movies list =
    div []
        (List.map
            (\( movie, review ) ->
                div []
                    [ span [ onClick <| OnClickMovieTitle <| movie ] [ text movie.title ]
                    , text "->"
                    , text <| toString <| review.point
                    ]
            )
            list
        )


view : State -> Html Msg
view state =
    let
        getReviewMovie : List Movie -> Review -> Maybe ( Movie, Review )
        getReviewMovie movies review =
            let
                opMovie : Maybe Movie
                opMovie =
                    (List.filter (\movie -> review.id == movie.id) movies) |> List.head
            in
                Maybe.map (\movie -> ( movie, review )) opMovie
    in
        movies <| List.filterMap (\movie -> movie) (List.map (getReviewMovie <| state.movies) state.reviews)
