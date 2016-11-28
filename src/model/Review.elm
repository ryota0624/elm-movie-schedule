module Review exposing (..)


type alias Review =
    { id : String
    , point : Int
    }


create : String -> Int -> Review
create id point =
    { id = id, point = point }
