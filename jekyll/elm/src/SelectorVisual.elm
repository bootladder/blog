port module SelectorVisual exposing (Model, Msg(..), attribute, decodeValue, init, main, path, percentXPort, subscriptions, svgSelectorVisual, text, update, view)

import Browser
import Dice exposing (..)
import Html exposing (Attribute, Html, button, div, input, text)
import Html.Attributes
import Html.Events exposing (onClick, onInput)
import Json.Decode as Decode
import Json.Encode exposing (Value)
import LogicGates exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import XThing exposing (..)


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- MODEL


type alias Model =
    { index : Int
    , percent : Float
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { index = 50, percent = 90.0 }, Cmd.none )



-- UPDATE


type Msg
    = Increment
    | Decrement
    | Slider String
    | Noop
    | Hover Int Float Float


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )

        Increment ->
            ( { model | index = model.index + 1 }, Cmd.none )

        Decrement ->
            ( { model | index = model.index - 1 }, Cmd.none )

        Slider s ->
            case String.toInt s of
                Nothing ->
                    ( { model | index = 1 }, Cmd.none )

                Just i ->
                    ( { model | index = i }, Cmd.none )

        Hover i x y ->
            ( { model
                | index = i
                , percent = x
              }
            , Cmd.none
            )


port percentXPort : (Value -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    percentXPort decodeValue


decodeValue : Value -> Msg
decodeValue x =
    let
        ( index, error ) =
            case Decode.decodeValue (Decode.field "index" Decode.int) x of
                Ok i ->
                    ( i, False )

                Err _ ->
                    ( 0, True )

        ( decodedPercent, error1 ) =
            case Decode.decodeValue (Decode.field "x" Decode.float) x of
                Ok i ->
                    ( i, False )

                Err _ ->
                    ( 0, True )

        ( decodedY, error2 ) =
            case Decode.decodeValue (Decode.field "y" Decode.float) x of
                Ok i ->
                    ( i, False )

                Err _ ->
                    ( 0, True )
    in
    if error || error1 || error2 then
        Hover 99 (toFloat index) 80.0

    else
        Hover index decodedPercent decodedY



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ svgSelectorVisual model.index model.percent
        ]


svgSelectorVisual : Int -> Float -> Html msg
svgSelectorVisual index percent =
    svg
        [ width "30"
        , height "100%"

        --, viewBox "0 0 420 420"
        , fill "white"
        , stroke "black"
        , strokeWidth "3"
        ]
        (List.concat
            [ [ rect
                    [ x "0"
                    , y "0"
                    , width "100%"
                    , height "100%"
                    , rx "15"
                    , ry "15"
                    ]
                    []
              ]
            , grayedLines index
            , [ verticalLineByPercent index percent True
              , horizontalLine index percent True
              ]
            ]
        )


grayedLines index =
    let
        intsOneTen = List.range 1 index
        --vLine = (\index -> verticalLineByPercent index (toFloat index*10) False)
        vLine = (\i -> verticalLineByPercent i 100.0 False)
    in
    List.map vLine intsOneTen


verticalLineByPercent : Int -> Float -> Bool -> Svg msg
verticalLineByPercent index percent active =
    let
        xPercentString =
            String.fromInt (index*10) ++ "%"
        yPercentString =
            String.fromFloat percent ++ "%"
    in
    line
        [ x1 xPercentString
        , y1 <| String.fromInt 10
        , x2 xPercentString
        , y2 yPercentString
        , stroke <|
            if active then
                "green"

            else
                "gray"
        , strokeWidth <| String.fromFloat 2.0
        ]
        []


horizontalLine : Int -> Float -> Bool -> Svg msg
horizontalLine index percent active =
    let
        xPercentString =
            String.fromInt (index*10) ++ "%"
        yPercentString =
            String.fromFloat percent ++ "%"
    in
    line
        [ x1 xPercentString
        , y1 yPercentString
        , x2 "100%"
        , y2 yPercentString
        , stroke "green"
        , strokeWidth <| String.fromFloat 2.0
        ]
        []


attribute =
    Html.Attributes.attribute


text =
    Svg.text


path =
    Svg.path
