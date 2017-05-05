port module MasterPorts exposing (..)


port sendPort : ( String, String ) -> Cmd msg


port receivePort : (String -> msg) -> Sub msg
