module Pages.Administrador.ListAtendentes exposing (..)

import Browser
import Html exposing (..)
import Element exposing (..)
import Element.Border as Border
import Element.Background as Background
import Utils.Colors exposing (blue4, lightBlue4, gray1, gray2)
import Components.Menu exposing (menuLayout)
import Components.Header exposing (headerLayout)
import Components.Table exposing (tableHeader, tableData)
import Components.Buttons exposing (editButtonTable, deleteItemButton)
import Server.Atendente exposing (..)
import Server.ServerUtils exposing (..)
import RemoteData exposing (WebData)

type alias Model =
    { atendentes : WebData (List Atendente)
    , deleteError : Maybe String
    }

init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, getAtendentes )


initialModel : Model
initialModel =
    { atendentes = RemoteData.Loading
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
        GetAllAtendentes ->
            ( { model | atendentes = RemoteData.Loading }, getAtendentes )

        AtendentesReceived response ->
            ( { model | atendentes = response }, Cmd.none )

        DeleteAtendente id ->
            (model, delAtendente id)

        AtendenteDeleted (Ok _) ->
          (model, getAtendentes)

        AtendenteDeleted (Err error) -> 
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
              headerLayout blue4 lightBlue4 "Lista de Atendentes" --cabeçalho
              , viewDataOrError model --tabela (ou mensagem de erro na requisição get)
              , viewDeleteError model.deleteError --mensagem de erro na requisição delete
            ]
          )
      ]

viewDataOrError : Model -> Element Msg
viewDataOrError model =
    case model.atendentes of
        RemoteData.NotAsked -> 
            viewNoAskedMsg

        RemoteData.Loading -> 
            viewLoagindMsg

        RemoteData.Success data ->
            viewTableAtendentes data

        RemoteData.Failure httpError ->
            viewError (buildErrorMessage httpError)

viewTableAtendentes : List Atendente -> Element Msg
viewTableAtendentes atendentes =
    Element.table [ Background.color gray1, Border.color gray2 ]
    { 
      data = atendentes
      , columns =
          [ { header = tableHeader "ID"
              , width = fill
              , view =
                  \a -> tableData (idToString a.id)
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
          , { header = tableHeader "CPF"
              , width = fill
              , view = 
                  \a -> tableData a.cpf
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
                          deleteItemButton (DeleteAtendente a.id)
                        ]
                    ]
                  
          }
          ]
      }