module ReviewsState exposing (State)

import Movie exposing (Movie)
import Review exposing (Review)


type alias State =
    { movies : List Movie
    , reviews : List Review
    }
