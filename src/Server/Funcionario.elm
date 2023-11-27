module Server.Funcionario exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode exposing (Decoder, int, list, string, float)
import Json.Decode.Pipeline exposing (required)
import RemoteData exposing (WebData)
import Url.Parser exposing (Parser, custom)

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
        , preco : String
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
    "https://vidapet-backend.herokuapp.com/funcionarios"

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
        |> required "email" string
        |> required "cpf" string
        |> required "perfil" (list int)
        |> required "login" string
        |> required "servico" servicoDecoder

servicoDecoder : Decoder Servico
servicoDecoder = 
    Decode.succeed Servico
        |> required "id" servIdDecoder
        |> required "nome" string
        |> required "preco" string

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

--Parser do id da rota (string) para FuncId
funcIdParser : Parser (FuncId -> a) a
funcIdParser =
    custom "FUNCID" <|
        \funcId ->
            Maybe.map FuncId (String.toInt funcId)