port module SchedulePort exposing (..)

import Schedule exposing (Schedule)
import Movie exposing (Movie)


port schedule : (Schedule -> msg) -> Sub msg


port onClickMovie : Movie -> Cmd movie


port onChangePreviewTime : Float -> Cmd time
