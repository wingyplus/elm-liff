module Demo exposing (main)

import Browser
import Html exposing (Html, button, div, input, text)
import Html.Events exposing (onClick, onInput)
import Liff exposing (Message(..), sendMessages)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    String


type Msg
    = InputText String
    | SendTextMessage
    | SendLocationMessage


init : () -> ( Model, Cmd Msg )
init _ =
    ( "", Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputText text ->
            ( text, Cmd.none )

        SendTextMessage ->
            ( -- resetting text.
              ""
            , sendMessages [ TextMessage model ]
            )

        SendLocationMessage ->
            ( model
            , sendMessages
                [ LocationMessage
                    { title = "my location"
                    , address = "Phahonyothin Rd, Thanon Phaya Thai, Ratchathewi, Bangkok 10400"
                    , latitude = 13.7649136
                    , longitude = 100.5360959
                    }
                ]
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ input [ onInput InputText ] [ text model ]
            , button [ onClick SendTextMessage ] [ text "Send Text" ]
            ]
        , div []
            [ button [ onClick SendLocationMessage ] [ text "Send Location" ]
            ]
        ]
