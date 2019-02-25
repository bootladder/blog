module Main exposing (Model, Msg(..), attribute, draw2branches, draw2branches2, drawBranchesOnPoint, drawBranchesOnPoint2, drawBranchesOnPoints, drawBranchesOnPointsForReal, drawBranchesOnPointsForReal2, drawLine, generatePointsFromLambda, init, main, path, svgFractal, svgPostsTitle, text, update, view)

import Browser
import Dice exposing (..)
import Html exposing (Html, button, div, text)
import Html.Attributes
import Html.Events exposing (onClick)
import LogicGates exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    Int


init : Model
init =
    0



-- UPDATE


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "elm-svg" ]
        [ div [ class "dice" ]
            [ svgDie 5
            , svgPostsTitle
            , svgFractal
            ]
        , div [ class "logicgates" ]
            [ svgLogicGates
            ]
        ]


attribute =
    Html.Attributes.attribute


text =
    Svg.text


path =
    Svg.path


svgPostsTitle =
    svg [ attribute "height" "100.00000000000001", attribute "width" "150", attribute "xmlns" "http://www.w3.org/2000/svg", attribute "xmlns:svg" "http://www.w3.org/2000/svg" ]
        [ g []
            [ node "title"
                []
                [ text "Layer 1" ]
            , node "text"
                [ fill "#725b2c", attribute "font-family" "Monospace", attribute "font-size" "24", id "svg_32", attribute "stroke" "#000000", attribute "stroke-dasharray" "null", attribute "stroke-linecap" "null", attribute "stroke-linejoin" "null", attribute "stroke-width" "0", attribute "text-anchor" "middle", attribute "transform" "matrix(2.0224413590676282,0,0,2.0035618577975565,-14.422150537027019,-14.046823513059891) ", attribute "x" "44.28247", attribute "xml:space" "preserve", attribute "y" "39.38394" ]
                [ text "Posts" ]
            ]
        ]


svgFractal : Html Msg
svgFractal =
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
            , drawBranchesOnPoints
            ]
        )


generatePointsFromLambda : (Int -> ( Int, Int )) -> List ( Int, Int )
generatePointsFromLambda f =
    List.map f (List.range 1 12)


drawBranchesOnPoints : List (Svg msg)
drawBranchesOnPoints =
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
            drawBranchesOnPointsForReal myPoints1

        dir2Branches =
            drawBranchesOnPointsForReal myPoints2

        dir3Branches =
            drawBranchesOnPointsForReal myPoints3

        dir4Branches =
            drawBranchesOnPointsForReal myPoints4

        dir5Branches =
            drawBranchesOnPointsForReal2 myPoints5

        dir6Branches =
            drawBranchesOnPointsForReal2 myPoints6

        dir7Branches =
            drawBranchesOnPointsForReal2 myPoints7

        dir8Branches =
            drawBranchesOnPointsForReal2 myPoints8
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


drawBranchesOnPointsForReal : List ( Int, Int ) -> List (Svg msg)
drawBranchesOnPointsForReal points =
    List.concat <| List.map drawBranchesOnPoint points


drawBranchesOnPointsForReal2 : List ( Int, Int ) -> List (Svg msg)
drawBranchesOnPointsForReal2 points =
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
        , stroke "black"
        , strokeWidth "3"
        ]
        []
