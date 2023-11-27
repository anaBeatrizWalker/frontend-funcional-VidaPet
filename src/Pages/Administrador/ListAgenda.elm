module Pages.Administrador.ListAgenda exposing (..)

import Browser
import Html exposing (Html)
import Element exposing (..)
import Element.Border as Border
import Element.Background as Background
import RemoteData exposing (WebData)

import Components.MenuAdm exposing (menuLayout)
import Components.Header exposing (headerLayout)
import Components.Table exposing (tableHeader, tableData)
import Components.Buttons exposing (editButtonTable, deleteItemButton)
import Utils.Colors exposing (blue4, lightBlue4, gray1, gray2)

import Server.Agenda exposing(..)
import Server.ServerUtils exposing (..)

type alias Model = 
  {
    agenda : WebData (List Agendamento)
    , deleteError : Maybe String
  }

init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, getAgendamentos )


initialModel : Model
initialModel =
    { agenda = RemoteData.Loading
    , deleteError = Nothing
    }

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetAllAgendamentos ->
            ( { model | agenda = RemoteData.Loading }, getAgendamentos )

        AgendamentoReceived response ->
            ( { model | agenda = response }, Cmd.none )

        DeleteAgendamento id ->
            (model, delAgendamento id)

        AgendamentoDeleted (Ok _) ->
          (model, getAgendamentos)

        AgendamentoDeleted (Err error) -> 
          ( { model | deleteError = Just (buildErrorMessage error) }, Cmd.none )

        _ -> 
          (model, Cmd.none)


view : Model -> Html Msg
view model = 
  Element.layout [] <|
    row [ width fill, height fill] 
      [
        el [ width (px 200), height fill, Background.color blue4 ]
          (menuLayout "./../../../assets/administradora.jpg" lightBlue4)
      , el [ width fill, height fill ]
          (column [ width fill, height fill, padding 50, centerX, centerY, spacing 30, Background.color gray1 ] 
            [ 
              headerLayout blue4 lightBlue4 "Lista de Agendamentos" "Novo agendamento" "http://localhost:8000/adm/agenda/novo"
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