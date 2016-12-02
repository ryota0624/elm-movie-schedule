module MovieComponentState exposing (State)

import Movie exposing (Movie)
import Review exposing (Review)
import ModalComponent exposing (..)


type alias State =
    { movie : Maybe Movie
    , review : Maybe Review
    , modal : ModalModel
    }
