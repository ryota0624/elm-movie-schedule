module MovieComponent exposing (..)

import Html
import Movie exposing (Movie)
import MovieUpdate exposing (Msg(StoreMovie), update)
import MovieView exposing (view)
import MoviePort exposing (movie)

init: Maybe Movie -> (Maybe Movie, Cmd Msg)
init state = (state, Cmd.none)

subscriptions : Maybe Movie -> Sub Msg
subscriptions model =
  Sub.batch [ movie StoreMovie ]

main =
  Html.programWithFlags
    {
      init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }