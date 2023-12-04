module Server.Funcionario exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode exposing (Decoder, int, list, string, float)
import Json.Decode.Pipeline exposing (required)
import RemoteData exposing (WebData)
import Url.Parser exposing (Parser, custom)
import Server.ServerUtils exposing (baseUrlDefault)
import Json.Decode.Pipeline exposing (optional)
import Json.Encode as Encode

type FuncId = FuncId Int
type ServId = ServId Int

type alias Funcionario = 
    {
        id : FuncId
        , nome : String 
        , email : String
        , cpf : String
        , perfil : List Int
        , login : String 
        , servico : Servico
    }

type alias Servico = 
    {
        id : ServId
        , nome : String 
        , preco : Float
    }

type alias Model =
    { funcionarios : WebData (List Funcionario) }

type Msg
    = GetAllFuncionarios
    | FuncionarioReceived (WebData (List Funcionario))
    | DeleteFuncionario FuncId
    | FuncionarioDeleted (Result Http.Error String)

baseUrl : String
baseUrl = 
    baseUrlDefault ++ "funcionarios"

getFuncionarios : Cmd Msg
getFuncionarios =
    Http.get
        { url = baseUrl
        , expect = 
            list funcionarioDecoder 
                |> Http.expectJson (RemoteData.fromResult >> FuncionarioReceived)
        }

delFuncionario : FuncId -> Cmd Msg
delFuncionario id = 
    Http.request
        {
            method = "DELETE"
            , headers = []
            , url = (baseUrl ++ "/" ++ funcIdToString id)
            , body = Http.emptyBody
            , expect = Http.expectString FuncionarioDeleted
            , timeout = Nothing
            , tracker = Nothing
        }

--Decoders
funcionarioDecoder : Decoder Funcionario
funcionarioDecoder = 
    Decode.succeed Funcionario
        |> required "id" funcIdDecoder
        |> required "nome" string
        |> optional "email" string "-"
        |> optional "cpf" string "-"
        |> optional "perfil" (list int) [0]
        |> optional "login" string "-"
        |> required "servico" servicoDecoder

servicoDecoder : Decoder Servico
servicoDecoder = 
    Decode.succeed Servico
        |> required "id" servIdDecoder
        |> required "nome" string
        |> optional "preco" float 0.0

funcIdDecoder : Decoder FuncId
funcIdDecoder =
    Decode.map FuncId int

servIdDecoder : Decoder ServId
servIdDecoder =
    Decode.map ServId int

--Encoders
servicoEncoder : Servico -> Encode.Value
servicoEncoder servico =
    Encode.object
        [ ( "id", servIdEncoder servico.id )
        , ( "nome",  Encode.string servico.nome )
        , ( "preco", Encode.float servico.preco)
        ]

funcIdEncoder : FuncId -> Encode.Value
funcIdEncoder (FuncId id) =
    Encode.int id

servIdEncoder : ServId -> Encode.Value
servIdEncoder (ServId id) =
    Encode.int id

funcIdToString : FuncId -> String
funcIdToString (FuncId id) =
    String.fromInt id

servIdToString : ServId -> String
servIdToString (ServId id) =
    String.fromInt id

stringToFuncId : String -> FuncId
stringToFuncId str =
    let
        maybeId = String.toInt str
    in
    case maybeId of
        Just id -> FuncId id
        Nothing -> FuncId 0

stringToServId : String -> ServId
stringToServId str =
    let
        maybeId = String.toInt str
    in
    case maybeId of
        Just id -> ServId id
        Nothing -> ServId 0


--Parser do id da rota (string) para FuncId
funcIdParser : Parser (FuncId -> a) a
funcIdParser =
    custom "FUNCID" <|
        \funcId ->
            Maybe.map FuncId (String.toInt funcId)

emptyFuncionarioId : FuncId
emptyFuncionarioId =
    FuncId -1

emptyServicoId : ServId
emptyServicoId =
    ServId -1

