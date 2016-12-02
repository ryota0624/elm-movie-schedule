module ModalUpdate exposing (update, Msg(..))

import ModalModel exposing (Model)


type Msg
    = Open
    | Close


update : Msg -> Model -> Model
update msg model =
    case msg of
        Open ->
            { model | open = True }

        Close ->
            { model | open = False }
