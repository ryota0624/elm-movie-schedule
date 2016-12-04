module Update.Movie exposing (..)

import Model.Movie as MovieModel exposing (Movie, MovieList)
import Http
import Model.Schedule exposing (MovieValueObject)


type Msg
    = StoreMovie (Result Http.Error Movie)


update : Msg -> MovieList -> ( MovieList, Cmd Msg )
update msg model =
    case msg of
        StoreMovie result ->
            case result of
                Ok movie ->
                    MovieModel.update movie model ! []

                Err err ->
                    model ! []


getMovie : MovieModel.ID -> Maybe MovieValueObject -> Cmd Msg
getMovie id movieVo =
    let
        url =
            "/movie/" ++ id
    in
        Http.send (Result.map (MovieModel.updateBase movieVo) >> StoreMovie) (Http.get url MovieModel.decodeMovie)
