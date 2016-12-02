module ModalView exposing (..)

import ModalModel exposing (..)
import Html
import ModalUpdate exposing (..)


view : Model -> Html.Html Msg
view model =
    case model.open of
        True ->
            Html.div [] [ Html.text "open" ]

        False ->
            Html.span [] []
