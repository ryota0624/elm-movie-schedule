module Model.Movie exposing (Movie, ID, decodeMovie, MovieList, update, updateBase)

import Json.Decode as Decode
import Dict
import Model.Schedule exposing (MovieValueObject)


type alias ID =
    String


type alias Title =
    String


type alias Story =
    String


type alias PageUrl =
    String


type alias Movie =
    { id : ID
    , title : Title
    , story : Story
    , pageUrl : PageUrl
    , base : Maybe MovieValueObject
    }


updateBase : Maybe MovieValueObject -> Movie -> Movie
updateBase movieVo movie =
    { movie | base = movieVo }


type alias MovieList =
    Dict.Dict String Movie


update : Movie -> MovieList -> MovieList
update movie list =
    Dict.insert movie.id movie list


decodeMovie : Decode.Decoder Movie
decodeMovie =
    (Decode.map4 Movie
        (Decode.field "id" Decode.string)
        (Decode.field "title" Decode.string)
        (Decode.field "story" Decode.string)
        (Decode.field "page_url" Decode.string)
    )
        |> Decode.map (\fn -> fn Nothing)
