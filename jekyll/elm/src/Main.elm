
import Browser
import Dice exposing (..)
import Html exposing (Html, button, div, text)
import Html.Attributes
import Html.Events exposing (onClick)
import LogicGates exposing (..)
import XThing exposing (..)
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
            , svgXThing
            , svgTree
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


svgTree : Html Msg
svgTree =
    svg
        [ width "420"
        , height "420"
        , viewBox "0 0 420 420"
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
            , drawTreeThing
            ]
        )



type alias Point =
    ( Int, Int )


drawTreeThing =
    let
        myPoints = List.map (\x -> (0,20*x)) <| List.range 1 10
        in
            drawTreeOnPoints myPoints pi 10

drawTreeOnPoints :
    List Point
    -> Float
    -> Int
    -> List (Svg msg)
drawTreeOnPoints points angle0 depth =
    case depth of
        0 ->
            []

        thisDepth ->
            let
                process =
                    \x -> draw2LinesOnPointReturning2Points x angle0 depth

                points2LinesAndPoints : List Point -> List ( List (Svg msg), List Point )
                points2LinesAndPoints =
                    List.map process

                linesAndPoints : List ( List (Svg msg), List Point )
                linesAndPoints =
                    points2LinesAndPoints points

                linesOnly : List (Svg msg)
                linesOnly =
                    List.concat <|
                        List.map (\x -> Tuple.first x) linesAndPoints

                pointsOnly : List Point
                pointsOnly =
                    List.concat <|
                        List.map (\x -> Tuple.second x) linesAndPoints

                z = drawTreeOnPoints pointsOnly (angle0*0.7) (thisDepth - 1)
            in
            linesOnly ++ z


draw2LinesOnPointReturning2Points : Point -> Float -> Int -> ( List (Svg msg), List ( Int, Int ) )
draw2LinesOnPointReturning2Points ( x0, y0 ) angle depth =
    let
        r = round (toFloat (2^depth) / 20)
        newX0 =
            x0 + round ((cos angle) * toFloat (-1 * 2 * r))

        newY0 =
            y0 + (2 * r)

        newX1 =
            x0 + (2 * r)

        newY1 =
            y0 + (2 * r)
    in
    ( [ drawLine x0 y0 newX0 newY0 depth
      , drawLine x0 y0 newX1 newY1 depth
      ]
    , [ ( newX0, newY0 ), ( newX1, newY1 ) ]
    )



drawLine : Int -> Int -> Int -> Int -> Int -> Svg msg
drawLine a b c d depth =
    let width = 0.1 + (toFloat (2^depth) / 200)
    in line
        [ x1 <| String.fromInt a
        , y1 <| String.fromInt b
        , x2 <| String.fromInt c
        , y2 <| String.fromInt d
        , stroke "green"
        , strokeWidth <| String.fromFloat width
        ]
        []
