module Update.Main exposing (..)

import Update.Schedule as ScheduleUpdate exposing (Msg(UpdateSchedule))
import Update.Movie as MovieUpdate exposing (Msg(StoreMovie), getMovie)
import Routing.Main
import Navigation exposing (Location)
import Routing.Main exposing (parseLocation, Route(MovieRoute))
import Navigation
import View.Movie.MovieReviewComponent as MovieReviewComponent
import Dict
import Monocle.Optional exposing (Optional, composeLens, compose)
import Monocle.Common exposing ((=>))
import Model.Schedule exposing (Schedule, MovieValueObject, movieOfSchedule)
import Model.Movie exposing (Movie)

type alias Model =
    { schedule : ScheduleUpdate.Model
    , route : Route
    , movieList : MovieUpdate.Model
    , movieReviewComponent : MovieReviewComponent.Model
    }


getSch : Model -> ScheduleUpdate.Model
getSch model =
    model.schedule


setSch : ScheduleUpdate.Model -> Model -> Model
setSch sh model =
    { model | schedule = sh }


scheduleOfModel : Optional Model Schedule
scheduleOfModel =
    let
        getOptional model =
            model.schedule

        set schedule model =
            { model | schedule = Just schedule }
    in
        Optional getOptional set


type Msg
    = No
    | ScheduleMsg ScheduleUpdate.Msg
    | OnLocationChange Location
    | MovieMsg MovieUpdate.Msg
    | MovieReview MovieReviewComponent.Msg
    | ReceveStr String
    | ReceiveMovie Movie


movieUpdate = MovieUpdate.update {
  onClickTitle = ReceiveMovie,
  sendReview = (\_ _ -> Debug.log "sendReview" No)
  }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        No ->
            model ! []

        ReceiveMovie movie ->
          let
            f = Debug.log "log" movie
          in
          model ! []

        MovieReview subMsg ->
            let
                ( movieReview, cmd ) =
                    MovieReviewComponent.update subMsg model.movieReviewComponent

                movieList =
                    case subMsg of
                        MovieReviewComponent.SubmitReview id review ->
                            Just (model.movieList |> Dict.update id (Maybe.map (\movie -> { movie | review = Just review })))

                        _ ->
                            Nothing

                subCmd =
                    case subMsg of
                        MovieReviewComponent.SubmitReview id review ->
                            model.movieList
                                |> Dict.get id
                                |> Maybe.map (\movie -> MovieUpdate.storeReview movie review)
                                |> Maybe.withDefault Cmd.none

                        _ ->
                            Cmd.none
            in
                { model | movieReviewComponent = movieReview, movieList = movieList |> Maybe.withDefault model.movieList } ! [ Cmd.map MovieReview cmd, Cmd.map MovieMsg subCmd ]

        OnLocationChange location ->
            onChangeLocation model location

        MovieMsg movieMsg ->
            let
                ( nextModel, callbackResult ) =
                     movieUpdate movieMsg model.movieList
                     |> Tuple.mapFirst (\movieList -> { model | movieList = movieList})

            in
                case callbackResult of
                  Just callbackMsg -> update callbackMsg nextModel
                  Nothing -> nextModel ! []

        ScheduleMsg scheduleMsg ->
            let
                ( schedule, cmd ) =
                    ScheduleUpdate.update scheduleMsg model.schedule
            in
                { model | schedule = schedule } ! [ Cmd.map ScheduleMsg cmd ]

        ReceveStr str ->
            let
                a =
                    Debug.log "Receive" str
            in
                ( model, Cmd.none )


onChangeLocation : Model -> Location -> ( Model, Cmd Msg )
onChangeLocation model location =
    let
        newRoute =
            parseLocation location

        cmd =
            case newRoute of
                MovieRoute id ->
                    let
                        movie =
                            model |> (scheduleOfModel => movieOfSchedule id).getOption
                    in
                        Cmd.map MovieMsg (getMovie id movie)

                _ ->
                    Cmd.none
    in
        { model | route = newRoute } ! [ cmd ]
