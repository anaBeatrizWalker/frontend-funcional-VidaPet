module Server.Atendente exposing (..)

import Html exposing (..)
import Http
import Json.Decode as Decode
import Json.Decode exposing (Decoder, field, int, list, map5, string)
import RemoteData exposing (WebData)

type AtenId = AtenId Int

type alias Atendente = 
    {
        id : AtenId
        , nome : String
        , email : String
        , cpf : String
        , login : String
    }

type alias Model =
    { atendentes : WebData (List Atendente) }

type Msg
    = GetAllAtendentes
    | AtendentesReceived (WebData (List Atendente))
    | DeleteAtendente AtenId
    | AtendenteDeleted (Result Http.Error String)

baseUrl : String
baseUrl = 
    "https://vidapet-backend.herokuapp.com/atendentes"

getAtendentes : Cmd Msg
getAtendentes =
    Http.get
        { url = baseUrl
        , expect = 
            list atendenteDecoder 
                |> Http.expectJson (RemoteData.fromResult >> AtendentesReceived)
        }

--delete
delAtendente : AtenId -> Cmd Msg
delAtendente atenId = 
    Http.request
        {
            method = "DELETE"
            , headers = []
            , url = (baseUrl ++ "/" ++ idToString atenId)
            , body = Http.emptyBody
            , expect = Http.expectString AtendenteDeleted
            , timeout = Nothing
            , tracker = Nothing
        }

atendenteDecoder : Decoder Atendente
atendenteDecoder =
    map5 Atendente
        (field "id" idDecoder)
        (field "nome" string)
        (field "email" string)
        (field "cpf" string)
        (field "login" string)

idDecoder : Decoder AtenId
idDecoder =
    Decode.map AtenId int

idToString : AtenId -> String
idToString (AtenId id) =
    String.fromInt id