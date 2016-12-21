module View.ComponentMsgWrapper.MovieReview exposing (..)

import Update.Main as MainUpdate
import Update.Movie as MovieUpdate
import View.Movie.MovieReviewComponent as MovieReviewComponent


mapToApp : MovieReviewComponent.Msg -> MainUpdate.Msg
mapToApp msg =
    case msg of
        MovieReviewComponent.SubmitReview id review ->
            MainUpdate.MovieMsg (MovieUpdate.ReviewMovie id review)

        _ ->
            MainUpdate.MovieReview msg
