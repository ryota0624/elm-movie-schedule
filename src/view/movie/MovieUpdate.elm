module MovieUpdate exposing (update, Msg(..))

import MoviePort exposing (..)
import Movie exposing (Movie)
import Review exposing (Review)
import MovieComponentState exposing (State)


type Msg
    = NoMsg
    | StoreMovie Movie
    | ClickBackButton
    | ClickPointButton Int
    | StoreReview Review
    | StoreState State
    | RemoveReview Review


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        StoreMovie movie ->
            ( { state | movie = Maybe.Just movie }, Cmd.none )

        StoreState state ->
            ( state, Cmd.none )

        ClickBackButton ->
            ( state, onClickBackButton () )

        ClickPointButton point ->
            ( state, Maybe.map (\movie -> onClickPointButton <| (Review.create movie.id point)) (state.movie) |> Maybe.withDefault Cmd.none )

        RemoveReview review ->
            ( state, onClickRemoveReviewButton review )

        _ ->
            ( state, Cmd.none )
