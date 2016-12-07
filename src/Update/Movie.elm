module Update.Movie exposing (..)

import Model.Movie as MovieModel exposing (Movie)
import Model.Review as ReviewModel exposing (Review)
import Http
import Model.Schedule exposing (MovieValueObject)
import Dict


type Msg
    = StoreMovie (Result Http.Error Movie)
    | ReviewMovie MovieModel.ID Review
    | None


type alias EditingMovies =
    Dict.Dict String Movie


type alias Movies =
    Dict.Dict String Movie


type alias Model =
    Movies


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            model ! []

        StoreMovie result ->
            case result of
                Ok movie ->
                    Dict.insert movie.id movie model ! []

                Err err ->
                    model ! []

        ReviewMovie id review ->
            (model |> Dict.update id (Maybe.map (\movie -> { movie | review = Just review }))) ! []


editReview : EditingMovies -> MovieModel.ID -> (Review -> Review) -> EditingMovies
editReview editings id fn =
    editings
        |> Dict.update id
            (Maybe.map
                (\movie ->
                    { movie
                        | review =
                            Just
                                (movie.review
                                    |> Maybe.map fn
                                    |> Maybe.withDefault (fn (Review 0 ""))
                                )
                    }
                )
            )


editReviewPoint : EditingMovies -> MovieModel.ID -> Int -> EditingMovies
editReviewPoint editings id point =
    editReview editings id (\review -> { review | point = point })


editReviewDescribe : EditingMovies -> MovieModel.ID -> String -> EditingMovies
editReviewDescribe editings id describe =
    editReview editings id (\review -> { review | describe = describe })


getMovie : MovieModel.ID -> Maybe MovieValueObject -> Cmd Msg
getMovie id movieVo =
    let
        url =
            "/movie/" ++ id
    in
        Http.send (Result.map (MovieModel.updateBase movieVo) >> StoreMovie) (Http.get url MovieModel.decodeMovie)


storeReview : Movie -> Review -> Cmd Msg
storeReview movie review =
    let
        log =
            Debug.log "storeReview:movie" movie

        log2 =
            Debug.log "storeReview:review" review
    in
        Cmd.none
