module Server.Cliente exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode exposing (Decoder, int, list, string, float)
import Json.Decode.Pipeline exposing (required)
import RemoteData exposing (WebData)
import Url.Parser exposing (Parser, custom)

type ClieId = ClieId Int
type AnimId = AnimId Int

type alias Cliente = 
    {
        id : ClieId
        , nome : String
        , email : String
        , cpf : String
        , telefone : String
        , perfil : List Int
        , login : String
        , animais : List Animal
    }

type alias Animal = 
    {
        id : AnimId
        , nome : String
        , especie : String
        , raca : String
        , sexo : String
        , dataDeNascimento : String
        , porte : String
        , pelagem : String
        , peso : String
    }

type alias Model =
    { clientes : WebData (List Cliente) }

type Msg
    = GetAllClientes
    | ClientesReceived (WebData (List Cliente))
    | DeleteCliente ClieId
    | ClienteDeleted (Result Http.Error String)
    | ClienteByIdReceived (WebData (Cliente))
    | NoOp

baseUrl : String
baseUrl = 
    "https://vidapet-backend.herokuapp.com/clientes"

getClientes : Cmd Msg
getClientes =
    Http.get
        { url = baseUrl
        , expect = 
            list clienteDecoder 
                |> Http.expectJson (RemoteData.fromResult >> ClientesReceived)
        }

getClienteById : ClieId -> Cmd Msg
getClienteById id =
    Http.get
        { url = (baseUrl ++ "/" ++ clieIdToString id)
        , expect = 
            clienteDecoder 
                |> Http.expectJson (RemoteData.fromResult >> ClienteByIdReceived)
        }

delCliente : ClieId -> Cmd Msg
delCliente id = 
    Http.request
        {
            method = "DELETE"
            , headers = []
            , url = (baseUrl ++ "/" ++ clieIdToString id)
            , body = Http.emptyBody
            , expect = Http.expectString ClienteDeleted
            , timeout = Nothing
            , tracker = Nothing
        }

clienteDecoder : Decoder Cliente
clienteDecoder =
    Decode.succeed Cliente 
        |> required "id" clieIdDecoder
        |> required "nome" string
        |> required "email" string
        |> required "cpf" string
        |> required "telefone" string
        |> required "perfil" (list int)
        |> required "login" string
        |> required "animais" (list animalDecoder)

animalDecoder : Decoder Animal
animalDecoder =
    Decode.succeed Animal
        |> required "id" animIdDecoder
        |> required "nome" string
        |> required "especie" string
        |> required "raça" string
        |> required "sexo" string
        |> required "dataDeNascimento" string
        |> required "porte" string
        |> required "pelagem" string
        |> required "peso" string


clieIdDecoder : Decoder ClieId
clieIdDecoder =
    Decode.map ClieId int

animIdDecoder : Decoder AnimId
animIdDecoder =
    Decode.map AnimId int

clieIdToString : ClieId -> String
clieIdToString (ClieId id) =
    String.fromInt id

animIdToString : AnimId -> String
animIdToString (AnimId id) =
    String.fromInt id

--Parser do id da rota (string) para ClieId
clieIdParser : Parser (ClieId -> a) a
clieIdParser =
    custom "CLIEID" <|
        \clieId ->
            Maybe.map ClieId (String.toInt clieId)

-- buscando animal
{-fetchAnimal : AnimId -> Cmd Msg
fetchAnimal clieId = 
    Http.get
        { url = baseUrl
        , expect =
           list animalDecoder 
                |> Http.expectJson (RemoteData.fromResult >> ClientesReceived)
        }
-}