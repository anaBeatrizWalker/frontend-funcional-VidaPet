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

--Tipos para a tela NewAgendamento
type alias NewFuncionario = 
    {
        id : FuncId
        , nome : String
        , servico : NewServico
    }

type alias NewServico = 
    {
        id : ServId
        , nome : String
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
        |> required "preco" float

funcIdDecoder : Decoder FuncId
funcIdDecoder =
    Decode.map FuncId int

servIdDecoder : Decoder ServId
servIdDecoder =
    Decode.map ServId int

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

stringToFloat : String -> Float
stringToFloat str =
    let
        maybeNum = String.toFloat str
    in
    case maybeNum of
        Just num -> num
        Nothing -> 0.0


--Parser do id da rota (string) para FuncId
funcIdParser : Parser (FuncId -> a) a
funcIdParser =
    custom "FUNCID" <|
        \funcId ->
            Maybe.map FuncId (String.toInt funcId)


funcIdEncoder : FuncId -> Encode.Value
funcIdEncoder (FuncId id) =
    Encode.int id

servIdEncoder : ServId -> Encode.Value
servIdEncoder (ServId id) =
    Encode.int id


--Encoders e Decoders para a tela NewAgendamento
newAgendamentoFuncionarioDecoder : Decoder NewFuncionario
newAgendamentoFuncionarioDecoder = 
    Decode.succeed NewFuncionario
        |> required "id" funcIdDecoder
        |> required "nome" string
        |> required "servico" newAgendamentoServicoDecoder


newAgendamentoFuncionarioEncoder : NewFuncionario -> Encode.Value
newAgendamentoFuncionarioEncoder funcionario =
    Encode.object
        [ ( "id", funcIdEncoder funcionario.id )
        , ( "nome",  Encode.string funcionario.nome )
        -- , ( "email", Encode.string funcionario.email )
        -- , ( "cpf", Encode.string funcionario.cpf )
        -- , ( "perfil", (Encode.list Encode.int) funcionario.perfil )
        -- , ( "login",  Encode.string funcionario.login )
        , ( "servico",  newAgendamentoServicoEncoder funcionario.servico )
        ]

newAgendamentoServicoDecoder : Decoder NewServico
newAgendamentoServicoDecoder = 
    Decode.succeed NewServico
        |> required "id" servIdDecoder
        |> required "nome" string

newAgendamentoServicoEncoder : NewServico -> Encode.Value
newAgendamentoServicoEncoder servico =
    Encode.object
        [ ( "id", servIdEncoder servico.id )
        , ( "nome",  Encode.string servico.nome )
        ]
