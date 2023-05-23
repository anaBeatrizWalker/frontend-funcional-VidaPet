module Pages.Administrador.ListAdms exposing (..)

import Browser
import Html exposing (..)
import Element exposing (..)
import Element.Border as Border
import Element.Background as Background
import Utils.Colors exposing (blue4, lightBlue4, gray1, gray2)
import Components.Menu exposing (menuLayout)
import Components.Header exposing (headerLayout)
import Components.Table exposing (tableHeader, tableData)
import Components.Buttons exposing (editButtonTable, deleteButtonTable)
import Server.Adm exposing (..)
import Server.ServerUtils exposing (..)

type alias Model =
    { adms : List Administrador
    , errorMessage : Maybe String
    }

init : () -> ( Model, Cmd Msg )
init _ =
    ( { adms = []
      , errorMessage = Nothing
      }
    , getAdministradores
    )


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
            ( model, getAdministradores )

        DataReceived (Ok adms) ->
            ( { model
                | adms = adms
                , errorMessage = Nothing
              }
            , Cmd.none
            )

        DataReceived (Err httpError) ->
            ( { model
                | errorMessage = Just (buildErrorMessage httpError)
              }
            , Cmd.none
            )

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
              headerLayout blue4 lightBlue4 --cabeçalho
              , viewDataOrError model --tabela (ou erro de requisição de dados)
            ]
          )
      ]

viewDataOrError : Model -> Element msg
viewDataOrError model =
    case model.errorMessage of
        Just message ->
            viewError message

        Nothing ->
            viewTableAdms model.adms

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
                          editButtonTable Nothing
                        ]
                      , column [ centerX ] 
                        [
                          deleteButtonTable Nothing
                        ]
                    ]
                  
          }
          ]
      }