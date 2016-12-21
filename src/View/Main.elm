module View.Main exposing (..)

import Update.Main exposing (..)
import Routing.Main exposing (Route(MovieRoute, ScheduleRoute, NotFoundRoute))
import View.Schedule.Main as ScheduleView
import View.Movie.Main as MovieView
import View.Movie.MovieReviewComponent as MovieReviewComponent
import View.ComponentMsgWrapper.MovieReview as MovieReviewMsgWrapper
import Update.Movie exposing (movieOfMovies)
import Html exposing (..)


view : Model -> Html Msg
view model =
    case model.route of
        ScheduleRoute ->
            model.schedule
                |> Maybe.map (ScheduleView.view >> Html.map ScheduleMsg)
                |> Maybe.withDefault (div [] [])

        MovieRoute id ->
            model.movieList
                |> (movieOfMovies id).getOption
                |> Maybe.map
                    (\movie ->
                        let
                            { movieReviewComponent } =
                                model
                        in
                            div []
                                [ (MovieView.view >> Html.map MovieMsg) movie
                                , MovieReviewComponent.view ({ movieReviewComponent | movieId = movie.id }) |> Html.map MovieReviewMsgWrapper.mapToApp
                                ]
                    )
                |> Maybe.withDefault (div [] [ text id ])

        NotFoundRoute ->
            div [] [ text "nomatch" ]
