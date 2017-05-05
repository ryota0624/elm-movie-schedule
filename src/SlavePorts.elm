port module SlavePorts exposing (..)


port sendPort : (( String, String ) -> msg) -> Sub msg


port receivePort : String -> Cmd msg


type alias Mutation =
    { t : String
    }
