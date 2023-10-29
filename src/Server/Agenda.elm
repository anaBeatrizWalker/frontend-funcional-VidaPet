module Server.Agenda exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required)
import RemoteData exposing (WebData)
import Server.Funcionario exposing (Funcionario, funcionarioDecoder)
import Server.Cliente exposing (Animal, animalDecoder)
import Server.Cliente exposing (ClieId, clieIdToString, Cliente, clienteDecoder)
import Server.Funcionario exposing (FuncId, funcIdToString)


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
    "https://vidapet-backend.herokuapp.com/agenda"

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
        { url = ("https://vidapet-backend.herokuapp.com/clientes/" ++ clieIdToString id)
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
        { url = ("https://vidapet-backend.herokuapp.com/funcionarios/" ++ funcIdToString funcId)
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

--getAgendamentosDia
--getAgendamentosSemana
--getAgendamentosMes

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