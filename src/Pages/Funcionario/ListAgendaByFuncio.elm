module Pages.Funcionario.ListAgendaByFuncio exposing (..)

import Html exposing (Html)
import Element exposing (..)
import Element.Border as Border
import Element.Background as Background
import Element.Font as Font
import RemoteData exposing (WebData)
import Browser.Navigation as Nav

import Components.MenuFuncionario exposing (menuLayout)
import Components.Header exposing (headerLayout)
import Components.Table exposing (tableHeader, tableData)
import Components.Buttons exposing (editButtonTable, deleteItemButton)
import Utils.Colors exposing (blue2, lightBlue2, gray1, gray1, gray2, gray3, white, gray4, black)

import Server.Agenda exposing(..)
import Server.Funcionario exposing(FuncId, Funcionario)
import Server.ServerUtils exposing (..)

type alias Model = 
  {
    navKey : Nav.Key
    , funcionario : WebData Funcionario
    , agenda : WebData (List Agendamento)
    , deleteError : Maybe String
    , idError : Maybe String 
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
    , idError = Nothing
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
            case response of
                RemoteData.Success agenda ->
                    if List.isEmpty agenda then
                        ( { model | idError = Just "Não existe um usuário para o ID e Perfil fornecidos." }, Cmd.none )
                    else
                        ( { model | agenda = response, idError = Nothing }, Cmd.none )

                _ ->
                    ( { model | agenda = response }, Cmd.none )

        -- AgendamentoReceived response ->
        --     ( { model | agenda = response }, Cmd.none )

        DeleteAgendamento id ->
            (model, delAgendamento id)

        AgendamentoDeleted (Err error) -> 
          ( { model | deleteError = Just (buildErrorMessage error) }, Cmd.none )

        _ -> 
          (model, Cmd.none)


view : Model -> Html Msg
view model = 
    case model.idError of
        Just errorMsg ->
          Element.layout [] <|
            Element.el [ width fill, height fill, Background.color gray1 ] (
              row [ centerX, centerY, Background.color gray3, Border.rounded 10, padding 30 ] [
                  Element.textColumn [ spacing 20, padding 10 ]
                      [ paragraph [ Font.bold ] [ Element.text "Ops... parece que você não tem acesso a essa tela!"]
                      , el [ alignLeft ] none
                      , paragraph [] [ Element.text ("Erro: " ++ errorMsg) ]
                      , el [centerX] 
                          (
                            Element.link [ 
                              width (px 215)
                              , padding 20
                              , Background.color black
                              , Border.rounded 10
                              , Element.centerX
                              , Element.centerY
                              , Font.color white
                              , Font.bold
                              , mouseOver [ Background.color gray4 ] 
                              ] 
                              { url = "/login", label = Element.text "Voltar para o login" }
                          )
                      ]
              ]
          )
            

        Nothing -> 
          Element.layout [] <|
            row [ width fill, height fill ] 
              [
                el [ width (px 200), height fill, Background.color blue2 ]
                  (menuLayout "./../../../assets/funcionaria.jpg" lightBlue2)
            , el [ width fill, height fill ] --Corpo
                (column [ width fill, height fill, padding 50, centerX, centerY, spacing 30, Background.color gray1 ] 
                  [ 
                    headerLayout blue2 lightBlue2 "Agenda" "" "/novo" --Cabeçalho
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
                  \a -> tableData a.animal.raca
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