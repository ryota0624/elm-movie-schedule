module Movie exposing (..)

type alias Movie = 
  { id: String
  , title: String
  , thumbnailUrl: String
  , detailUrl: String
  , story: Maybe String
  }
