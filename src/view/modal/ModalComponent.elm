module ModalComponent exposing (..)

import Html
import ModalUpdate exposing (..)
import ModalModel exposing (..)
import ModalView exposing (..)


type alias ModalModel =
    Model


type alias ModalMessage =
    Msg


initModel : Model
initModel =
    { open = False
    }


modalView : Model -> Html.Html Msg
modalView model =
    view model


modalUpdate : Msg -> Model -> Model
modalUpdate msg model =
    update msg model
