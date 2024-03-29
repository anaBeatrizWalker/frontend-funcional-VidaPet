module Pages.Cliente.ListAgenda exposing (..)

import Html exposing (Html)
import Http
import Element exposing (..)
import Element.Border as Border
import Element.Background as Background
import RemoteData exposing (WebData)
import Browser.Navigation as Nav

import Components.MenuCliente exposing (menuLayout)
import Components.Header exposing (headerLayout)
import Components.Table exposing (tableHeader, tableData)
import Components.Buttons exposing (editButtonTable, deleteItemButton)
import Utils.Colors exposing (blue1, lightBlue1, gray1, gray2)

import Server.Agenda exposing(..)
import Server.ServerUtils exposing (..)
import Server.Cliente exposing (Cliente, ClieId)
import Route

type alias Model = 
  {
    navKey : Nav.Key
    , cliente : WebData Cliente
    , agenda : WebData (List Agendamento)
    , deleteError : Maybe String
  }

init : ClieId -> Nav.Key -> ( Model, Cmd Msg )
init clieId navKey =
    ( initialModel navKey, getClienteByIdAndAgendamentos clieId )

getClienteByIdAndAgendamentos : ClieId -> Cmd Msg
getClienteByIdAndAgendamentos clieId =
    Cmd.batch
        [ getClienteById clieId
        , getAgendamentosByClienteId clieId
        ]

initialModel : Nav.Key -> Model
initialModel navKey =
    { navKey = navKey
    , cliente = RemoteData.Loading
    , agenda = RemoteData.Loading
    , deleteError = Nothing
    }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetClienteById id ->
            ({model | cliente = RemoteData.Loading }, getClienteById id) 

        ClienteByIdReceived response -> 
            ( {model | cliente = response}, Cmd.none )

        GetAgendamentosByClienteId id ->
            ({model | agenda = RemoteData.Loading}, getAgendamentosByClienteId id)

        AgendamentoReceived response -> 
            ( { model | agenda = response }, Cmd.none )

        DeleteAgendamento id ->
            (model, delAgendamento id)

        AgendamentoDeleted (Err error) -> 
          ( { model | deleteError = Just (buildErrorMessage error) }, Cmd.none )

        _ ->
          (model, Cmd.none)


view : Model -> Html Msg
view model = 
  Element.layout [] <|
    row [ width fill, height fill ] 
      [
        case model.cliente of
            RemoteData.Success data ->
                el [ width (px 200), height fill, Background.color blue1 ] --Menu lateral
                (menuLayout data.id "./../../../assets/cliente.jpg"  lightBlue1 )

            _ ->
                el [ width (px 200), height fill, Background.color blue1 ] --Carregamento do menu lateral
                    ( none )

      , el [ width fill, height fill ] --Corpo
          (column [ width fill, height fill, padding 50, centerX, centerY, spacing 30, Background.color gray1 ] 
            [ 
              headerLayout blue1 lightBlue1 "Agenda" "Novo agendamento" "http://localhost:8000/cliente/agenda/novo" --cabeçalho
              , viewDataOrError model --tabela (ou mensagem de erro na requisição get)
              , viewDeleteError model.deleteError --mensagem de erro na requisição delete
            ]
          )
      ]

viewDataOrError : Model -> Element Msg
viewDataOrError model =
    case model.agenda of
        RemoteData.NotAsked -> 
            viewNoAskedMsg

        RemoteData.Loading -> 
            viewLoagindMsg

        RemoteData.Success agenda ->
            viewAgenda agenda

        RemoteData.Failure httpError ->
            viewError (buildErrorMessage httpError)

viewAgenda : List Agendamento -> Element Msg
viewAgenda agenda =
    Element.table [ Background.color gray1, Border.color gray2 ]
    { 
      data = agenda
      , columns =
          [ { header = tableHeader "Serviço"
              , width = fill
              , view =
                  \a -> tableData a.funcionario.servico.nome
            }
          , { header = tableHeader "Funcionário"
              , width = fill
              , view =
                  \a -> tableData a.funcionario.nome
            }
          , { header = tableHeader "Observação"
              , width = fill
              , view =
                  \a -> tableData a.observacao
          }
          , { header = tableHeader "Data"
              , width = fill
              , view =
                  \a -> tableData a.data
          }
          , { header = tableHeader "Horário"
              , width = fill
              , view = 
                  \a -> tableData a.horario
          }
          , { header = tableHeader "Pet"
              , width = fill
              , view = 
                  \a -> tableData a.animal.nome
          }
          , { header = tableHeader "Ações"
              , width = fill
              , view =
                  \a ->
                  row [ spacing 20, padding 10, Border.color gray2, Border.widthEach {bottom = 0, left = 0, top = 1, right = 0} ] 
                    [
                      column [ centerX ] 
                        [
                          editButtonTable ""
                        ]
                      , column [ centerX ] 
                        [
                          deleteItemButton (DeleteAgendamento a.id)
                        ]
                    ]
                  
          }
          ]
      }