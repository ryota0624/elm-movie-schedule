module ScheduleView exposing(view)

import Html exposing (Html, text, table, thead, tbody, th, tr, td, img)
import ScheduleModel exposing (Model, Schedule, Movie)
import ScheduleUpdate exposing (Msg(NoMsg, ClickMovie))
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import List

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

view: Model -> Html Msg
view model = table [] [tableHead, tableBody <| model]
