module ReviewsUpdate exposing (Msg(..), update)

import ReviewsState exposing (State)
import Movie exposing (Movie)
import Review exposing (Review)


type alias Movies =
    List Movie


type alias Reviews =
    List Review


type Msg
    = NoMsg
    | StoreMovies Movies
    | StoreReviews Reviews


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        NoMsg ->
            ( state, Cmd.none )

        StoreMovies movies ->
            ( { state | movies = movies }, Cmd.none )

        StoreReviews reviews ->
            ( { state | reviews = reviews }, Cmd.none )
