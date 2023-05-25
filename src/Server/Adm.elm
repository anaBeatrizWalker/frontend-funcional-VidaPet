module Server.Adm exposing (..)

import Html exposing (..)
import Http
import Json.Decode as Decode
import Json.Decode exposing (Decoder, field, int, list, map5, string)
import RemoteData exposing (WebData)

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

baseUrl : String
baseUrl = 
    "https://vidapet-backend.herokuapp.com/adm"

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
    map5 Administrador
        (field "id" idDecoder)
        (field "nome" string)
        (field "email" string)
        (field "cpf" string)
        (field "login" string)

idDecoder : Decoder AdmId
idDecoder =
    Decode.map AdmId int

idToString : AdmId -> String
idToString (AdmId id) =
    String.fromInt id