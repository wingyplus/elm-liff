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
    , token : String
    , error : String
    , language : String
    }


type Msg
    = InputText String
    | SendTextMessage
    | SendLocationMessage
    | CloseWindow
    | OpenWindow
    | GetProfile
    | LiffReply Liff.Reply


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
      , token = ""
      , language = ""
      }
    , Cmd.batch
        [ Liff.isLoggedIn
        , Liff.getAccessToken
        , Liff.getLanguage
        ]
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

        OpenWindow ->
            ( model, Liff.openWindow <| Liff.External "https://line.me" )

        LiffReply reply ->
            handleLiffReply reply model


handleLiffReply : Liff.Reply -> Model -> ( Model, Cmd Msg )
handleLiffReply reply model =
    case reply of
        Liff.IsLoggedInReply loggedIn ->
            ( { model | isLoggedIn = loggedIn }, Cmd.none )

        Liff.GetProfileReply profile ->
            ( { model | profile = profile }, Cmd.none )

        Liff.ErrorReply err ->
            ( { model | error = err }, Cmd.none )

        Liff.GetAccessTokenReply token ->
            ( { model | token = token }, Cmd.none )

        Liff.GetLanguageReply lang ->
            ( { model | language = lang }, Cmd.none )

        Liff.NoopReply ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Liff.subscription LiffReply


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
            [ text ("My language: " ++ model.language) ]
        , div []
            [ text ("IsLoggedIn? " ++ b2s model.isLoggedIn) ]
        , div []
            [ text ("My access token: " ++ omitAccessToken model.token) ]
        , div []
            [ button [ onClick CloseWindow ] [ text "Closing Window." ] ]
        , div []
            [ button [ onClick OpenWindow ] [ text "Open Window." ] ]
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


omitAccessToken : String -> String
omitAccessToken userId =
    String.replace
        (String.slice 5 25 userId)
        (String.repeat 20 "*")
        userId
