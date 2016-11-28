module MovieComponentState exposing (State)

import Movie exposing (Movie)
import Review exposing (Review)


type alias State =
    { movie : Maybe Movie
    , review : Maybe Review
    }
