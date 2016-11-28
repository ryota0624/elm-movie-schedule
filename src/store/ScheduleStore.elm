port module ScheduleStore exposing (..)

import Platform
import Json.Decode
import Schedule exposing (Schedule)


type Msg
    = Nil
    | Store Schedule


type alias State =
    { schedule : Maybe Schedule
    }


port storeFromPort : (Schedule -> msg) -> Sub msg


port pushState : State -> Cmd model


subscriptions : State -> Sub Msg
subscriptions model =
    Sub.batch [ storeFromPort Store ]


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        Store schedule ->
            let
                nextState =
                    { state | schedule = Maybe.Just (schedule) }
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
