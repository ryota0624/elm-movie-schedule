module Model.Movie exposing (Movie, ID, updateBase, decodeMovie, titleOfMovie, storyOfMovie, baseOfMovie, reviewOfMovie)

import Model.Review exposing (Review)
import Json.Decode as Decode
import Model.Schedule exposing (MovieValueObject)
import Monocle.Optional exposing (Optional)
import Monocle.Lens exposing (Lens)


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


titleOfMovie : Lens Movie Title
titleOfMovie =
    let
        get : Movie -> Title
        get movie =
            movie.title

        set : Title -> Movie -> Movie
        set title movie =
            { movie | title = title }
    in
        Lens get set


storyOfMovie : Lens Movie Story
storyOfMovie =
    let
        get movie =
            movie.story

        set story movie =
            { movie | story = story }
    in
        Lens get set


reviewOfMovie : Optional Movie Review
reviewOfMovie =
    let
        getOption movie =
            movie.review

        set review movie =
            { movie | review = Just review }
    in
        Optional getOption set


baseOfMovie : Optional Movie MovieValueObject
baseOfMovie =
    let
        getOption movie =
            movie.base

        set base movie =
            { movie | base = Just base }
    in
        Optional getOption set
