module ReviewsComponent exposing (..)

import Html
import ReviewsState exposing (State)
import ReviewsPort exposing (..)
import ReviewsUpdate exposing (Msg(..), update)
import ReviewsView exposing (view)


init : State -> ( State, Cmd Msg )
init state =
    ( state, Cmd.none )


subscriptions : State -> Sub Msg
subscriptions state =
    Sub.batch [ reviews StoreReviews, movies StoreMovies ]


main : Program State State Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
