module ScheduleView exposing(view)

import Html exposing (Html, text, table, thead, tbody, th, tr, td, img, div, br)
import Schedule exposing (Schedule)
import Movie exposing (Movie)
import ScheduleUpdate exposing (Msg(NoMsg, ClickMovie, ClickPrevDate, ClickNextDate), State)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import List
import Date
import Date.Extra.Format as Format exposing (format, formatUtc, utcIsoString)

tableHead: Html Msg
tableHead = 
  thead [] [ tr [] [ 
      th [] [ text "id" ],
      th [] [ text "titel" ],
      th [] [ text "poster" ]
  ] ]

tableRow: Movie -> Html Msg
tableRow movie = tr [ onClick <| ClickMovie(movie) ] [
   td [] [ text movie.id],
   td [] [ text movie.title],
   td [] [ img [ src <| "http://www.aeoncinema.com" ++ movie.thumbnailUrl ] []]
  ]

tableBody: Schedule -> Html Msg
tableBody schedule = tbody [] (List.map (\movie -> tableRow(movie)) schedule.movies)

scheduleView: Schedule -> Html Msg
scheduleView model = 
  case model.movies of
    [] -> div [] [text "loading"]
    _  -> table [] [tableHead, tableBody <| model]


dateView: Date.Date -> Html Msg
dateView date = div [] 
  [ 
    div [onClick <| ClickPrevDate date] [text "<"] ,
    div [] [text <| utcIsoString(date)],
    div [onClick <| ClickNextDate date] [text ">"]
  ]


view: State -> Html Msg
view state =
  let
    viewChildren = case state.currentDate of
      Maybe.Just(date) -> [ dateView date, br [] [] ,scheduleView state.schedule ]
      Maybe.Nothing -> []
  in div [] viewChildren
