port module MoviePort exposing (..)

import Movie exposing (Movie)
import Review exposing (Review)
import MovieComponentState exposing (State)


port movie : (Movie -> msg) -> Sub msg


port state : (State -> msg) -> Sub msg


port review : (Review -> msg) -> Sub msg


port onClickBackButton : () -> Cmd back


port onClickPointButton : Review -> Cmd point


port onClickRemoveReviewButton : Review -> Cmd review
