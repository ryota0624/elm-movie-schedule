module Model.Review exposing (Review, Describe, Point)


type alias Point =
    Int


type alias Describe =
    String


type alias Review =
    { point : Point
    , describe : Describe
    }
