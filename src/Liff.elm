port module Liff exposing (Event, Message(..), inbound, isLoggedIn, sendMessages)

import Json.Encode as E



-- PORTS


{-| A protocol to communication over ports.
-}
type alias Event =
    { method : String
    , data : E.Value
    }


port outbound : Event -> Cmd msg


port inbound : (Event -> msg) -> Sub msg



-- PUBLIC


{-| Available messages in LIFF application.

TODO(wingyplus): implements flex message.

-}
type Message
    = TextMessage String
    | ImageMessage { originalContentUrl : String, previewImageUrl : String }
    | VideoMessage { originalContentUrl : String, previewImageUrl : String }
    | AudioMessage { originalContentUrl : String, duration : Int }
    | LocationMessage { title : String, address : String, latitude : Float, longitude : Float }


{-| Send messages into LIFF.
-}
sendMessages : List Message -> Cmd msg
sendMessages msgs =
    outbound <|
        { method = "sendMessages"
        , data = E.list E.object (List.map transformMessage msgs)
        }


isLoggedIn : Cmd msg
isLoggedIn =
    outbound <|
        { method = "isLoggedIn"
        , data = E.null
        }



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
