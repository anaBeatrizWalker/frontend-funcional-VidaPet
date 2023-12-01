module Server.Agenda exposing (..)


import Http
import Json.Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required)
import Json.Decode as Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode
import RemoteData exposing (WebData)

import Server.Funcionario exposing (Funcionario, funcionarioDecoder)
import Server.Cliente exposing (Animal, animalDecoder)
import Server.Cliente exposing (ClieId, clieIdToString, Cliente, clienteDecoder)
import Server.Funcionario exposing (FuncId(..), funcIdToString)
import Server.Funcionario exposing (Servico)
import Server.Funcionario exposing (ServId(..))
import Server.Cliente exposing (AnimId(..))
import Server.ServerUtils exposing (baseUrlDefault)
-- import Server.Agenda as Agenda ??
-- import Html exposing (Html.form, div, input, br, text, button)
-- import Html.Attributes exposing (type_, value)
-- import Html.Events exposing (onInput, onClick)

type AgenId = AgenId Int

-- type alias NewAgendamento = 
--     {
--         id : AgenId
--         , funcionario : 
--             {
--                 id : FuncId
--                 , nome : String 
--                 , email : String
--                 , cpf : String
--                 , perfil : List Int
--                 , login : String 
--                 , servico : Servico
--             }
--         , observacao : String
--         , data : String
--         , horario : String
--         , animal : 
--             {
--                 id : AnimId
--                 , nome : String
--                 , especie : String
--                 , raca : String
--                 , sexo : String
--                 , dataDeNascimento : String
--                 , porte : String
--                 , pelagem : String
--                 , peso : Float
--             }
--     }

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

newAgendEncoder : Agendamento -> Encode.Value
newAgendEncoder agendamento =
    Encode.object
        [ ( "funcionario",  funcionarioEncoder agendamento.funcionario )
        , ( "observacao", Encode.string agendamento.observacao )
        , ( "data", Encode.string agendamento.data )
        , ( "horario", Encode.string agendamento.horario )
        , ( "animal", animalEncoder agendamento.animal )
        ]

agendIdEncoder : AgenId -> Encode.Value
agendIdEncoder (AgenId id) =
    Encode.int id

funcionarioEncoder : Funcionario -> Encode.Value
funcionarioEncoder funcionario =
    Encode.object
        [ ( "id", funcIdEncoder funcionario.id )
        , ( "nome",  Encode.string funcionario.nome )
        -- , ( "email", Encode.string funcionario.email )
        -- , ( "cpf", Encode.string funcionario.cpf )
        -- , ( "perfil", (Encode.list Encode.int) funcionario.perfil )
        -- , ( "login",  Encode.string funcionario.login )
        , ( "servico",  servicoEncoder funcionario.servico )
        ]

funcIdEncoder : FuncId -> Encode.Value
funcIdEncoder (FuncId id) =
    Encode.int id

servicoEncoder : Servico -> Encode.Value
servicoEncoder servico =
    Encode.object
        [ ( "id", servIdEncoder servico.id )
        , ( "nome",  Encode.string servico.nome )
        , ( "preco", Encode.float servico.preco )
        ]

servIdEncoder : ServId -> Encode.Value
servIdEncoder (ServId id) =
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

-- buscando agendamento 
fetchAgendamento : AgenId -> Cmd Msg
fetchAgendamento agenId =
    Http.get 
        { url = baseUrlDefault ++ "agenda/" ++ agenIdToString agenId
        , expect =
            list agendaDecoder 
                |> Http.expectJson (RemoteData.fromResult >> AgendamentoReceived)
        }

-- editAgendamento : Agendamento -> Html Msg
-- editAgendamento agenda = 
--     Html.form []
--         [ div []
--             [ text "Informações do Funcionário"
--             , br [] []
--             , div []
--                 [ text "Nome do Funcionário"
--             , br [] []
--             , input
--                 [ type_ "text"
--                 , value agenda.funcionario.nome
--                 , onInput UpdateNomeFuncionarioFromAgenda
--                 ]
--                 []
--             , br [] []
--             , div []
--                 [ text "E-mail"
--                 , br [] []
--                 , input 
--                     [ type_ "text"
--                     ,  value agenda.funcionario.email
--                     , onInput UpdateEmailFuncionarioFromAgenda
--                     ]
--                     []
--                 ]
--             , br [] []
--             , div []
--                 [ text "CPF"
--                 , br [] []
--                 , input 
--                     [ type_ "text"
--                     , value agenda.funcionario.cpf
--                     , onInput UpdateCpfAtendenteFromAgenda
--                     ]
--                     []
--                 ]
--             ]
--             ]
--         , br [] []
--         , div []
--             [ text "Informações do Serviço"
--             , br [] []
--             , div []
--                 [ text "Nome do Serviço"
--                 , br [] []
--                 , input 
--                     [ type_ "text"
--                     , value agenda.funcionario.servico.nome
--                     , onInput UpdateNomeServicoFromAgenda
--                     ]
--                     []
--                 ]
--             , br [] []
--             , div [] 
--                 [ text "Valor do serviço"
--                 , br [] []
--                 , input 
--                     [ type_ "text"
--                     , value agenda.funcionario.servico.preco
--                     , onInput UpdatePrecoServicoFromAgenda
--                     ]
--                     []
--                 ]
--             ]
--         , br [] []
--         , div []
--             [ text "Observação"
--             , br [] []
--             , input 
--                 [ type_ "text"
--                 , value agenda.observacao
--                 , onInput UpdateObservacao
--                 ]
--                 []
--             ]
--         , br [] []
--         , div []
--             [ text "Informações de Agendamento"
--             , br [] []
--             , div []
--                 [ text "Dia do Agendamento"
--                 , br [] []
--                 , input
--                     [ type_ "text"
--                     , value agenda.data
--                     , onInput UpdateDataAgendamento
--                     ]
--                     []
--                 ]
--             , div []
--                 [ text "Horário do Agendamento"
--                 , br [] []
--                 , input 
--                     [ type_ "text"
--                     , value agenda.horario
--                     , onInput UpdateHorarioAgendamento
--                     ]
--                     []
--                 ]
--             ]
--         , br [] []
--         , div []
--             [ text "Informações do Animal"
--             , br [] []
--             , div []
--                 [ text "Nome do Animal"
--                 , br [] []
--                 , input 
--                     [ type_ "text"
--                     , value agenda.animal.nome
--                     , onInput UpdateNomeAnimalFromAgenda
--                     ]
--                     []
--                 ]
--             , div []
--                 [ text "Espécie"
--                 , br [] []
--                 , input 
--                     [ type_ "text"
--                     , value agenda.animal.especie
--                     , onInput UpdateEspecieAnimalFromAgenda
--                     ]
--                     []
--                 ]
--             , div []
--                 [ text "Raça"
--                 , br [] []
--                 , input 
--                     [ type_ "text"
--                     , value agenda.animal.raca
--                     , onInput UpdateRacaAnimalFromAgenda
--                     ]
--                     []
--                 ]
--             , div []
--                 [ text "Sexo"
--                 , br [] []
--                 , input 
--                     [ type_ "text"
--                     , value agenda.animal.sexo
--                     , onInput UpdateSexoAnimalFromAgenda
--                     ]
--                     []
--                 ]
--             , div []
--                 [ text "Data de Nascimento"
--                 , br [] []
--                 , input 
--                     [ type_ "text"
--                     , value agenda.animal.dataDeNascimento
--                     , onInput UpdateDataNascimentoFromAgenda
--                     ]
--                     []
--                 ]
--             , div []
--                 [ text "Porte"
--                 , br [] []
--                 , input 
--                     [ type_ "text"
--                     , value agenda.animal.porte
--                     , onInput UpdatePorteAnimalFromAgenda
--                     ]
--                     []
--                 ]
--             , div []
--                 [ text "Pelagem"
--                 , br [] []
--                 , input 
--                     [ type_ "text"
--                     , value agenda.animal.pelagem
--                     , onInput UpdatePelagemAnimalFromAgenda
--                     ]
--                     []
--                 ]
--             , div []
--                 [ text "Peso"
--                 , br [] []
--                 , input 
--                     [ type_ "number"
--                     , value agenda.animal.peso
--                     , onInput UpdatePesoAnimalFromAgenda
--                     ]
--                     []
--                 ]
--             ]
--         , div []
--             [ button [ type_ "button", onClick SaveAgendamento ]
--                 [ text "Atualizar Agendamento" ]
--             ]  
--         ]