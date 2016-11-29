port module ReviewsPort exposing (..)

import Review exposing (Review)
import Movie exposing (Movie)


port reviews : (List Review -> msg) -> Sub msg


port movies : (List Movie -> msg) -> Sub msg
