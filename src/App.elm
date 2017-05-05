module App exposing (..)

import Dict
import Navigation exposing (Location)
import Routing.Main exposing (Route(ScheduleRoute, MovieRoute), parseLocation)
import Update.Movie exposing (getMovie)
import Update.Schedule exposing (getSchedule)
import Update.Main exposing (Msg(ScheduleMsg, OnLocationChange, MovieMsg, ReceveStr), update, Model)
import View.Main exposing (view)
import View.Movie.MovieReviewComponent as MovieReviewComponent
import Monocle.Lens exposing (Lens, compose)
import Monocle.Optional exposing (Optional, composeLens)
import Monocle.Common exposing ((=>))
import MasterPorts exposing (receivePort)


initialModel : Route -> Model
initialModel route =
    { schedule = Maybe.Nothing
    , route = route
    , movieList = Dict.empty
    , movieReviewComponent = MovieReviewComponent.init
    }


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            parseLocation location

        cmd =
            case currentRoute of
                ScheduleRoute ->
                    Cmd.map ScheduleMsg getSchedule

                MovieRoute id ->
                    Cmd.map MovieMsg (getMovie id Nothing)

                _ ->
                    Cmd.none
    in
        ( initialModel currentRoute, cmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ receivePort ReceveStr ]


main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Writer =
    { name : String
    }


type alias Text =
    String


type alias GoodPoint =
    { text : Text
    }


textOfGoodPoint : Lens GoodPoint Text
textOfGoodPoint =
    let
        get goodPoint =
            goodPoint.text

        set text goodPoint =
            { goodPoint | text = text }
    in
        Lens get set


type alias Story =
    { text : String
    , goodPoint : Maybe GoodPoint
    }


goodPointOfStory : Optional Story GoodPoint
goodPointOfStory =
    let
        get story =
            story.goodPoint

        set goodPoint story =
            { story | goodPoint = Just goodPoint }
    in
        Optional get set


textOfStory : Lens Story String
textOfStory =
    let
        get story =
            story.text

        set text story =
            { story | text = text }
    in
        Lens get set


type alias Movie =
    { name : String
    , story : Maybe Story
    }


nameOfMovie : Lens Movie String
nameOfMovie =
    let
        get movie =
            movie.name

        set name movie =
            { movie | name = name }
    in
        Lens get set


storyOfMovie : Optional Movie Story
storyOfMovie =
    let
        get movie =
            movie.story

        set story movie =
            { movie | story = Just story }
    in
        Optional get set


starwardsSpineOff : Movie
starwardsSpineOff =
    Movie "starwords:SpineOff" (Just <| Story "遠い...未定" Nothing)


a =
    Movie "rogueOne: A star Wars Story" (Just <| Story "遠い...未定" (Just <| GoodPoint "イケてる俳優"))



-- rogueOne : Movie
-- rogueOne =
--     { starwardsSpineOff | name = "rogueOne: A star Wars Story" }
-- rogueOne : Movie
-- rogueOne =
--     { starwardsSpineOff
--         | name = "rogueOne: A star Wars Story"
--         , story = { starwardsSpineOff.story | text = "遠い昔、はるか彼方の銀河系で…。" }
--     }
-- rogueOne : Movie
-- rogueOne =
--     let
--         oldStory =
--             starwardsSpineOff.story
--         newStory =
--             { oldStory | text = "遠い昔、はるか彼方の銀河系で…。" }
--     in
--         { starwardsSpineOff
--             | name = "rogueOne: A star Wars Story"
--             , story = { newStory | text = "遠い昔、はるか彼方の銀河系で…。" }
--         }


rogueOne : Movie
rogueOne =
    starwardsSpineOff
        |> nameOfMovie.set "rogueOne: A star Wars Story"
        >> (composeLens storyOfMovie textOfStory).set "遠い昔、はるか彼方の銀河系で…。"



-- rogueOneGoodPoint : Maybe Text
-- rogueOneGoodPoint =
--     starwardsSpineOff.story
--         |> Maybe.map
--             (\{ goodPoint } ->
--                 goodPoint
--                     |> Maybe.map (\{ text } -> text)
--                     |> Maybe.withDefault Nothing
--             )
--         |> Maybe.withDefault Nothing
-- rogueOneGoodPoint : Maybe Text
-- rogueOneGoodPoint =
--     starwardsSpineOff |> (storyOfMovie => (composeLens goodPointOfStory textOfGoodPoint)).getOption
-- updatedRogueOne : Movie
-- updatedRogueOne =
--     let
--         newGoodPoint : Maybe GoodPoint
--         newGoodPoint =
--             starwardsSpineOff.story
--                 |> Maybe.map
--                     (\story ->
--                         story.goodPoint
--                             |> Maybe.map (\goodPoint -> { goodPoint | text = "かっこいい宇宙戦" })
--                     )
--                 |> Maybe.withDefault Nothing
--         newStory : Maybe Story
--         newStory =
--             starwardsSpineOff.story |> Maybe.map (\story -> { story | goodPoint = newGoodPoint })
--     in
--         { starwardsSpineOff | story = newStory }
-- updatedRogueOne : Movie
-- updatedRogueOne =
--     starwardsSpineOff |> (storyOfMovie => (composeLens goodPointOfStory textOfGoodPoint)).set "かっこいい宇宙戦"
--- MovieからGoodPointのTextをとってくる


movieStoryGoodPointText =
    storyOfMovie => (composeLens goodPointOfStory textOfGoodPoint)


rogueOneGoodPoint : Maybe Text
rogueOneGoodPoint =
    starwardsSpineOff |> movieStoryGoodPointText.getOption


updatedRogueOne : Movie
updatedRogueOne =
    starwardsSpineOff |> movieStoryGoodPointText.set "かっこいい宇宙戦"
