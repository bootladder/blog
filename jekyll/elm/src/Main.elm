module Main exposing (Line, Model, Msg(..), Point, attribute, draw2LinesOnPointReturning2Points, drawLine, drawTreeOnPoints, drawTreeThing, init, main, path, svgPostsTitle, svgTree, text, update, view)

import Browser
import Dice exposing (..)
import Html exposing (Attribute, Html, button, div, input, text)
import Html.Attributes
import Html.Events exposing (onClick, onInput)
import LogicGates exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import XThing exposing (..)


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    Int


init : Model
init =
    50



-- UPDATE


type Msg
    = Increment
    | Decrement
    | Slider String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1

        Slider s ->
            case String.toInt s of
                Nothing ->
                    1

                Just i ->
                    i



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "elm-svg" ]
        [ div [ class "dice" ]
            [ svgDie 5
            , svgPostsTitle
            , svgXThing
            ]
        , div [ class "logicgates" ]
            [ svgLogicGates
            ]
        , div [ class "fractals" ]
            [ svgTree model
            , svgTree model
            , div []
                [ button [ onClick Decrement ] [ text "-" ]
                , div [] [ text (String.fromInt model) ]
                , button [ onClick Increment ] [ text "+" ]
                ]
            , div []
                [ input
                    [ type_ "range"
                    , Html.Attributes.min "0"
                    , Html.Attributes.max "200"
                    , Html.Attributes.value <| String.fromInt model
                    , Html.Events.onInput Slider
                    ]
                    []
                , text <| String.fromInt model
                ]
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


svgTree : Int -> Html Msg
svgTree scale =
    svg
        [ width "120"
        , height "120"
        , viewBox "0 0 420 420"
        , fill "white"
        , stroke "black"
        , strokeWidth "3"
        ]
        (List.concat
            [ [ rect
                    [ x "0"
                    , y "0"
                    , width "420"
                    , height "420"
                    , rx "15"
                    , ry "15"
                    ]
                    []
              ]
            , drawTreeThing scale
            ]
        )


type alias Point =
    { x : Int
    , y : Int
    }


type alias Line =
    { p1 : Point
    , p2 : Point
    , depth : Int
    }


line2Svg : Line -> Svg msg
line2Svg line =
    drawLine line.p1 line.p2 line.depth


reflectLineYAxis : Line -> Line
reflectLineYAxis line =
    let
        p1 =
            Point 0 0

        p2 =
            Point 0 0
    in
    Line p1 p2 10


drawTreeThing : Int -> List (Svg msg)
drawTreeThing scale =
    let
        myLines =
            drawTreeOnPoints [ Point 0 0 ] (toFloat scale * 1 * pi / 16) 10

        rev =
            \line -> Line (Point (420 - line.p1.x) line.p1.y) (Point (420 - line.p2.x) line.p2.y) line.depth

        myLinesReversed =
            List.map rev myLines

        mySvgs =
            List.map line2Svg myLines

        mySvgsReversed =
            List.map line2Svg myLinesReversed
    in
    List.concat [ mySvgs, mySvgsReversed ]


drawTreeOnPoints :
    List Point
    -> Float
    -> Int
    -> List Line
drawTreeOnPoints points angle0 depth =
    case depth of
        0 ->
            []

        thisDepth ->
            let
                process =
                    \x -> draw2LinesOnPointReturning2Points x angle0 depth

                points2LinesAndPoints :
                    List Point
                    -> List ( List Line, List Point )
                points2LinesAndPoints =
                    List.map process

                linesAndPoints : List ( List Line, List Point )
                linesAndPoints =
                    points2LinesAndPoints points

                linesOnly : List Line
                linesOnly =
                    List.concat <|
                        List.map (\x -> Tuple.first x) linesAndPoints

                pointsOnly : List Point
                pointsOnly =
                    List.concat <|
                        List.map (\x -> Tuple.second x) linesAndPoints

                z =
                    drawTreeOnPoints pointsOnly (angle0 * 0.7) (thisDepth - 1)
            in
            linesOnly ++ z


draw2LinesOnPointReturning2Points : Point -> Float -> Int -> ( List Line, List Point )
draw2LinesOnPointReturning2Points point angle depth =
    let
        r =
            round (toFloat (2 ^ depth) / 10)

        newX0 =
            point.x + round (cos angle * toFloat (-1 * 2 * r))

        newY0 =
            point.y + (2 * r)

        newX1 =
            point.x + (2 * r)

        newY1 =
            point.y + (2 * r)
    in
    ( [ Line point (Point newX0 newY0) depth
      , Line point (Point newX1 newY1) depth
      ]
    , [ Point newX0 newY0, Point newX1 newY1 ]
    )


drawLine : Point -> Point -> Int -> Svg msg
drawLine p0 p1 depth =
    let
        width =
            0.1 + ((2.0 ^ toFloat depth) / 200)
    in
    line
        [ x1 <| String.fromInt p0.x
        , y1 <| String.fromInt p0.y
        , x2 <| String.fromInt p1.x
        , y2 <| String.fromInt p1.y
        , stroke "green"
        , strokeWidth <| String.fromFloat width
        ]
        []
