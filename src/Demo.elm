module Demo exposing (main)

import Browser
import Html exposing (Html, button, div, img, input, text)
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
    , profile : Liff.UserProfile
    , error : String
    }


type Msg
    = InputText String
    | SendTextMessage
    | SendLocationMessage
    | CloseWindow
    | GetProfile
    | LiffReply Liff.FuncReply


init : () -> ( Model, Cmd Msg )
init _ =
    ( { text = ""
      , isLoggedIn = False
      , profile =
            { userId = ""
            , displayName = ""
            , pictureUrl = ""
            , statusMessage = Nothing
            }
      , error = ""
      }
    , Liff.isLoggedIn
    )


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

        GetProfile ->
            ( model, Liff.getProfile )

        CloseWindow ->
            ( model, Liff.closeWindow )

        LiffReply inbound ->
            case inbound of
                Liff.IsLoggedInReply loggedIn ->
                    ( { model | isLoggedIn = loggedIn }, Cmd.none )

                Liff.GetProfileReply profile ->
                    ( { model | profile = profile }, Cmd.none )

                Liff.ErrorReply err ->
                    ( { model | error = err }, Cmd.none )

                Liff.NoopReply ->
                    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Liff.reply LiffReply


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
        , div []
            [ button [ onClick GetProfile ] [ text "Get User Profile" ]
            , div []
                [ text "My user id: "
                , text <| omitUserId model.profile.userId
                ]
            , div []
                [ text "My username: "
                , text model.profile.displayName
                ]
            , div []
                [ text "My pictureUrl: "
                , img [ src model.profile.pictureUrl ] []
                ]
            ]
        , div [] [ text model.error ]
        ]


b2s : Bool -> String
b2s b =
    if b then
        "True"

    else
        "False"


omitUserId : String -> String
omitUserId userId =
    String.replace
        (String.slice 5 15 userId)
        (String.repeat 10 "*")
        userId
