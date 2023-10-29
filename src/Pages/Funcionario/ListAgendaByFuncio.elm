module Pages.Funcionario.ListAgendaByFuncio exposing (..)

import Html exposing (Html)
import Element exposing (..)
import Element.Border as Border
import Element.Background as Background
import RemoteData exposing (WebData)
import Browser.Navigation as Nav

import Components.MenuFuncionario exposing (menuLayout)
import Components.Header exposing (headerLayout)
import Components.Table exposing (tableHeader, tableData)
import Components.Buttons exposing (editButtonTable, deleteItemButton)
import Utils.Colors exposing (blue2, lightBlue2, gray1, gray1, gray2)

import Server.Agenda exposing(..)
import Server.Funcionario exposing(FuncId, Funcionario)
import Server.ServerUtils exposing (..)

type alias Model = 
  {
    navKey : Nav.Key
    , funcionario : WebData Funcionario
    , agenda : WebData (List Agendamento)
    , deleteError : Maybe String
  }

init : FuncId -> Nav.Key -> ( Model, Cmd Msg )
init funcId navKey =
    ( initialModel navKey, getAgendamentosByFuncionarioId funcId )


getFuncionarioByIdAndAgendamentos : FuncId -> Cmd Msg
getFuncionarioByIdAndAgendamentos funcId =
    Cmd.batch
        [ getFuncionarioById funcId
        , getAgendamentosByFuncionarioId funcId
        ]

initialModel : Nav.Key -> Model
initialModel navKey =
    { navKey = navKey
    , funcionario = RemoteData.Loading
    , agenda = RemoteData.Loading
    , deleteError = Nothing
    }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetFuncionarioById id ->
            ( {model | funcionario = RemoteData.Loading}, getFuncionarioById id )

        FuncionarioByIdReceived response ->
            ( {model | funcionario = response}, Cmd.none )

        GetAgendamentosByFuncionarioId id ->
            ( { model | agenda = RemoteData.Loading }, getAgendamentosByFuncionarioId id )

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
        el [ width (px 200), height fill, Background.color blue2 ]
          (menuLayout "./../../../assets/funcionaria.jpg" lightBlue2)
    , el [ width fill, height fill ] --Corpo
        (column [ width fill, height fill, padding 50, centerX, centerY, spacing 30, Background.color gray1 ] 
          [ 
            headerLayout blue2 lightBlue2 "Agendamentos" "" --Cabeçalho
            , viewDataOrError model
            , viewDeleteError model.deleteError
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
            viewAgendaTable agenda

        RemoteData.Failure httpError ->
            viewError (buildErrorMessage httpError)

viewAgendaTable : List Agendamento -> Element Msg
viewAgendaTable agenda =
    Element.table [ Background.color gray1, Border.color gray2 ]
    { 
      data = agenda
      , columns =
          [ { header = tableHeader "Nome do pet"
              , width = fill
              , view =
                  \a -> tableData a.animal.nome
            }
          , { header = tableHeader "Espécie"
              , width = fill
              , view =
                  \a -> tableData a.animal.especie
            }
          , { header = tableHeader "Raça"
              , width = fill
              , view =
                  \a -> tableData a.animal.raça
          }
          , { header = tableHeader "Sexo"
              , width = fill
              , view =
                  \a -> tableData a.animal.sexo
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
          , { header = tableHeader "Observações"
              , width = fill
              , view = 
                  \a -> tableData a.observacao
          }
          , { header = tableHeader "Ações"
              , width = fill
              , view =
                  \a ->
                  row [ spacing 20, padding 10, Border.color gray2, Border.widthEach {bottom = 0, left = 0, top = 1, right = 0} ] 
                    [
                      column [ centerX ] 
                        [
                          editButtonTable (Nothing)
                        ]
                      , column [ centerX ] 
                        [
                          deleteItemButton (DeleteAgendamento a.id)
                        ]
                    ]
                  
          }
          ]
      }