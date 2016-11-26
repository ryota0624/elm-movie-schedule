port module SchedulePort exposing (..)
import ScheduleModel exposing (Movie, Schedule)

port schedule: (Schedule -> msg) -> Sub msg
port onClickMovie: Movie -> Cmd movie
