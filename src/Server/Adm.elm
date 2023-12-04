{-module Server.Adm exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required, optional)
import RemoteData exposing (WebData)
import Server.ServerUtils exposing (baseUrlDefault)
-- import Html exposing (..)
-- import Html.Attributes exposing (..)
-- import Html.Events exposing (onInput, onClick)
-- import Server.Atendente exposing (Msg(..))


type AdmId = AdmId Int

type alias Administrador = 
    {
        id : AdmId
        , nome : String
        , email : String
        , cpf : String
        , login : String
    }

type alias Model =
    { adms : WebData (List Administrador) }

type Msg
    = GetAllAdms
    | AdmsReceived (WebData (List Administrador))
    | DeleteAdm AdmId
    | AdmDeleted (Result Http.Error String)
    | UpdateNomeAdm String
    | UpdateEmailAdm String
    | UpdateCPFAdm String
    | UpdateLoginAdm String

baseUrl : String
baseUrl = 
    baseUrlDefault ++ "adm"

getAdministradores : Cmd Msg
getAdministradores =
    Http.get
        { url = baseUrl
        , expect = 
            list admDecoder 
                |> Http.expectJson (RemoteData.fromResult >> AdmsReceived)
        }

--delete
delAdministrador : AdmId -> Cmd Msg
delAdministrador admId = 
    Http.request
        {
            method = "DELETE"
            , headers = []
            , url = (baseUrl ++ "/" ++ idToString admId)
            , body = Http.emptyBody
            , expect = Http.expectString AdmDeleted
            , timeout = Nothing
            , tracker = Nothing
        }

admDecoder : Decoder Administrador
admDecoder =
    Decode.succeed Administrador
       |> required "id" idDecoder
       |> required "nome" string
       |> optional "email" string "-"
       |> optional "cpf" string "-"
       |> optional "login" string "-"

idDecoder : Decoder AdmId
idDecoder =
    Decode.map AdmId int

idToString : AdmId -> String
idToString (AdmId id) =
    String.fromInt id

-}

module Server.Adm exposing
    ( Administrador
    , AdmId
    , emptyAdm
    , idParser
    , idToString
    , newAdmEncoder
    , admDecoder
    , admEncoder
    , admsDecoder
    )

import Json.Decode as Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required, optional)
import Json.Encode as Encode
import Url.Parser exposing (Parser, custom)


type alias Administrador =
    { id : AdmId
    , nome : String
    , email : String
    , documento : String
    }

type AdmId
    = AdmId Int

admsDecoder : Decoder (List Administrador)
admsDecoder =
    list admDecoder

admDecoder : Decoder Administrador
admDecoder =
    Decode.succeed Administrador
        |> required "id" idDecoder
        |> required "nome" string
        |> optional "email" string "-"
        |> optional "documento" string "-"
idDecoder : Decoder AdmId
idDecoder =
    Decode.map AdmId int

idToString : AdmId -> String
idToString (AdmId id) =
    String.fromInt id


idParser : Parser (AdmId -> a) a
idParser =
    custom "ADMINISTRADORID" <|
        \admId ->
            Maybe.map AdmId (String.toInt admId)

admEncoder : Administrador -> Encode.Value
admEncoder adm =
    Encode.object
        [ ( "id", encodeId adm.id )
        , ( "nome", Encode.string adm.nome )
        , ( "email", Encode.string adm.email )
        , ( "documento", Encode.string adm.documento )
        ]

newAdmEncoder : Administrador -> Encode.Value
newAdmEncoder adm =
    Encode.object
        [ ( "nome", Encode.string adm.nome )
        , ( "email", Encode.string adm.email )
        , ( "documento", Encode.string adm.documento )
        ]


encodeId : AdmId-> Encode.Value
encodeId (AdmId id) =
    Encode.int id


emptyAdm : Administrador
emptyAdm =
    { id = emptyAdmId
    , nome = ""
    , email = ""
    , documento = ""
    }


emptyAdmId : AdmId
emptyAdmId =
    AdmId -1
