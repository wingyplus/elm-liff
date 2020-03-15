port module Liff exposing
    ( Message(..)
    , Reply(..)
    , Url(..)
    , UserProfile
    , closeWindow
    , getAccessToken
    , getLanguage
    , getProfile
    , getVersion
    , isLoggedIn
    , openWindow
    , sendMessages
    , subscription
    )

import Json.Decode as D
import Json.Encode as E



-- PORTS


port liffOutbound : ( String, E.Value ) -> Cmd msg


port liffInbound : (( String, D.Value ) -> msg) -> Sub msg



-- SUBSCRIPTION


{-| A reply from liff inbound port.
-}
type Reply
    = -- It's returns value from liff.getAccessToken().
      GetAccessTokenReply String
      -- It's returns value from liff.getLanguage().
    | GetLanguageReply String
      -- It's returns value from liff.getProfile().
    | GetProfileReply UserProfile
      -- It's returns value from liff.getVersion().
    | GetVersionReply String
      -- It's returns value from liff.isLoggedIn().
    | IsLoggedInReply Bool
      -- It's an error when something is wrong such as cannot
      -- decode json, liff has an error, etc.
    | ErrorReply String
      -- It's returns value when receive something unexpected from
      -- inbound port.
    | NoopReply


{-| A subscription for LIFF app.
-}
subscription : (Reply -> msg) -> Sub msg
subscription f =
    liffInbound <|
        \evt ->
            case evt of
                ( "getAccessToken", data ) ->
                    case D.decodeValue D.string data of
                        Ok token ->
                            f <| GetAccessTokenReply token

                        Err err ->
                            f <| ErrorReply <| D.errorToString err

                ( "getLanguage", data ) ->
                    case D.decodeValue D.string data of
                        Ok lang ->
                            f <| GetLanguageReply lang

                        Err err ->
                            f <| ErrorReply <| D.errorToString err

                ( "getProfile", data ) ->
                    case D.decodeValue decodeUserProfile data of
                        Ok profile ->
                            f <| GetProfileReply profile

                        Err err ->
                            f <| ErrorReply <| D.errorToString err

                ( "getVersion", data ) ->
                    case D.decodeValue D.string data of
                        Ok v ->
                            f <| GetVersionReply v

                        Err err ->
                            f <| ErrorReply <| D.errorToString err

                ( "isLoggedIn", data ) ->
                    case D.decodeValue D.bool data of
                        Ok b ->
                            f <| IsLoggedInReply b

                        Err err ->
                            f <| ErrorReply <| D.errorToString err

                _ ->
                    f NoopReply



-- LIFF


{-| Closes the LIFF app.
-}
closeWindow : Cmd msg
closeWindow =
    liffOutbound ( "closeWindow", E.null )


{-| Gets the current user's access token.
-}
getAccessToken : Cmd msg
getAccessToken =
    liffOutbound ( "getAccessToken", E.null )


{-| Gets the language settings of the environment in which the LIFF app is running.
-}
getLanguage : Cmd msg
getLanguage =
    liffOutbound ( "getLanguage", E.null )


{-| Gets the current user's profile.
-}
getProfile : Cmd msg
getProfile =
    liffOutbound ( "getProfile", E.null )


{-| Gets the version of the LIFF SDK.
-}
getVersion : Cmd msg
getVersion =
    liffOutbound ( "getVersion", E.null )


{-| Checks whether the user is logged in.
-}
isLoggedIn : Cmd msg
isLoggedIn =
    liffOutbound ( "isLoggedIn", E.null )


{-| Opens the specified URL in the in-app browser of LINE or external browser.
-}
openWindow : Url -> Cmd msg
openWindow url =
    liffOutbound ( "openWindow", encodeUrl url )


{-| Sends messages on behalf of the user to the chat screen where the LIFF
app is opened. If the LIFF app is opened on a screen other than the
chat screen, messages cannot be sent.
-}
sendMessages : List Message -> Cmd msg
sendMessages msgs =
    liffOutbound ( "sendMessages", encodeMessages msgs )


{-| TODO(wingyplus): implements it
-}
shareTargetPicker =
    Cmd.none



-- URL


{-| An url object for LIFF app.
-}
type Url
    = -- An url for open within LIFF app.
      Internal String
      -- An url for open in external browser.
    | External String


encodeUrl : Url -> E.Value
encodeUrl url =
    case url of
        Internal u ->
            E.object
                [ ( "url", E.string u )
                , ( "external", E.bool False )
                ]

        External u ->
            E.object
                [ ( "url", E.string u )
                , ( "external", E.bool True )
                ]



-- PROFILE


{-| LINE user profile.
-}
type alias UserProfile =
    { userId : String
    , displayName : String
    , pictureUrl : String
    , statusMessage : Maybe String
    }


decodeUserProfile : D.Decoder UserProfile
decodeUserProfile =
    D.map4 UserProfile
        (D.field "userId" D.string)
        (D.field "displayName" D.string)
        (D.field "pictureUrl" D.string)
        (D.maybe (D.field "statusMessage" D.string))



-- MESSAGE


{-| Available messages that can be uses in LIFF app.

TODO(wingyplus): implements template message.
TODO(wingyplus): implements flex message.

-}
type Message
    = TextMessage String
    | ImageMessage { originalContentUrl : String, previewImageUrl : String }
    | VideoMessage { originalContentUrl : String, previewImageUrl : String }
    | AudioMessage { originalContentUrl : String, duration : Int }
    | LocationMessage { title : String, address : String, latitude : Float, longitude : Float }


{-| Transform list of Message into json object.
-}
encodeMessages : List Message -> E.Value
encodeMessages msgs =
    E.list E.object <| List.map encodeMessage msgs


{-| Transform Message into json object.
-}
encodeMessage : Message -> List ( String, E.Value )
encodeMessage msg =
    case msg of
        TextMessage text ->
            [ ( "type", E.string "text" )
            , ( "text", E.string text )
            ]

        ImageMessage img ->
            [ ( "type", E.string "image" )
            , ( "originalContentUrl", E.string img.originalContentUrl )
            , ( "previewImageUrl", E.string img.previewImageUrl )
            ]

        VideoMessage video ->
            [ ( "type", E.string "video" )
            , ( "originalContentUrl", E.string video.originalContentUrl )
            , ( "previewImageUrl", E.string video.previewImageUrl )
            ]

        AudioMessage audio ->
            [ ( "type", E.string "audio" )
            , ( "originalContentUrl", E.string audio.originalContentUrl )
            , ( "duration", E.int audio.duration )
            ]

        LocationMessage location ->
            [ ( "type", E.string "location" )
            , ( "title", E.string location.title )
            , ( "address", E.string location.address )
            , ( "latitude", E.float location.latitude )
            , ( "longitude", E.float location.longitude )
            ]
