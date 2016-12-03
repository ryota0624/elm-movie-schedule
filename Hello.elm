module Hello exposing (..)

import Html as Dom exposing (..)


type Answer
    = Yes
    | No
    | Other String


response : Answer -> String
response answer =
    case answer of
        Yes ->
            "YES"

        No ->
            "NOW"

        Other str ->
            str


type alias Human =
    { id : Int
    , name : String
    }


humanToString : Human -> String
humanToString h =
    "id: " ++ toString (h.id) ++ " name:" ++ h.name


main =
    Dom.text <| humanToString <| (\resStr -> Human (String.length resStr) resStr) <| response (Other "other")
