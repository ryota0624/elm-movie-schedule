module Model.Main exposing (..)

import Routing.Main as Route
import Model.Movie exposing (MovieList)
import Model.Schedule exposing (ScheduleModel)


type alias Name =
    String


type alias Model =
    { schedule : ScheduleModel
    , route : Route.Route
    , movieList : MovieList
    }
