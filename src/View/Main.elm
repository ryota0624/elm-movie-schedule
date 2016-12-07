module View.Main exposing (..)

import Html exposing (..)
import Update.Main exposing (..)
import View.Schedule.Main as ScheduleView
import Routing.Main exposing (Route(MovieRoute, ScheduleRoute, NotFoundRoute))
import View.Movie.Main as MovieView
import Dict
import View.Movie.MovieReviewComponent as MovieReviewComponent


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
                |> Maybe.map
                    (\movie ->
                        let
                            { movieReviewComponent } =
                                model
                        in
                            div []
                                [ (MovieView.view >> Html.map MovieMsg) movie
                                , MovieReviewComponent.view ({ movieReviewComponent | movieId = movie.id }) |> Html.map MovieReview
                                ]
                    )
                |> Maybe.withDefault (div [] [ text id ])

        NotFoundRoute ->
            div [] [ text "nomatch" ]



-- , movie.review
--     |> Maybe.map (\{ point } -> MovieReviewComponent.reviewModal point model.movieReviewComponent)
--     |> Maybe.withDefault (MovieReviewComponent.reviewModal 0 model.movieReviewComponent)
--     |> Html.map MovieReview
