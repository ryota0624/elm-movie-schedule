module MovieComponent exposing (..)

import Html
import Movie exposing (Movie)
import MovieUpdate exposing (Msg(..), update)
import MovieComponentState exposing (State)
import MovieView exposing (view)
import MoviePort exposing (..)


init : State -> ( State, Cmd Msg )
init state =
    ( state, Cmd.none )


subscriptions : State -> Sub Msg
subscriptions model =
    Sub.batch
        [ movie StoreMovie
        , review StoreReview
        , state StoreState
        ]


main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
