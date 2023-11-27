module Server.Agenda exposing (..)

import Html exposing (Html.form, div, input, br, text, button)
import Html.Attributes exposing (type_, value)
import Http
import Json.Decode as Decode
import Json.Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required)
import RemoteData exposing (WebData)
import Server.Funcionario exposing (Funcionario, funcionarioDecoder)
import Server.Cliente exposing (Animal, animalDecoder)
import Server.Cliente exposing (ClieId, clieIdToString, Cliente, clienteDecoder)
import Server.Funcionario exposing (FuncId, funcIdToString)
import Server.Agenda as Agenda
import Html
import Html.Events exposing (onInput, onClick)

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
    | UpdateNomeFuncionarioFromAgenda String
    | UpdateEmailFuncionarioFromAgenda String
    | UpdateObservacao String
    | UpdateCpfAtendenteFromAgenda String
    | UpdateNomeServicoFromAgenda String
    | UpdatePrecoServicoFromAgenda String
    | UpdateDataAgendamento String
    | UpdateHorarioAgendamento String
    | UpdateNomeAnimalFromAgenda String
    | UpdateEspecieAnimalFromAgenda String
    | UpdateRacaAnimalFromAgenda String
    | UpdateSexoAnimalFromAgenda String
    | UpdateDataNascimentoFromAgenda String
    | UpdatePorteAnimalFromAgenda String
    | UpdatePelagemAnimalFromAgenda String
    | UpdatePesoAnimalFromAgenda String
    | SaveAgendamento
    | AgendaSaved (Result Http.Error Agendamento)

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

-- buscando agendamento 
fetchAgendamento : AgenId -> Cmd Msg
fetchAgendamento agenId =
    Http.get 
        { url = "https://vidapet-backend.herokuapp.com/agenda/" ++ Agenda.agenIdToString agenId
        , expect =
            list agendaDecoder 
                |> Http.expectJson (RemoteData.fromResult >> AgendamentoReceived)
        }

editAgendamento : Agendamento -> Html Msg
editAgendamento agenda = 
    Html.form []
        [ div []
            [ text "Informações do Funcionário"
            , br [] []
            , div []
                [ text "Nome do Funcionário"
            , br [] []
            , input
                [ type_ "text"
                , value agenda.funcionario.nome
                , onInput UpdateNomeFuncionarioFromAgenda
                ]
                []
            , br [] []
            , div []
                [ text "E-mail"
                , br [] []
                , input 
                    [ type_ "text"
                    ,  value agenda.funcionario.email
                    , onInput UpdateEmailFuncionarioFromAgenda
                    ]
                    []
                ]
            , br [] []
            , div []
                [ text "CPF"
                , br [] []
                , input 
                    [ type_ "text"
                    , value agenda.funcionario.cpf
                    , onInput UpdateCpfAtendenteFromAgenda
                    ]
                    []
                ]
            ]
            ]
        , br [] []
        , div []
            [ text "Informações do Serviço"
            , br [] []
            , div []
                [ text "Nome do Serviço"
                , br [] []
                , input 
                    [ type_ "text"
                    , value agenda.funcionario.servico.nome
                    , onInput UpdateNomeServicoFromAgenda
                    ]
                    []
                ]
            , br [] []
            , div [] 
                [ text "Valor do serviço"
                , br [] []
                , input 
                    [ type_ "text"
                    , value agenda.funcionario.servico.preco
                    , onInput UpdatePrecoServicoFromAgenda
                    ]
                    []
                ]
            ]
        , br [] []
        , div []
            [ text "Observação"
            , br [] []
            , input 
                [ type_ "text"
                , value agenda.observacao
                , onInput UpdateObservacao
                ]
                []
            ]
        , br [] []
        , div []
            [ text "Informações de Agendamento"
            , br [] []
            , div []
                [ text "Dia do Agendamento"
                , br [] []
                , input
                    [ type_ "text"
                    , value agenda.data
                    , onInput UpdateDataAgendamento
                    ]
                    []
                ]
            , div []
                [ text "Horário do Agendamento"
                , br [] []
                , input 
                    [ type_ "text"
                    , value agenda.horario
                    , onInput UpdateHorarioAgendamento
                    ]
                    []
                ]
            ]
        , br [] []
        , div []
            [ text "Informações do Animal"
            , br [] []
            , div []
                [ text "Nome do Animal"
                , br [] []
                , input 
                    [ type_ "text"
                    , value agenda.animal.nome
                    , onInput UpdateNomeAnimalFromAgenda
                    ]
                    []
                ]
            , div []
                [ text "Espécie"
                , br [] []
                , input 
                    [ type_ "text"
                    , value agenda.animal.especie
                    , onInput UpdateEspecieAnimalFromAgenda
                    ]
                    []
                ]
            , div []
                [ text "Raça"
                , br [] []
                , input 
                    [ type_ "text"
                    , value agenda.animal.raca
                    , onInput UpdateRacaAnimalFromAgenda
                    ]
                    []
                ]
            , div []
                [ text "Sexo"
                , br [] []
                , input 
                    [ type_ "text"
                    , value agenda.animal.sexo
                    , onInput UpdateSexoAnimalFromAgenda
                    ]
                    []
                ]
            , div []
                [ text "Data de Nascimento"
                , br [] []
                , input 
                    [ type_ "text"
                    , value agenda.animal.dataDeNascimento
                    , onInput UpdateDataNascimentoFromAgenda
                    ]
                    []
                ]
            , div []
                [ text "Porte"
                , br [] []
                , input 
                    [ type_ "text"
                    , value agenda.animal.porte
                    , onInput UpdatePorteAnimalFromAgenda
                    ]
                    []
                ]
            , div []
                [ text "Pelagem"
                , br [] []
                , input 
                    [ type_ "text"
                    , value agenda.animal.pelagem
                    , onInput UpdatePelagemAnimalFromAgenda
                    ]
                    []
                ]
            , div []
                [ text "Peso"
                , br [] []
                , input 
                    [ type_ "number"
                    , value agenda.animal.peso
                    , onInput UpdatePesoAnimalFromAgenda
                    ]
                    []
                ]
            ]
        , div []
            [ button [ type_ "button", onClick SaveAgendamento ]
                [ text "Atualizar Agendamento" ]
            ]  
        ]