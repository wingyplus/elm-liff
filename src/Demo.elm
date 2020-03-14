module Demo exposing (main)

import Browser
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Liff exposing (Message(..))


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { text : String
    , isLoggedIn : Bool
    }


type Msg
    = InputText String
    | SendTextMessage
    | SendLocationMessage
    | CloseWindow
    | LiffAction Liff.Action


init : () -> ( Model, Cmd Msg )
init _ =
    ( { text = "", isLoggedIn = False }, Liff.isLoggedIn )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputText text ->
            ( { model | text = text }, Cmd.none )

        SendTextMessage ->
            ( -- resetting text.
              { model | text = "" }
            , Liff.sendMessages [ TextMessage model.text ]
            )

        SendLocationMessage ->
            ( model
            , Liff.sendMessages
                [ LocationMessage
                    { title = "my location"
                    , address = "Phahonyothin Rd, Thanon Phaya Thai, Ratchathewi, Bangkok 10400"
                    , latitude = 13.7649136
                    , longitude = 100.5360959
                    }
                ]
            )

        CloseWindow ->
            ( model, Liff.closeWindow )

        LiffAction inbound ->
            case inbound of
                Liff.IsLoggedIn loggedIn ->
                    ( { model | isLoggedIn = loggedIn }, Cmd.none )

                Liff.Nothing ->
                    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Liff.receiveAction LiffAction


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ input [ onInput InputText, value model.text ] []
            , button [ onClick SendTextMessage ] [ text "Send Text" ]
            ]
        , div []
            [ button [ onClick SendLocationMessage ] [ text "Send Location" ]
            ]
        , div []
            [ text ("IsLoggedIn? " ++ b2s model.isLoggedIn) ]
        , div []
            [ button [ onClick CloseWindow ] [ text "Closing Window." ] ]
        ]


b2s : Bool -> String
b2s b =
    if b then
        "True"

    else
        "False"
