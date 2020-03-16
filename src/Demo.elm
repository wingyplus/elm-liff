port module Demo exposing (main)

import Browser
import Html exposing (Html, button, div, h1, img, input, p, section, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Liff exposing (Message(..))


{-| A LIFF outbound port.
-}
port liffOutbound : Liff.Outbound msg


{-| A LIFF inbound port.
-}
port liffInbound : Liff.Inbound msg


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
    , version : String
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
      , version = ""
      }
    , Cmd.batch
        [ Liff.isLoggedIn liffOutbound
        , Liff.getAccessToken liffOutbound
        , Liff.getLanguage liffOutbound
        , Liff.getVersion liffOutbound
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
            , Liff.sendMessages liffOutbound [ TextMessage model.text ]
            )

        SendLocationMessage ->
            ( model
            , Liff.sendMessages liffOutbound
                [ LocationMessage
                    { title = "my location"
                    , address = "Phahonyothin Rd, Thanon Phaya Thai, Ratchathewi, Bangkok 10400"
                    , latitude = 13.7649136
                    , longitude = 100.5360959
                    }
                ]
            )

        GetProfile ->
            ( model, Liff.getProfile liffOutbound )

        CloseWindow ->
            ( model, Liff.closeWindow liffOutbound )

        OpenWindow ->
            ( model, Liff.openWindow liffOutbound <| Liff.External "https://line.me" )

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

        Liff.GetVersionReply v ->
            ( { model | version = v }, Cmd.none )

        Liff.NoopReply ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Liff.subscription liffInbound LiffReply


view : Model -> Html Msg
view model =
    div []
        [ sectionView "Messages" <|
            [ div []
                [ input [ onInput InputText, value model.text ] []
                , button [ onClick SendTextMessage ] [ text "Send Text" ]
                ]
            , div []
                [ button [ onClick SendLocationMessage ] [ text "Send Location" ]
                ]
            ]
        , sectionView "LIFF properties" <|
            [ p [ style "word-wrap" "break-word" ] [ text ("Version: " ++ model.version) ]
            , p [ style "word-wrap" "break-word" ] [ text ("Language: " ++ model.language) ]
            , p [ style "word-wrap" "break-word" ] [ text ("LoggedIn: " ++ b2s model.isLoggedIn) ]
            ]
        , sectionView "Credentials" <|
            [ p [ style "word-wrap" "break-word" ] [ text ("My access token: " ++ omit model.token) ]
            ]
        , sectionView "Open/Close window" <|
            [ button [ onClick OpenWindow ] [ text "Open Window." ]
            , button [ onClick CloseWindow ] [ text "Closing Window." ]
            ]
        , sectionView "User Profile" <|
            [ button [ onClick GetProfile ] [ text "Get User Profile" ]
            , div []
                [ text <| "User id: " ++ omit model.profile.userId
                ]
            , div []
                [ text <| "Username: " ++ model.profile.displayName
                ]
            , div []
                [ text "Picture profile: "
                , img
                    [ style "width" "50px"
                    , style "height" "50px"
                    , src model.profile.pictureUrl
                    ]
                    []
                ]
            ]
        , div [] [ text model.error ]
        ]


sectionView : String -> List (Html msg) -> Html msg
sectionView title content =
    section
        [ style "border" "black solid 1px"
        , style "padding" "1em"
        , style "margin" "0.5em"
        ]
        [ h1 [ style "font-size" "1em" ] [ text title ]
        , div [] content
        ]


b2s : Bool -> String
b2s b =
    if b then
        "True"

    else
        "False"


omit : String -> String
omit s =
    let
        omitLen =
            String.length s - 5
    in
    String.replace
        (String.slice 5 omitLen s)
        (String.repeat omitLen "*")
        s
