module MovieUpdate exposing (update, Msg(NoMsg, StoreMovie))

import Movie exposing (Movie)
type Msg = NoMsg | StoreMovie Movie

update: Msg -> Maybe Movie -> (Maybe Movie, Cmd Msg)
update msg state = 
  case msg of
    StoreMovie movie -> (Maybe.Just(movie), Cmd.none)
    _ -> (state, Cmd.none)