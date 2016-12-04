module Model.Schedule exposing (..)

import Json.Decode as Decode


type alias Schedule =
    { date : String
    , movies : List MovieValueObject
    }


type alias ScheduleModel =
    Maybe Schedule


type alias MovieValueObjectID =
    String


type alias MovieValueObjectTitle =
    String


type alias MovieValueObject =
    { id : MovieValueObjectID
    , title : MovieValueObjectTitle
    , thumbnaiUrl : String
    , detailUrl : String
    }


decodeSchedule : Decode.Decoder Schedule
decodeSchedule =
    Decode.map2 Schedule
        (Decode.field "date" Decode.string)
        (Decode.field "movies" (Decode.list decodeModelDTO))


decodeModelDTO : Decode.Decoder MovieValueObject
decodeModelDTO =
    Decode.map4 MovieValueObject
        (Decode.field "id" Decode.string)
        (Decode.field "title" Decode.string)
        (Decode.field "thumbnail_url" Decode.string)
        (Decode.field "detail_url" Decode.string)
