port module Liff exposing
    ( Action(..)
    , Message(..)
    , closeWindow
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
    | Nothing



-- PUBLIC


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

                _ ->
                    f <| Nothing


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


{-| Checks whether the user is logged in.
-}
isLoggedIn : Cmd msg
isLoggedIn =
    liffOutbound <|
        ( "isLoggedIn"
        , E.null
        )


{-| Closes the LIFF app.
-}
closeWindow : Cmd msg
closeWindow =
    liffOutbound <| ( "closeWindow", E.null )



-- PRIVATE


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
