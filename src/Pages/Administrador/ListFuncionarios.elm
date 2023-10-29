module Pages.Administrador.ListFuncionarios exposing (..)

import Browser
import Html exposing (..)
import Element exposing (..)
import Element.Border as Border
import Element.Background as Background
import Utils.Colors exposing (blue4, lightBlue4, gray1, gray2)
import Pages.Administrador.MenuAdm exposing (menuLayout)
import Components.Header exposing (headerLayout)
import Components.Table exposing (tableHeader, tableData)
import Components.Buttons exposing (editButtonTable, deleteItemButton)
import Server.Funcionario exposing (..)
import Server.ServerUtils exposing (..)
import RemoteData exposing (WebData)

type alias Model =
    { funcionarios : WebData (List Funcionario)
    , deleteError : Maybe String
    }

init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, getFuncionarios )


initialModel : Model
initialModel =
    { funcionarios = RemoteData.Loading
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
        GetAllFuncionarios->
            ( { model | funcionarios = RemoteData.Loading }, getFuncionarios )

        FuncionarioReceived response ->
            ( { model | funcionarios = response }, Cmd.none )

        DeleteFuncionario id ->
            (model, delFuncionario id)

        FuncionarioDeleted (Ok _) ->
          (model, getFuncionarios)

        FuncionarioDeleted (Err error) -> 
          ( { model | deleteError = Just (buildErrorMessage error) }, Cmd.none )

view : Model -> Html Msg
view model = 
  Element.layout [] <|
    row [ width fill, height fill ] 
      [
        el [ width (px 200), height fill, Background.color blue4 ] --Menu lateral
          (menuLayout "./../../../assets/administradora.jpg" lightBlue4)
      , el [ width fill, height fill ] --Corpo
          (column [ width fill, height fill, padding 50, centerX, centerY, spacing 30, Background.color gray1 ] 
            [ 
              headerLayout blue4 lightBlue4 "Lista de Funcionários" "Adicionar funcionário"--cabeçalho
              , viewDataOrError model --tabela (ou mensagem de erro na requisição get)
              , viewDeleteError model.deleteError --mensagem de erro na requisição delete
            ]
          )
      ]

viewDataOrError : Model -> Element Msg
viewDataOrError model =
    case model.funcionarios of
        RemoteData.NotAsked -> 
            viewNoAskedMsg

        RemoteData.Loading -> 
            viewLoagindMsg

        RemoteData.Success data ->
            viewTableFuncionarios data

        RemoteData.Failure httpError ->
            viewError (buildErrorMessage httpError)

viewTableFuncionarios : List Funcionario -> Element Msg
viewTableFuncionarios funcionarios =
    Element.table [ Background.color gray1, Border.color gray2 ]
    { 
      data = funcionarios
      , columns =
          [ { header = tableHeader "ID"
              , width = fill
              , view =
                  \a -> tableData (funcIdToString a.id)
            }
          , { header = tableHeader "Login"
              , width = fill
              , view =
                  \a -> tableData a.login
            }
          , { header = tableHeader "Nome"
              , width = fill
              , view =
                  \a -> tableData a.nome
          }
          , { header = tableHeader "E-mail"
              , width = fill
              , view =
                  \a -> tableData a.email
          }
          , { header = tableHeader "Serviço"
              , width = fill
              , view = 
                  \a -> tableData a.servico.nome
          }
          , { header = tableHeader "Preço"
              , width = fill
              , view = 
                  \a -> tableData (String.fromFloat a.servico.preco)
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
                          deleteItemButton (DeleteFuncionario a.id)
                        ]
                    ]
                  
          }
          ]
      }