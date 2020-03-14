port module Liff exposing
    ( Message(..)
    , Reply(..)
    , Url(..)
    , UserProfile
    , closeWindow
    , getProfile
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
    = -- It's returns value from liff.isLoggedIn().
      IsLoggedInReply Bool
      -- It's returns value from liff.getProfile().
    | GetProfileReply UserProfile
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
                ( "isLoggedIn", data ) ->
                    case D.decodeValue D.bool data of
                        Ok b ->
                            f <| IsLoggedInReply b

                        Err err ->
                            f <| ErrorReply <| D.errorToString err

                ( "getProfile", data ) ->
                    case D.decodeValue decodeUserProfile data of
                        Ok profile ->
                            f <| GetProfileReply profile

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


{-| Gets the current user's profile.
-}
getProfile : Cmd msg
getProfile =
    liffOutbound ( "getProfile", E.null )


{-| Checks whether the user is logged in.
-}
isLoggedIn : Cmd msg
isLoggedIn =
    liffOutbound ( "isLoggedIn", E.null )


{-| Opens the specified URL in the in-app browser of LINE or external browser.
-}
openWindow : Url -> Cmd msg
openWindow url =
    let
        params =
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
    in
    liffOutbound ( "openWindow", params )


{-| Sends messages on behalf of the user to the chat screen where the LIFF
app is opened. If the LIFF app is opened on a screen other than the
chat screen, messages cannot be sent.
-}
sendMessages : List Message -> Cmd msg
sendMessages msgs =
    liffOutbound
        ( "sendMessages"
        , E.list E.object <| List.map transformMessage msgs
        )



-- URL


{-| An url object for LIFF app.
-}
type Url
    = -- An url for open within LIFF app.
      Internal String
      -- An url for open in external browser.
    | External String



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


{-| Transform Message into json object.
-}
transformMessage : Message -> List ( String, E.Value )
transformMessage msg =
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
