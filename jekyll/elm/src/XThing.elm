module XThing exposing (..)


import Svg exposing (..)
import Svg.Attributes exposing (..)
import Html.Attributes
import Html

type Msg
    = Noop

attribute =
    Html.Attributes.attribute


text =
    Svg.text


path =
    Svg.path



svgXThing : Html.Html msg
svgXThing =
    svg
        [ width "120"
        , height "120"
        , viewBox "0 0 120 120"
        , fill "white"
        , stroke "black"
        , strokeWidth "3"
        ]
        (List.concat
            [ [ rect
                    [ x "0"
                    , y "0"
                    , width "120"
                    , height "120"
                    , rx "15"
                    , ry "15"
                    ]
                    []
              ]
            , drawXThing
            ]
        )


generatePointsFromLambda : (Int -> ( Int, Int )) -> List ( Int, Int )
generatePointsFromLambda f =
    List.map f (List.range 1 12)


drawXThing : List (Svg msg)
drawXThing =
    let
        myPoints1 =
            generatePointsFromLambda (\x -> ( 10 * x, 10 * x ))

        myPoints2 =
            generatePointsFromLambda (\x -> ( 120 - 10 * x, 10 * x ))

        myPoints3 =
            generatePointsFromLambda (\x -> ( 120 - 10 * x, 60 ))

        myPoints4 =
            generatePointsFromLambda (\x -> ( 60, 120 - 10 * x ))

        myPoints5 =
            generatePointsFromLambda (\x -> ( 10 * x, 10 * x ))

        myPoints6 =
            generatePointsFromLambda (\x -> ( 120 - 10 * x, 10 * x ))

        myPoints7 =
            generatePointsFromLambda (\x -> ( 120 - 10 * x, 60 ))

        myPoints8 =
            generatePointsFromLambda (\x -> ( 60, 120 - 10 * x ))

        dir1Branches : List (Svg msg)
        dir1Branches =
            drawBranchesOnPoints myPoints1

        dir2Branches =
            drawBranchesOnPoints myPoints2

        dir3Branches =
            drawBranchesOnPoints myPoints3

        dir4Branches =
            drawBranchesOnPoints myPoints4

        dir5Branches =
            drawBranchesOnPoints2 myPoints5

        dir6Branches =
            drawBranchesOnPoints2 myPoints6

        dir7Branches =
            drawBranchesOnPoints2 myPoints7

        dir8Branches =
            drawBranchesOnPoints2 myPoints8
    in
    List.concat
        [ dir1Branches
        , dir2Branches
        , dir3Branches
        , dir4Branches
        , dir5Branches
        , dir6Branches
        , dir7Branches
        , dir8Branches
        ]


drawBranchesOnPoints : List ( Int, Int ) -> List (Svg msg)
drawBranchesOnPoints points =
    List.concat <| List.map drawBranchesOnPoint points


drawBranchesOnPoints2 : List ( Int, Int ) -> List (Svg msg)
drawBranchesOnPoints2 points =
    List.concat <| List.map drawBranchesOnPoint2 points


drawBranchesOnPoint : ( Int, Int ) -> List (Svg msg)
drawBranchesOnPoint ( x, y ) =
    draw2branches x y 1 5


drawBranchesOnPoint2 : ( Int, Int ) -> List (Svg msg)
drawBranchesOnPoint2 ( x, y ) =
    draw2branches2 x y 1 5


draw2branches : Int -> Int -> Int -> Int -> List (Svg msg)
draw2branches x0 y0 angle r =
    [ drawLine x0 y0 (x0 + (-1 * 2 * r)) (y0 + (2 * r))
    , drawLine x0 y0 (x0 + (2 * r)) (y0 + (2 * r))
    ]


draw2branches2 : Int -> Int -> Int -> Int -> List (Svg msg)
draw2branches2 x0 y0 angle r =
    [ drawLine x0 y0 (x0 + (-1 * 2 * r)) (y0 - (2 * r))
    , drawLine x0 y0 (x0 + (2 * r)) (y0 - (2 * r))
    ]


drawLine : Int -> Int -> Int -> Int -> Svg msg
drawLine a b c d =
    line
        [ x1 <| String.fromInt a
        , y1 <| String.fromInt b
        , x2 <| String.fromInt c
        , y2 <| String.fromInt d
        , stroke "green"
        , strokeWidth "1"
        ]
        []
