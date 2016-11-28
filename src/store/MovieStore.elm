port module MovieStore exposing (..)

import Platform
import Json.Decode
import Movie exposing (Movie)
import Maybe


type alias Movies =
    List Movie


type Msg
    = Nil
    | Store Movie


type alias State =
    { movies : Maybe Movies
    }


port storeFromPort : (Movie -> msg) -> Sub msg


port pushState : State -> Cmd model


subscriptions : State -> Sub Msg
subscriptions state =
    Sub.batch [ storeFromPort Store ]


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        Store movie ->
            let
                nextState =
                    { state | movies = Maybe.map (\movies -> movie :: movies) (state.movies) }
            in
                ( nextState, pushState nextState )

        _ ->
            ( state, Cmd.none )


init : State -> ( State, Cmd Msg )
init state =
    ( state, Cmd.none )


main =
    Platform.programWithFlags
        { init = init
        , update = update
        , subscriptions = subscriptions
        }
