module Update.Main exposing (..)

import Model.Main exposing (..)
import Update.Schedule as ScheduleUpdate exposing (Msg(UpdateSchedule))
import Update.Movie as MovieUpdate exposing (Msg(StoreMovie), getMovie)
import Routing.Main
import Navigation exposing (Location)
import Routing.Main exposing (parseLocation, Route(MovieRoute))
import Navigation


type Msg
    = No
    | ScheduleMsg ScheduleUpdate.Msg
    | OnLocationChange Location
    | MovieMsg MovieUpdate.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        No ->
            model ! []

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location

                cmd =
                    case newRoute of
                        MovieRoute id ->
                            let
                                scheduleMovie =
                                    model.schedule
                                        |> Maybe.map
                                            (\{ movies } ->
                                                movies
                                                    |> List.filter (\m -> m.id == id)
                                                    |> List.head
                                            )
                                        |> Maybe.withDefault Nothing
                            in
                                Cmd.map MovieMsg (getMovie id scheduleMovie)

                        _ ->
                            Cmd.none
            in
                { model | route = newRoute } ! [ cmd ]

        MovieMsg movieMsg ->
            let
                ( movieList, cmd ) =
                    MovieUpdate.update movieMsg model.movieList
            in
                { model | movieList = movieList } ! [ Cmd.map MovieMsg cmd ]

        ScheduleMsg scheduleMsg ->
            let
                ( schedule, cmd ) =
                    ScheduleUpdate.update scheduleMsg model.schedule
            in
                { model | schedule = schedule } ! [ Cmd.map ScheduleMsg cmd ]
