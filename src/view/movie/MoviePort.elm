port module MoviePort exposing (..)

import Movie exposing (Movie)
port movie: (Movie -> msg) -> Sub msg