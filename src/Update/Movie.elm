module Update.Movie exposing (..)

import Model.Movie as MovieModel exposing (ID, Movie, titleOfMovie, storyOfMovie, baseOfMovie, reviewOfMovie)
import Model.Review as ReviewModel exposing (Review)
import Http
import Model.Schedule exposing (MovieValueObject)
import Dict
import Monocle.Optional exposing (Optional, composeLens)
import Monocle.Common exposing ((=>))


type Msg
    = StoreMovie (Result Http.Error Movie)
    | ReviewMovie MovieModel.ID Review
    | SendMovie Movie
    | None


type alias EditingMovies =
    Dict.Dict String Movie


type alias Movies =
    Dict.Dict String Movie


type alias Model =
    Movies

type alias Callbacks a = {
  onClickTitle : (Movie -> a),
  sendReview : (MovieModel.ID -> Review -> a)
}

movieOfMovies : ID -> Optional Model Movie
movieOfMovies id =
    let
        getOption =
            Dict.get id

        set movie =
            Dict.insert movie.id movie
    in
        Optional getOption set

(==>): a -> b -> (a, b)
(==>) = (,)

update : Callbacks a -> Msg -> Model -> ( Model, Maybe a)
update fn msg model =
    case msg of
        None ->
            model ==> Nothing

        StoreMovie result ->
            case result of
                Ok movie ->
                    ((movieOfMovies movie.id).set movie model ==> Nothing)

                Err err ->
                    model ==> Nothing
        SendMovie movie ->
          model ==> Just (fn.onClickTitle movie)
        ReviewMovie id review ->
            (((movieOfMovies id) => reviewOfMovie).set review model) ==> Just (fn.sendReview id review)


getMovie : MovieModel.ID -> Maybe MovieValueObject -> Cmd Msg
getMovie id movieVo =
    let
        url =
            "/movie/" ++ id

        resultToMovie =
            Maybe.map baseOfMovie.set >> Maybe.withDefault identity
    in
        Http.send (Result.map (resultToMovie movieVo) >> StoreMovie) (Http.get url MovieModel.decodeMovie)


storeReview : Movie -> Review -> Cmd Msg
storeReview movie review =
    let
        log =
            Debug.log "storeReview:movie" movie

        log2 =
            Debug.log "storeReview:review" review
    in
        Cmd.none
