module Pages.Administrador.ListAdms exposing (..)

import Browser
import Html exposing (..)
import Element exposing (..)
import Element.Border as Border
import Element.Background as Background
import RemoteData exposing (WebData)

import Utils.Colors exposing (blue4, lightBlue4, gray1, gray2)
import Components.MenuAdm exposing (menuLayout)
import Components.Header exposing (headerLayout)
import Components.Table exposing (tableHeader, tableData)
import Components.Buttons exposing (editButtonTable, deleteItemButton)

import Server.Adm exposing (..)
import Server.ServerUtils exposing (..)

type alias Model =
    { adms : WebData (List Administrador)
    , deleteError : Maybe String
    }

init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, getAdministradores )


initialModel : Model
initialModel =
    { adms = RemoteData.Loading
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
        GetAllAdms ->
            ( { model | adms = RemoteData.Loading }, getAdministradores )

        AdmsReceived response ->
            ( { model | adms = response }, Cmd.none )

        DeleteAdm id ->
            (model, delAdministrador id)

        AdmDeleted (Ok _) ->
          (model, getAdministradores)

        AdmDeleted (Err error) -> 
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
              headerLayout blue4 lightBlue4 "Lista de Administradores" "Adicionar adm" "http://localhost:8000/adm/novo"--cabeçalho
              , viewDataOrError model --tabela (ou mensagem de erro na requisição get)
              , viewDeleteError model.deleteError --mensagem de erro na requisição delete
            ]
          )
      ]

viewDataOrError : Model -> Element Msg
viewDataOrError model =
    case model.adms of
        RemoteData.NotAsked -> 
            viewNoAskedMsg

        RemoteData.Loading -> 
            viewLoagindMsg

        RemoteData.Success adms ->
            viewTableAdms adms

        RemoteData.Failure httpError ->
            viewError (buildErrorMessage httpError)

viewTableAdms : List Administrador -> Element Msg
viewTableAdms adms =
    Element.table [ Background.color gray1, Border.color gray2 ]
    { 
      data = adms
      , columns =
          [ { header = tableHeader "ID"
              , width = fill
              , view =
                  \adm -> tableData (idToString adm.id)
            }
          , { header = tableHeader "Login"
              , width = fill
              , view =
                  \adm -> tableData adm.login
            }
          , { header = tableHeader "Nome"
              , width = fill
              , view =
                  \adm -> tableData adm.nome
          }
          , { header = tableHeader "E-mail"
              , width = fill
              , view =
                  \adm -> tableData adm.email
          }
          , { header = tableHeader "CPF"
              , width = fill
              , view = 
                  \adm -> tableData adm.cpf
          }
          , { header = tableHeader "Ações"
              , width = fill
              , view =
                  \adm ->
                  row [ spacing 20, padding 10, Border.color gray2, Border.widthEach {bottom = 0, left = 0, top = 1, right = 0} ] 
                    [
                      column [ centerX ] 
                        [
                          editButtonTable (Nothing)
                        ]
                      , column [ centerX ] 
                        [
                          deleteItemButton (DeleteAdm adm.id)
                        ]
                    ]
                  
          }
          ]
      }