module Routing.Main exposing (..)

import Navigation exposing (Location)
import Model.Schedule exposing (MovieValueObjectID)
import UrlParser exposing (..)


type Route
    = ScheduleRoute
    | MovieRoute MovieValueObjectID
    | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map ScheduleRoute top
        , map MovieRoute (s "movies" </> string)
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
