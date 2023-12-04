module Server.Cliente exposing (..)

import Http
import Json.Encode as Encode
import Json.Decode as Decode
import Json.Decode exposing (Decoder, int, list, string, float)
import Json.Decode.Pipeline exposing (required, optional)
import RemoteData exposing (WebData)
import Url.Parser exposing (Parser, custom)
import Server.ServerUtils exposing (baseUrlDefault)


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
        , peso : Float
    }

--Tipo para a tela NewAgendamento
type alias NewAnimal = 
    {
        id : AnimId
        , nome : String
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
    baseUrlDefault ++ "clientes"

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

--Decoders
clienteDecoder : Decoder Cliente
clienteDecoder =
    Decode.succeed Cliente 
        |> required "id" clieIdDecoder
        |> required "nome" string
        |> optional "email" string "-"
        |> optional "documento" string "-"
        |> required "telefone" string
        |> optional "perfil" (list int) [0]
        |> optional "login" string "-"
        |> required "animais" (list animalDecoder)

animalDecoder : Decoder Animal
animalDecoder =
    Decode.succeed Animal
        |> required "id" animIdDecoder
        |> required "nome" string
        |> required "especie" string
        |> optional "raca" string "-"
        |> required "sexo" string
        |> required "dataDeNascimento" string
        |> required "porte" string
        |> required "pelagem" string
        |> required "peso" float

clieIdDecoder : Decoder ClieId
clieIdDecoder =
    Decode.map ClieId int

animIdDecoder : Decoder AnimId
animIdDecoder =
    Decode.map AnimId int

--Encoders
animalEncoder : Animal -> Encode.Value
animalEncoder animal =
    Encode.object
        [ ( "id", animIdEncoder animal.id )
        , ( "nome",  Encode.string animal.nome )
        , ( "especie", Encode.string animal.especie)
        , ( "raca", Encode.string animal.raca)
        , ( "sexo", Encode.string animal.sexo)
        , ( "dataDeNascimento", Encode.string animal.dataDeNascimento)
        , ( "porte", Encode.string animal.porte)
        , ( "pelagem", Encode.string animal.pelagem)
        , ( "peso", Encode.float animal.peso)
        ]
animIdEncoder : AnimId -> Encode.Value
animIdEncoder (AnimId id) =
    Encode.int id

clieIdToString : ClieId -> String
clieIdToString (ClieId id) =
    String.fromInt id

animIdToString : AnimId -> String
animIdToString (AnimId id) =
    String.fromInt id

stringToAnimId : String -> AnimId
stringToAnimId str =
    let
        maybeId = String.toInt str
    in
    case maybeId of
        Just id -> AnimId id
        Nothing -> AnimId 0

--Parser do id da rota (string) para ClieId
clieIdParser : Parser (ClieId -> a) a
clieIdParser =
    custom "CLIEID" <|
        \clieId ->
            Maybe.map ClieId (String.toInt clieId)

emptyAnimal : Animal
emptyAnimal =
    {
        id = emptyAnimalId
        , nome = ""
        , especie = ""
        , raca=""
        , sexo=""
        , dataDeNascimento=""
        , porte=""
        , pelagem=""
        , peso=0
    }
    
emptyAnimalId : AnimId
emptyAnimalId =
    AnimId -1