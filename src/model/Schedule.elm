module Schedule exposing (..)

import Movie exposing (Movie)


type alias Schedule =
    { date : String
    , movies : List Movie
    }
