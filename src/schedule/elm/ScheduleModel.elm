module ScheduleModel exposing (..)

type alias Movie = 
  { id: String
  , title: String
  , thumbnailUrl: String
  , detailUrl: String
  }

type alias Schedule = 
  {
    date: String
  , movies: List Movie
  }

initialScheduleModel: Schedule
initialScheduleModel =
  { 
    date = "000,0000"
  , movies = []
  }

type alias Model = Schedule
