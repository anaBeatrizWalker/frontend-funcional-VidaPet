module Pages.Administrador.ListAdms exposing (..)

import Browser
import Html exposing (..)
import Element exposing (..)
import Element.Font as Font
import Element.Border as Border
import Element.Background as Background
import Utils.Colors exposing (blue4, lightBlue4, gray1, gray2, gray3)
import Components.Menu exposing (menuLayout)
import Components.Header exposing (headerLayout)
import Components.Table exposing (tableHeader, tableData)
import Components.Buttons exposing (editButtonTable, deleteButtonTable)
import Server.Adm exposing (..)
import Server.ServerUtils exposing (..)
import RemoteData exposing (RemoteData, WebData)

type alias Model =
    { adms : WebData (List Administrador) }

init : () -> ( Model, Cmd Msg )
init _ =
    ( { adms = RemoteData.NotAsked }, getAdministradores )


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
        SendHttpRequest ->
            ( { model | adms = RemoteData.Loading }, getAdministradores )

        AdmsReceived response ->
            ( { model | adms = response }, Cmd.none )

view : Model -> Html msg
view model = 
  Element.layout [] <|
    row 
      [ 
        width fill
        , height fill
      ] 
      [
        el --Menu lateral
          [ 
            width (px 200)
            , height fill
            , Background.color blue4
          ]
          (menuLayout "./../../../assets/administradora.jpg" lightBlue4)
      , el --Corpo
          [ 
            width fill
            , height fill
          ]
          (column [ width fill, height fill, padding 50, centerX, centerY, spacing 30, Background.color gray1 ] 
            [ 
              headerLayout blue4 lightBlue4 "Lista de Administradores" --cabeçalho
              , viewDataOrError model --tabela (ou erro de requisição de dados)
            ]
          )
      ]

viewDataOrError : Model -> Element msg
viewDataOrError model =
    case model.adms of
        RemoteData.NotAsked -> 
            Element.text ""

        RemoteData.Loading -> 
            Element.el [ width fill, height fill, Background.color gray1 ] 
            (
              row [ centerX, centerY, Background.color gray3, Border.rounded 10, padding 30 ] 
                [
                  Element.textColumn [ spacing 10, padding 10 ]
                    [ paragraph [ Font.bold ] 
                        [ Element.text "Carregando dados..."]
                    ]
                ]
            )

        RemoteData.Success adms ->
            viewTableAdms adms

        RemoteData.Failure httpError ->
            viewError (buildErrorMessage httpError)

viewTableAdms : List Administrador -> Element msg
viewTableAdms adms = 
    Element.table [ Background.color gray1, Border.color gray2 ]
    { 
      data = adms
      , columns =
          [ { header = tableHeader "ID"
              , width = fill
              , view =
                  \adm -> tableData (String.fromInt adm.id)
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
                  \_ ->
                  row [ spacing 20, padding 10, Border.color gray2, Border.widthEach {bottom = 0, left = 0, top = 1, right = 0} ] 
                    [
                      column [ centerX ] 
                        [
                          editButtonTable (Nothing) ----EditAdm adm.id
                        ]
                      , column [ centerX ] 
                        [
                          deleteButtonTable (Nothing) --DeleteAdm adm.id
                        ]
                    ]
                  
          }
          ]
      }