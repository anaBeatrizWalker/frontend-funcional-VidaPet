module Server.Adm exposing (..)

import Html exposing (..)
import Http
import Json.Decode exposing (Decoder, field, int, list, map5, string)

type alias Administrador = 
    {
        id : Int
        , nome : String
        , email : String
        , cpf : String
        , login : String
    }

type alias Model =
    { adms : List Administrador
    , errorMessage : Maybe String
    }

type Msg
    = SendHttpRequest
    | DataReceived (Result Http.Error (List Administrador))

url : String
url = 
    "https://vidapet-backend.herokuapp.com/adm"

getAdministradores : Cmd Msg
getAdministradores =
    Http.get
        { url = url
        , expect = Http.expectJson DataReceived (list admDecoder)
        }

admDecoder : Decoder Administrador
admDecoder =
    map5 Administrador
        (field "id" int)
        (field "nome" string)
        (field "email" string)
        (field "cpf" string)
        (field "login" string)