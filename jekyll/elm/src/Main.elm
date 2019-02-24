module Main exposing (Model, Msg(..), attribute, init, main, path, svgCirclesForDieFace, svgDie, svgFractal, svgLogicGates, svgPostsTitle, text, update, view)

import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes
import Html.Events exposing (onClick)
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
            [ svgDie 1
            , svgPostsTitle
            , svgFractal
            ]
        , div [ class "logicgates" ]
            [ svgLogicGates
            ]
        ]


svgDie : Int -> Html Msg
svgDie number =
    svg
        [ width "120", height "120", viewBox "0 0 120 120", fill "white", stroke "black", strokeWidth "3", Html.Attributes.style "padding-left" "20px" ]
        (List.append
            [ rect [ x "1", y "1", width "100", height "100", rx "15", ry "15" ] [] ]
            (svgCirclesForDieFace number)
        )


svgCirclesForDieFace : Int -> List (Svg Msg)
svgCirclesForDieFace dieFace =
    case dieFace of
        1 ->
            [ circle [ cx "50", cy "50", r "10", fill "black" ] [] ]

        2 ->
            [ circle [ cx "25", cy "25", r "10", fill "black" ] []
            , circle [ cx "75", cy "75", r "10", fill "black" ] []
            ]

        3 ->
            [ circle [ cx "25", cy "25", r "10", fill "black" ] []
            , circle [ cx "50", cy "50", r "10", fill "black" ] []
            , circle [ cx "75", cy "75", r "10", fill "black" ] []
            ]

        4 ->
            [ circle [ cx "25", cy "25", r "10", fill "black" ] []
            , circle [ cx "75", cy "25", r "10", fill "black" ] []
            , circle [ cx "25", cy "75", r "10", fill "black" ] []
            , circle [ cx "75", cy "75", r "10", fill "black" ] []
            ]

        5 ->
            [ circle [ cx "25", cy "25", r "10", fill "black" ] []
            , circle [ cx "75", cy "25", r "10", fill "black" ] []
            , circle [ cx "25", cy "75", r "10", fill "black" ] []
            , circle [ cx "75", cy "75", r "10", fill "black" ] []
            , circle [ cx "50", cy "50", r "10", fill "black" ] []
            ]

        6 ->
            [ circle [ cx "25", cy "20", r "10", fill "black" ] []
            , circle [ cx "25", cy "50", r "10", fill "black" ] []
            , circle [ cx "25", cy "80", r "10", fill "black" ] []
            , circle [ cx "75", cy "20", r "10", fill "black" ] []
            , circle [ cx "75", cy "50", r "10", fill "black" ] []
            , circle [ cx "75", cy "80", r "10", fill "black" ] []
            ]

        _ ->
            [ circle [ cx "50", cy "50", r "50", fill "red", stroke "none" ] [] ]


attribute =
    Html.Attributes.attribute


text =
    Svg.text


path =
    Svg.path



--viewBox "0 0 500 200", preserveAspectRatio "none",


svgLogicGates =
    svg [ attribute "height" "100", attribute "width" "100%", attribute "xmlns" "http://www.w3.org/2000/svg", attribute "xmlns:svg" "http://www.w3.org/2000/svg" ]
        [ g []
            [ node "title"
                []
                [ text "Layer 1" ]
            , path [ d "m394.26283,59.503l22.31135,0m-22.31135,-18.10207l22.31136,0.00001m-0.05135,-9.92216l0,37.54016c64.25559,3.36901 65.75202,-41.14977 0,-37.54016zm71.81932,18.70003l-23.20465,0m-73.06626,-9.84033l2.20577,0l0,2.20577l-2.20577,0l0,-2.20577zm-0.10375,17.99695l2.20577,0l0,2.20577l-2.20577,0l0,-2.20577zm96.35067,-9.23291l2.20577,0l0,2.20577l-2.20577,0l0,-2.20577z", fill "#000000", attribute "fill-opacity" "0", id "svg_14", attribute "stroke" "#000000", attribute "stroke-dasharray" "null", attribute "stroke-linecap" "null", attribute "stroke-linejoin" "null", attribute "stroke-width" "5" ]
                []
            , text "  "
            , path [ d "m291.38535,34.8168l19.4688,0m-19.4688,-15.7958l19.4688,0.00001m-0.04481,-8.65804l0,32.7574c56.06918,2.93978 57.37497,-35.90713 0,-32.7574zm62.66927,16.31758l-20.24829,0m-63.75734,-8.58663l1.92475,0l0,1.92475l-1.92475,0l0,-1.92475zm-0.09053,15.70407l1.92475,0l0,1.92475l-1.92475,0l0,-1.92475zm84.07523,-8.0566l1.92475,0l0,1.92475l-1.92475,0l0,-1.92475z", fill "#000000", attribute "fill-opacity" "0", id "svg_15", attribute "stroke" "#000000", attribute "stroke-dasharray" "null", attribute "stroke-linecap" "null", attribute "stroke-linejoin" "null", attribute "stroke-width" "5" ]
                []
            , text "  "
            , path [ d "m291.44204,81.18472l19.92157,0m-19.92156,-16.16314l19.92157,0.00001m-0.04585,-8.85939l0,33.5192c57.37313,3.00815 58.70928,-36.74219 0,-33.5192zm64.12671,16.69706l-20.71918,0m-65.24008,-8.78632l1.96951,0l0,1.96951l-1.96951,0l0,-1.96951zm-0.09264,16.06928l1.96951,0l0,1.96951l-1.96951,0l0,-1.96951zm86.03048,-8.24397l1.96951,0l0,1.96951l-1.96951,0l0,-1.96951z", fill "#000000", attribute "fill-opacity" "0", id "svg_16", attribute "stroke" "#000000", attribute "stroke-dasharray" "null", attribute "stroke-linecap" "null", attribute "stroke-linejoin" "null", attribute "stroke-width" "5" ]
                []
            , text "  "
            , path [ d "m254.95687,80.41517l-15.02723,0m-0.04029,0a4.23773,4.23773 0 1 1 -8.47546,0a4.23773,4.23773 0 1 1 8.47546,0zm-45.60447,0.51264l14.77476,0l0,-13.01263l21.57978,12.45913l-21.56833,12.54087l0,-11.97311m-16.21112,-0.78852l1.44508,0l0,1.44494l-1.44508,0l0,-1.44494zm62.11297,-0.45522l1.44515,0l0,1.44516l-1.44515,0l0,-1.44516z", fill "#000000", attribute "fill-opacity" "0", id "svg_17", attribute "stroke" "#000000", attribute "stroke-dasharray" "null", attribute "stroke-linecap" "null", attribute "stroke-linejoin" "null", attribute "stroke-width" "5" ]
                []
            , text "  "
            , node "line"
                [ fill "none", attribute "fill-opacity" "0", id "svg_18", attribute "stroke" "#000000", attribute "stroke-dasharray" "null", attribute "stroke-linecap" "null", attribute "stroke-linejoin" "null", attribute "stroke-width" "5", attribute "x1" "373", attribute "x2" "392", attribute "y1" "26.8125", attribute "y2" "26.8125" ]
                []
            , text "  "
            , node "line"
                [ fill "none", attribute "fill-opacity" "0", id "svg_19", attribute "stroke" "#000000", attribute "stroke-dasharray" "null", attribute "stroke-linecap" "null", attribute "stroke-linejoin" "null", attribute "stroke-width" "5", attribute "x1" "392", attribute "x2" "392", attribute "y1" "41.8125", attribute "y2" "26.67975" ]
                []
            , text "  "
            , node "line"
                [ fill "none", attribute "fill-opacity" "0", id "svg_20", attribute "stroke" "#000000", attribute "stroke-dasharray" "null", attribute "stroke-linecap" "null", attribute "stroke-linejoin" "null", attribute "stroke-width" "5", attribute "x1" "377", attribute "x2" "394.11724", attribute "y1" "72.8125", attribute "y2" "72.8125" ]
                []
            , text "  "
            , node "line"
                [ fill "none", attribute "fill-opacity" "0", id "svg_21", attribute "stroke" "#000000", attribute "stroke-dasharray" "null", attribute "stroke-linecap" "null", attribute "stroke-linejoin" "null", attribute "stroke-width" "5", attribute "x1" "390", attribute "x2" "390", attribute "y1" "57.8125", attribute "y2" "72.13032" ]
                []
            , text "  "
            , node "line"
                [ fill "none", attribute "fill-opacity" "0", id "svg_22", attribute "stroke" "#000000", attribute "stroke-dasharray" "null", attribute "stroke-linecap" "null", attribute "stroke-linejoin" "null", attribute "stroke-width" "5", attribute "x1" "257", attribute "x2" "291.1321", attribute "y1" "81.8125", attribute "y2" "81.8125" ]
                []
            , text "  "
            , node "line"
                [ fill "none", attribute "fill-opacity" "0", id "svg_23", attribute "stroke" "#000000", attribute "stroke-dasharray" "null", attribute "stroke-linecap" "null", attribute "stroke-linejoin" "null", attribute "stroke-width" "5", attribute "x1" "291", attribute "x2" "55.00001", attribute "y1" "34.8125", attribute "y2" "34.8125" ]
                []
            , text "  "
            , node "line"
                [ fill "none", attribute "fill-opacity" "0", id "svg_24", attribute "stroke" "#000000", attribute "stroke-dasharray" "null", attribute "stroke-linecap" "null", attribute "stroke-linejoin" "null", attribute "stroke-width" "5", attribute "x1" "290", attribute "x2" "15.46831", attribute "y1" "20.8125", attribute "y2" "20.8125" ]
                []
            , text "  "
            , node "line"
                [ fill "none", attribute "fill-opacity" "0", id "svg_25", attribute "stroke" "#000000", attribute "stroke-dasharray" "null", attribute "stroke-linecap" "null", attribute "stroke-linejoin" "null", attribute "stroke-width" "5", attribute "x1" "291", attribute "x2" "89.87987", attribute "y1" "62.8125", attribute "y2" "62.8125" ]
                []
            , text "  "
            , node "line"
                [ fill "none", attribute "fill-opacity" "0", id "svg_26", attribute "stroke" "#000000", attribute "stroke-dasharray" "null", attribute "stroke-linecap" "null", attribute "stroke-linejoin" "null", attribute "stroke-width" "5", attribute "x1" "193", attribute "x2" "125.63532", attribute "y1" "80.8125", attribute "y2" "80.8125" ]
                []
            , text "  "
            , node "line"
                [ fill "none", attribute "fill-opacity" "0", id "svg_28", attribute "stroke" "#000000", attribute "stroke-dasharray" "null", attribute "stroke-linecap" "null", attribute "stroke-linejoin" "null", attribute "stroke-width" "5", attribute "x1" "17", attribute "x2" "17", attribute "y1" "19.8125", attribute "y2" "134.02721" ]
                []
            , text "  "
            , node "line"
                [ fill "none", attribute "fill-opacity" "0", id "svg_29", attribute "stroke" "#000000", attribute "stroke-dasharray" "null", attribute "stroke-linecap" "null", attribute "stroke-linejoin" "null", attribute "stroke-width" "5", attribute "x1" "57", attribute "x2" "57", attribute "y1" "32.8125", attribute "y2" "150.8125" ]
                []
            , text "  "
            , node "line"
                [ fill "none", attribute "fill-opacity" "0", id "svg_30", attribute "stroke" "#000000", attribute "stroke-dasharray" "null", attribute "stroke-linecap" "null", attribute "stroke-linejoin" "null", attribute "stroke-width" "5", attribute "x1" "92", attribute "x2" "92", attribute "y1" "63.8125", attribute "y2" "188.84849" ]
                []
            , text "  "
            , node "line"
                [ fill "none", attribute "fill-opacity" "0", id "svg_31", attribute "stroke" "#000000", attribute "stroke-dasharray" "null", attribute "stroke-linecap" "null", attribute "stroke-linejoin" "null", attribute "stroke-width" "5", attribute "x1" "125", attribute "x2" "125", attribute "y1" "80.8125", attribute "y2" "162.31097" ]
                []
            , text " "
            ]
        ]


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
        , Html.Attributes.style "padding-left" "20px"
        ]
        (List.append
            [ rect
                [ x "0"
                , y "0"
                , width "120"
                , height "120"
                , rx "15"
                , ry "15"
                ]
                []
            , draw2branches 70 70 1 20
            ]
            [ drawLine 20 20 40 40
            , drawLine 40 40 30 50
            , drawLine 30 50 20 20
            , draw2branches 60 60 1 20
            ]
        )


draw2branches : Int -> Int -> Int -> Int -> Svg msg
draw2branches x0 y0 angle r =
    line
        [ x1 <| String.fromInt <| x0
        , y1 <| String.fromInt <| y0 + r
        , x2 <| String.fromInt <| x0 + (2 * r)
        , y2 <| String.fromInt <| y0 + (2 * r)
        , stroke "black"
        , strokeWidth "3"
        ]
        []


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
