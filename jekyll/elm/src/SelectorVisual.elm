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
    Int


init : () -> ( Model, Cmd Msg )
init _ =
    ( 50, Cmd.none )



-- UPDATE


type Msg
    = Increment
    | Decrement
    | Slider String
    | Noop
    | Hover Int Float Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )

        Increment ->
            ( model + 1, Cmd.none )

        Decrement ->
            ( model - 1, Cmd.none )

        Slider s ->
            case String.toInt s of
                Nothing ->
                    ( 1, Cmd.none )

                Just i ->
                    ( i, Cmd.none )

        Hover index x y ->
            ( index, Cmd.none )


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
            case Decode.decodeValue (Decode.field "xPercent" Decode.float) x of
                Ok i ->
                    ( i, False )

                Err _ ->
                    ( 0, True )

        ( decodedY, error2 ) =
            case Decode.decodeValue (Decode.field "y" Decode.int) x of
                Ok i ->
                    ( i, False )

                Err _ ->
                    ( 0, True )
    in
    if error || error1 || error2 then
        Slider <| String.fromInt index

    else
        Hover index decodedPercent decodedY



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ button [ onClick Decrement ] [ text "-" ]
            , div [] [ text (String.fromInt model) ]
            , button [ onClick Increment ] [ text "+" ]
            , svgSelectorVisual 75.0
            ]
        ]


svgSelectorVisual : Float -> Html msg
svgSelectorVisual percent =
    svg
        [ width "120"
        , height "100%"
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
                    , height "100%"
                    , rx "15"
                    , ry "15"
                    ]
                    []
              ]

            --, drawTreeThing scale
            ]
        )


attribute =
    Html.Attributes.attribute


text =
    Svg.text


path =
    Svg.path
