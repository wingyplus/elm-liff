port module Liff exposing
    ( Action(..)
    , Message(..)
    , UserProfile
    , closeWindow
    , getProfile
    , isLoggedIn
    , receiveAction
    , sendMessages
    )

import Json.Decode as D
import Json.Encode as E



-- PORTS


port liffOutbound : ( String, E.Value ) -> Cmd msg


port liffInbound : (( String, D.Value ) -> msg) -> Sub msg


type Action
    = IsLoggedIn Bool
    | GetProfile UserProfile
    | Error String
    | Nothing


receiveAction : (Action -> msg) -> Sub msg
receiveAction f =
    liffInbound <|
        \evt ->
            case evt of
                ( "isLoggedIn", data ) ->
                    case D.decodeValue D.bool data of
                        Ok b ->
                            f <| IsLoggedIn b

                        Err _ ->
                            f <| IsLoggedIn False

                ( "getProfile", data ) ->
                    case D.decodeValue decoderUserProfile <| Debug.log "user profile" data of
                        Ok profile ->
                            f <| GetProfile profile

                        Err err ->
                            f <| Error <| D.errorToString err

                _ ->
                    f <| Nothing



-- LIFF


{-| Closes the LIFF app.
-}
closeWindow : Cmd msg
closeWindow =
    liffOutbound <| ( "closeWindow", E.null )


{-| Gets the current user's profile.
-}
getProfile : Cmd msg
getProfile =
    liffOutbound <| ( "getProfile", E.null )


{-| Checks whether the user is logged in.
-}
isLoggedIn : Cmd msg
isLoggedIn =
    liffOutbound <|
        ( "isLoggedIn"
        , E.null
        )


{-| Sends messages on behalf of the user to the chat screen where the LIFF
app is opened. If the LIFF app is opened on a screen other than the
chat screen, messages cannot be sent.
-}
sendMessages : List Message -> Cmd msg
sendMessages msgs =
    liffOutbound <|
        ( "sendMessages"
        , E.list E.object (List.map transformMessage msgs)
        )



-- PROFILE


type alias UserProfile =
    { userId : String
    , displayName : String
    , pictureUrl : String
    , statusMessage : Maybe String
    }


decoderUserProfile : D.Decoder UserProfile
decoderUserProfile =
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

        ImageMessage _ ->
            [ ( "type", E.string "image" )

            -- TODO(wingyplus): map image message.
            ]

        VideoMessage _ ->
            [ ( "type", E.string "video" )

            -- TODO(wingyplus): map video message.
            ]

        AudioMessage _ ->
            [ ( "type", E.string "audio" )

            -- TODO(wingyplus): map audio message.
            ]

        LocationMessage location ->
            [ ( "type", E.string "location" )
            , ( "title", E.string location.title )
            , ( "address", E.string location.address )
            , ( "latitude", E.float location.latitude )
            , ( "longitude", E.float location.longitude )
            ]
