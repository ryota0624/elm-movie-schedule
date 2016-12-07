module Model.Movie exposing (Movie, ID, decodeMovie, updateBase)

import Model.Review exposing (Review)
import Json.Decode as Decode
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
    , review : Maybe Review
    }


updateBase : Maybe MovieValueObject -> Movie -> Movie
updateBase movieVo movie =
    { movie | base = movieVo }


decodeMovie : Decode.Decoder Movie
decodeMovie =
    (Decode.map4 Movie
        (Decode.field "id" Decode.string)
        (Decode.field "title" Decode.string)
        (Decode.field "story" Decode.string)
        (Decode.field "page_url" Decode.string)
    )
        |> Decode.map (\fn -> fn Nothing Nothing)
