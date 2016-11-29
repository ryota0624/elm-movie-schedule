module ScheduleUpdate exposing (Msg(..), update, State, now)

import Schedule exposing (Schedule)
import Movie exposing (Movie)
import SchedulePort exposing (onClickMovie, onChangePreviewTime)
import Time exposing (Time)
import Date exposing (Date, fromTime)
import Task


type alias State =
    { schedule : Maybe Schedule
    , currentDate : Maybe Date
    }


type Msg
    = NoMsg
    | StoreSchedule Schedule
    | ClickMovie Movie
    | SetTime Time
    | ClickPrevDate Date
    | ClickNextDate Date


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        NoMsg ->
            ( state, Cmd.none )

        StoreSchedule schedule ->
            ( { state | schedule = Maybe.Just schedule }, Cmd.none )

        ClickMovie movie ->
            ( state, onClickMovie movie )

        SetTime time ->
            ( { state | currentDate = Maybe.Just (fromTime (time)) }, Cmd.none )

        ClickPrevDate date ->
            let
                ( movedDate, movedTime ) =
                    timeJumpDay date -1
            in
                ( { state | currentDate = Maybe.Just (movedDate) }, onChangePreviewTime movedTime )

        ClickNextDate date ->
            let
                ( movedDate, movedTime ) =
                    timeJumpDay date 1
            in
                ( { state | currentDate = Maybe.Just (movedDate) }, onChangePreviewTime movedTime )


timeJumpDay : Date -> Float -> ( Date, Time.Time )
timeJumpDay date num =
    let
        time =
            Date.toTime date |> Time.inMilliseconds

        movedTime =
            time + (num * 60 * 60 * 24 * 1000)
    in
        ( Date.fromTime <| movedTime, movedTime )


now : Cmd Msg
now =
    Task.perform SetTime Time.now
