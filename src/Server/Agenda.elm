module Server.Agenda exposing (..)


import Http
import Json.Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required)
import Json.Decode as Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode
import RemoteData exposing (WebData)

import Server.Funcionario exposing (Funcionario, funcionarioDecoder, FuncId(..), ServId(..), funcIdToString, NewFuncionario, newFuncionarioDecoder, funcionarioEncoder)
import Server.Cliente exposing (AnimId(..), Animal, animalDecoder, ClieId, clieIdToString, Cliente, clienteDecoder)
import Server.ServerUtils exposing (baseUrlDefault)

type AgenId = AgenId Int

type alias Agendamento = 
    {
        id : AgenId
        , funcionario : Funcionario
        , observacao : String
        , data : String
        , horario : String
        , animal : Animal
    }

--Novo tipo para a tela NewAgendamento
type alias NewAgendamento = 
    {
        id : AgenId
        , funcionario : NewFuncionario
        , observacao : String
        , data : String
        , horario : String
        , animal : Animal
    }

type alias Model =
    { agenda : WebData (List Agendamento) }

type Msg
    = GetAllAgendamentos
    | AgendamentoReceived (WebData (List Agendamento))
    | GetClienteById ClieId
    | ClienteByIdReceived (WebData (Cliente))
    | GetAgendamentosByClienteId ClieId
    | GetFuncionarioById FuncId
    | FuncionarioByIdReceived (WebData (Funcionario))
    | GetAgendamentosByFuncionarioId FuncId
    | DeleteAgendamento AgenId
    | AgendamentoDeleted (Result Http.Error String)

baseUrl : String
baseUrl = 
    baseUrlDefault ++ "agenda"

getAgendamentos : Cmd Msg
getAgendamentos =
    Http.get
        { url = baseUrl
        , expect = 
            list agendaDecoder 
                |> Http.expectJson (RemoteData.fromResult >> AgendamentoReceived)
        }

getClienteById : ClieId -> Cmd Msg
getClienteById id =
    Http.get
        { url = (baseUrlDefault ++ "clientes/" ++ clieIdToString id)
        , expect = 
            clienteDecoder 
                |> Http.expectJson (RemoteData.fromResult >> ClienteByIdReceived)
        }

getAgendamentosByClienteId : ClieId -> Cmd Msg
getAgendamentosByClienteId clieId =
    Http.get
        { url =  (baseUrl ++ "/cliente/agenda/" ++ clieIdToString clieId)
        , expect = 
            list agendaDecoder 
                |> Http.expectJson (RemoteData.fromResult >> AgendamentoReceived)
        }

getFuncionarioById : FuncId -> Cmd Msg
getFuncionarioById funcId = 
    Http.get
        { url = (baseUrlDefault ++ "funcionarios/" ++ funcIdToString funcId)
        , expect = 
            clienteDecoder 
                |> Http.expectJson (RemoteData.fromResult >> ClienteByIdReceived)
        }

getAgendamentosByFuncionarioId : FuncId -> Cmd Msg
getAgendamentosByFuncionarioId funcId =
    Http.get
        { url =  (baseUrl ++ "/funcionario/agenda/" ++ funcIdToString funcId)
        , expect = 
            list agendaDecoder 
                |> Http.expectJson (RemoteData.fromResult >> AgendamentoReceived)
        }

delAgendamento : AgenId -> Cmd Msg
delAgendamento id = 
    Http.request
        {
            method = "DELETE"
            , headers = []
            , url = (baseUrl ++ "/" ++ agenIdToString id)
            , body = Http.emptyBody
            , expect = Http.expectString AgendamentoDeleted
            , timeout = Nothing
            , tracker = Nothing
        }

agendaDecoder : Decoder Agendamento
agendaDecoder =
    Decode.succeed Agendamento 
        |> required "id" agenIdDecoder
        |> required "funcionario" funcionarioDecoder
        |> required "observacao" string
        |> required "data" string
        |> required "horario" string
        |> required "animal" animalDecoder

agenIdDecoder : Decoder AgenId
agenIdDecoder =
    Decode.map AgenId int

agenIdToString : AgenId -> String
agenIdToString (AgenId id) =
    String.fromInt id

agendIdEncoder : AgenId -> Encode.Value
agendIdEncoder (AgenId id) =
    Encode.int id

animalEncoder : Animal -> Encode.Value
animalEncoder animal =
    Encode.object
        [ ( "id", animIdEncoder animal.id )
        , ( "nome",  Encode.string animal.nome )
        , ( "especie", Encode.string animal.especie )
        , ( "raca", Encode.string animal.raca )
        , ( "sexo", Encode.string animal.sexo )
        , ( "dataDeNascimento", Encode.string animal.dataDeNascimento )
        , ( "porte", Encode.string animal.porte )
        , ( "pelagem", Encode.string animal.pelagem )
        , ( "peso", Encode.float animal.peso )
        ]

animIdEncoder : AnimId -> Encode.Value
animIdEncoder (AnimId id) =
    Encode.int id


--Encoders e Decoders para a tela NewAgendamento
newAgendaDecoder : Decoder NewAgendamento
newAgendaDecoder =
    Decode.succeed NewAgendamento 
        |> required "id" agenIdDecoder
        |> required "funcionario" newFuncionarioDecoder
        |> required "observacao" string
        |> required "data" string
        |> required "horario" string
        |> required "animal" animalDecoder

newAgendEncoder : NewAgendamento -> Encode.Value
newAgendEncoder agendamento =
    Encode.object
        [ ( "funcionario",  funcionarioEncoder agendamento.funcionario )
        , ( "observacao", Encode.string agendamento.observacao )
        , ( "data", Encode.string agendamento.data )
        , ( "horario", Encode.string agendamento.horario )
        , ( "animal", animalEncoder agendamento.animal )
        ]

--Valores default para a tela NewAgendamento        
emptyAgendamento : NewAgendamento
emptyAgendamento =
    { id = emptyAgendamentoId
    , funcionario = emptyFuncionario
    , observacao = ""
    , data = ""
    , horario = ""
    , animal = 
      {
         id = emptyAnimalId
        , nome = ""
        , especie = ""
        , raca = ""
        , sexo = ""
        , dataDeNascimento = ""
        , porte = ""
        , pelagem = ""
        , peso = 0.0
      }
    }

emptyFuncionario : NewFuncionario
emptyFuncionario =
 {
    id = emptyFuncionarioId
    , nome = ""
    , servico = 
      { 
        id = emptyServicoId
      , nome = "" 
      , preco = 0.0
      }
    }

emptyAgendamentoId : AgenId
emptyAgendamentoId =
    AgenId -1

emptyFuncionarioId : FuncId
emptyFuncionarioId =
    FuncId -1

emptyServicoId : ServId
emptyServicoId =
    ServId -1

emptyAnimalId : AnimId
emptyAnimalId =
    AnimId -1