module MovieView exposing (view)

import MovieUpdate exposing (update, Msg)
import Html exposing (Html, text, div, br)
import Movie exposing (Movie)

view: Maybe Movie -> Html Msg
view movie = 
  case movie of
    Maybe.Just {title, story} -> div [] [
      text title,
      br [] [],
      text <| Maybe.withDefault "..loading" story
    ]
    Maybe.Nothing -> text "loading"