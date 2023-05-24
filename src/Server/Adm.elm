module Server.Adm exposing (..)

import Html exposing (..)
import Http
import Json.Decode exposing (Decoder, field, int, list, map5, string)
import RemoteData exposing (WebData)

type alias Administrador = 
    {
        id : Int
        , nome : String
        , email : String
        , cpf : String
        , login : String
    }

type alias Model =
    { adms : WebData (List Administrador) }

type Msg
    = SendHttpRequest
    | AdmsReceived (WebData (List Administrador))

url : String
url = 
    "https://vidapet-backend.herokuapp.com/adm"

getAdministradores : Cmd Msg
getAdministradores =
    Http.get
        { url = url
        , expect = 
            list admDecoder 
                |> Http.expectJson (RemoteData.fromResult >> AdmsReceived)
        }

admDecoder : Decoder Administrador
admDecoder =
    map5 Administrador
        (field "id" int)
        (field "nome" string)
        (field "email" string)
        (field "cpf" string)
        (field "login" string)