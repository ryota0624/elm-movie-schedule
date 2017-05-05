module SubApp exposing (main)

import Platform exposing (program, Program)
import SlavePorts exposing (sendPort, receivePort)
import Json.Decode exposing (..)


type alias Type =
    String


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ sendPort (\( f, s ) -> StoreString f)
        ]


type alias Model =
    { name : String
    }


type Msg
    = None
    | StoreString String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        StoreString str ->
            let
                a =
                    Debug.log "StoreString" str
            in
                ( { name = str ++ model.name }, receivePort str )


main : Program Never Model Msg
main =
    program
        { init = ( { name = "" }, Cmd.none )
        , subscriptions = subscriptions
        , update = update
        }
