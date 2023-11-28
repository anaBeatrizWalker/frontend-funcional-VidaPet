module Pages.Atendente.ListAgenda exposing (..)

import Browser
import Html exposing (Html)
import Http 
import Element exposing (..)
import Element.Border as Border
import Element.Background as Background
import RemoteData exposing (WebData)

import Components.MenuAtendente exposing (menuLayout)
import Components.Header exposing (headerLayout)
import Components.Table exposing (tableHeader, tableData)
import Components.Buttons exposing (editButtonTable, deleteItemButton)
import Utils.Colors exposing (blue3, lightBlue3, gray1, gray1, gray2)

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

        -- UpdateNomeFuncionarioFromAgenda newNomeFunc ->
        --   let
        --       updateNomeFuncionarioFromAgenda =
        --         RemoteData.map
        --           (\postData -> 
        --             { postData | nomeFunc = newNomeFunc }
        --           )    
        --           model.agenda
        --   in
        --   ( { model | agenda = updateNomeFuncionarioFromAgenda }, Cmd.none )

        -- UpdateEmailFuncionarioFromAgenda newEmailFunc ->
        --   let 
        --     updateEmailFuncionarioFromAgenda =
        --       RemoteData.map
        --         (\postData ->
        --           { postData | emailFUnc = newEmailFunc }
        --         )
        --         model.agenda
        --   in 
        --   ( { model | agenda = updateEmailFuncionarioFromAgenda }, Cmd.none )

        -- UpdateObservacao newObservacao ->
        --   let
        --     updateObservacao =
        --       RemoteData.map
        --         (\postData ->
        --           { postData | obs = newObservacao }
        --         )    
        --         model.agenda
        --   in
        --   ( { model | agenda = updateObservacao }, Cmd.none )

        -- UpdateCpfAtendenteFromAgenda newCpfFunc ->
        --   let 
        --     updateCpfAtendenteFromAgenda =
        --       RemoteData.map
        --         (\postData ->
        --           { postData | cpfFunc = newCpfFunc }
        --         )
        --         model.agenda

        --   in
        --   ( { model | agenda = updateCpfAtendenteFromAgenda }, Cmd.none )

        -- UpdateNomeServico newNomeServ ->
        --   let 
        --     updateNomeServicoFromAgenda =
        --       RemoteData.map
        --         (\postData -> 
        --           { postData | nomeServ = newNomeServ }
        --         )
        --         model.agenda

        --   in 
        --   ( { model | agenda = updateNomeServicoFromAgenda }, Cmd.none )

        -- UpdatePrecoServicoFromAgenda newPrecoServ ->
        --   let
        --       updatePrecoServicoFromAgenda =
        --         RemoteData.map  
        --           (\postData ->
        --             { postData | newPreco = newPrecoServ }
        --           )
        --           model.agenda

        --   in
        --   ( { model | agenda = updatePrecoServicoFromAgenda }, Cmd.none )

        -- UpdateDataAgendamento newDataAgendamento ->
        --   let
        --       updateDataAgendamento =
        --         RemoteData.map
        --           (\postData ->
        --             { postData | newData = newDataAgendamento}
        --           )
        --           model.agenda
        --   in
        --   ( { model | agenda = updateDataAgendamento }, Cmd.none )

        -- UpdateHorarioAgendamento newHorarioAgendamento ->
        --   let
        --       updateHorarioAgendamento =
        --         RemoteData.map 
        --           (\postData -> 
        --             { postData | newHorario = newHorarioAgendamento }
        --           )
        --           model.agenda
        --   in
        --   ( { model | agenda = updateHorarioAgendamento }, Cmd.none )

        -- UpdateNomeAnimalFromAgenda newNomeAnimal ->
        --   let 
        --     updateNomeAnimalFromAgenda =
        --       RemoteData.map  
        --         (\postData ->
        --           { postData | nomeAnimal = newNomeAnimal  }
        --         )
        --         model.agenda

        --   in
        --   ( { model | agenda = updateNomeAnimalFromAgenda }, Cmd.none )

        -- UpdateEspecieAnimalFromAgenda newEspecie ->
        --   let
        --     updateEspecieAnimalFromAgenda =
        --       RemoteData.map
        --         (\postData ->
        --           { postData | especie = newEspecie }
        --         )
        --         model.agenda
        --   in
        --   ( { model | agenda = updateEspecieAnimalFromAgenda }, Cmd.none )

        -- UpdateRacaAnimalFromAgenda newRaca ->
        --   let
        --     updateRacaAnimalFromAgenda =
        --       RemoteData.map
        --         (\postData ->
        --           { postData | raca = newRaca }
        --         )
        --         model.agenda

        --   in
        --   ( { model | agenda = updateRacaAnimalFromAgenda }, Cmd.none )

        -- UpdateSexoAnimalFromAgenda newSexoAnimal ->
        --   let
        --     updateSexoAnimalFromAgenda =
        --       RemoteData.map
        --         (\postData ->
        --           { postData | sexoAnimal = newSexoAnimal }
        --         )    
        --         model.agenda
        --   in
        --   ( { model | agenda = updateSexoAnimalFromAgenda }, Cmd.none )

        -- UpdateDataNascimentoFromAgenda newDataNasc ->
        --   let
        --     updateDataNascimentoFromAgenda = 
        --       RemoteData.map
        --         (\postData ->
        --           { postData | dataNascAnimal = newDataNasc }
        --         )   
        --         model.agenda
        --   in
        --   ( { model | agenda = updateDataNascimentoFromAgenda }, Cmd.none )

        -- UpdatePorteAnimalFromAgenda newPorteAnimal -> 
        --   let
        --       updatePorteAnimalFromAgenda =
        --         RemoteData.map
        --           (\postData ->
        --             { postData | porteAnimal = newPorteAnimal }
        --           )
        --           model.agenda
        --   in
        --   ( { model | agenda = updatePorteAnimalFromAgenda }, Cmd.none )

        -- UpdatePelagemAnimalFromAgenda newPelagemAnimal ->
        --   let 
        --     updatePelagemAnimalFromAgenda =
        --       RemoteData.map  
        --         (\postData ->
        --           { postData | pelagemAnimal = newPelagemAnimal }
        --         )
        --         model.agenda
        --   in
        --   ( { model | agenda = updatePelagemAnimalFromAgenda }, Cmd.none )

        -- UpdatePesoAnimalFromAgenda newPesoAnimal ->
        --   let
        --       updatePesoAnimalFromAgenda =
        --         RemoteData.map
        --           (\postData ->
        --             { postData | pesoAnimal = newPesoAnimal }
        --           )
        --           model.agenda
        --   in
        --   ( { model | agenda = updatePesoAnimalFromAgenda }, Cmd.none )

        -- SaveAgendamento ->
        --   ( model, saveAgendamento model.agenda )

        -- AgendaSaved (Ok postData) ->
        --   let 
        --     agendamento =
        --       RemoteData.succeed postData
        --   in 
        --   ( { model | agendamento = agendamento, saveError = Nothing }
        --   , Route.matchRoute Route.AllAgenda  
        --   )
        
        -- AgendaSaved (Err error) ->
        --   ( { model | saveError = Just (buildErrorMessage error) }
        --   , Cmd.none  
        --   )

        _ -> 
          (model, Cmd.none)


-- saveAgendamento : WebData Agendamento -> Cmd Msg
-- saveAgendamento agendamento =
--   case agendamento of 
--     RemoteData.Success postData -> 
--       let
--           agendamentoUrl =
--             "https://vidapet-backend.herokuapp.com/agenda/"
--               ++ Agenda.agenIdToString postData.id
--       in
--       Http.request
--         { method = "PATCH"
--         , headers = []
--         , url = agendamentoUrl
--         , body = Http.jsonBody (agendaEncoder postData)
--         , expect = Http.expectJson AgendaSaved agendaDecoder
--         , timeout = Nothing 
--         , tracker = Nothing
--         }


view : Model -> Html Msg
view model = 
  Element.layout [] <|
    row [ width fill, height fill ] 
      [
        el [ width (px 200), height fill, Background.color blue3 ]
          (menuLayout "./../../../assets/atendente.jpg" lightBlue3 )
      , el [ width fill, height fill ]
          (column [ width fill, height fill, padding 50, centerX, centerY, spacing 30, Background.color gray1 ] 
            [ 
              headerLayout blue3 lightBlue3 "Lista de Agendamentos" "Novo agendamento" "http://localhost:8000/atendente/agenda/novo"
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