module Pages.Administrador.ListClientes exposing (..)

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
import Server.Cliente exposing (..)
import Server.ServerUtils exposing (..)
import RemoteData exposing (WebData)

type alias Model =
    { clientes : WebData (List Cliente)
    , deleteError : Maybe String
    }

init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, getClientes )


initialModel : Model
initialModel =
    { clientes = RemoteData.Loading
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
        GetAllClientes ->
            ( { model | clientes = RemoteData.Loading }, getClientes )

        ClienteReceived response ->
            ( { model | clientes = response }, Cmd.none )

        DeleteCliente id ->
            (model, delCliente id)

        ClienteDeleted (Ok _) ->
          (model, getClientes)

        ClienteDeleted (Err error) -> 
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
              headerLayout blue4 lightBlue4 "Lista de Clientes" --cabeçalho
              , viewDataOrError model --tabela (ou mensagem de erro na requisição get)
              , viewDeleteError model.deleteError --mensagem de erro na requisição delete
            ]
          )
      ]

viewDataOrError : Model -> Element Msg
viewDataOrError model =
    case model.clientes of
        RemoteData.NotAsked -> 
            viewNoAskedMsg

        RemoteData.Loading -> 
            viewLoagindMsg

        RemoteData.Success data ->
            viewTableClientes data

        RemoteData.Failure httpError ->
            viewError (buildErrorMessage httpError)

viewTableClientes : List Cliente -> Element Msg
viewTableClientes clientes =
    Element.table [ Background.color gray1, Border.color gray2 ]
    { 
      data = clientes
      , columns =
          [ { header = tableHeader "ID"
              , width = fill
              , view =
                  \a -> tableData (clieIdToString a.id)
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
          , { header = tableHeader "Telefone"
              , width = fill
              , view =
                  \a -> tableData a.telefone
          }
          , { header = tableHeader "Pet (s)"
              , width = fill
              , view = 
                  \a -> tableData a.nome
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
                          deleteItemButton (DeleteCliente a.id)
                        ]
                    ]
                  
          }
          ]
      }