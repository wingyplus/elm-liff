module Demo exposing (main)

import Browser
import Html exposing (Html, button, div, input, text)
import Html.Events exposing (onClick, onInput)
import Json.Decode as D
import Json.Encode as E
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
    { text : String, isLoggedIn : String }


type Msg
    = InputText String
    | SendTextMessage
    | SendLocationMessage
    | LiffAction Liff.Event


init : () -> ( Model, Cmd Msg )
init _ =
    ( { text = "", isLoggedIn = "" }, Liff.isLoggedIn )


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

        LiffAction evt ->
            case evt.method of
                "isLoggedIn" ->
                    ( { model | isLoggedIn = E.encode 0 evt.data }, Cmd.none )

                _ ->
                    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Liff.receiveEvent LiffAction


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ input [ onInput InputText ] [ text model.text ]
            , button [ onClick SendTextMessage ] [ text "Send Text" ]
            ]
        , div []
            [ button [ onClick SendLocationMessage ] [ text "Send Location" ]
            ]
        , div []
            [ text ("IsLoggedIn? " ++ model.isLoggedIn) ]
        ]
