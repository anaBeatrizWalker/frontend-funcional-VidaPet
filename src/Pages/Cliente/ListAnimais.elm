module Pages.Cliente.ListAnimais exposing (..)

import Html exposing (..)
import Element exposing (..)
import Element.Border as Border
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import RemoteData exposing (WebData)
import Browser.Navigation as Nav

import Utils.Colors exposing (blue1, lightBlue1, gray1, gray2)
import Utils.Icons exposing (editIconTable, deleteIcon)
import Components.MenuCliente exposing (menuLayout)
import Components.Header exposing (headerLayout)

import Server.Cliente exposing (..)
import Server.ServerUtils exposing (..)

type alias Model =
    { navKey : Nav.Key
    , cliente : WebData Cliente
    , deleteError : Maybe String
    }


init : ClieId -> Nav.Key -> ( Model, Cmd Msg )
init clieId navKey =
    ( initialModel navKey, getClienteById clieId )


initialModel : Nav.Key -> Model
initialModel navKey =
    { navKey = navKey
    , cliente = RemoteData.Loading
    , deleteError = Nothing
    }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
    
        NoOp -> 
            (model, Cmd.none)

        ClienteByIdReceived response ->
            ( { model | cliente = response }, Cmd.none )
        
        _ ->
            (model, Cmd.none)

view : Model -> Html Msg
view model = 
  Element.layout [] <|
    row [ width fill, height fill ] 
      [
        case model.cliente of
            RemoteData.Success data ->
                el [ width (px 200), height fill, Background.color blue1 ] --Menu lateral
                (menuLayout data.id "./../../../assets/cliente.jpg"  lightBlue1 )

            _ ->
                el [ width (px 200), height fill, Background.color blue1 ] --Carregamento do menu lateral
                    ( none )

      , el [ width fill, height fill ] --Corpo
          (column [ width fill, height fill, padding 50, centerX, centerY, spacing 30, Background.color gray1 ] 
            [ 
              headerLayout blue1 lightBlue1 "Meus pet's" "Adicionar pet" "http://localhost:8000/cliente/animal/novo"--cabeçalho
              , viewDataOrError model --tabela (ou mensagem de erro na requisição get)
              , viewDeleteError model.deleteError --mensagem de erro na requisição delete
            ]
          )
      ]

viewDataOrError : Model -> Element Msg
viewDataOrError model =
    case model.cliente of
        RemoteData.NotAsked -> 
            viewNoAskedMsg

        RemoteData.Loading -> 
            viewLoagindMsg

        RemoteData.Success data ->
            viewAnimais data.animais

        RemoteData.Failure httpError ->
            viewError (buildErrorMessage httpError)

viewAnimais : List Animal -> Element Msg
viewAnimais animais =
    Element.table [ Background.color gray1, Border.color gray2 ]
    { 
      data = animais
      , columns =
          [ 
             { header = tableHeader "ID"
              , width = fill
              , view =
                  \item -> tableData (animIdToString item.id)
            }
             , { header = tableHeader "Nome"
              , width = fill
              , view =
                  \item -> tableData item.nome
            }
         
          , { header = tableHeader "Espécie"
              , width = fill
              , view =
                  \item -> tableData item.especie
            }
          , { header = tableHeader "Raça"
              , width = fill
              , view =
                  \item -> tableData item.raça
          }
          , { header = tableHeader "Data de Nascimento"
              , width = fill
              , view =
                  \item -> tableData item.dataDeNascimento
          }
          , { header = tableHeader "Peso (kg)"
              , width = fill
              , view = 
                  \item -> tableData (String.fromFloat item.peso)
          }
          , { header = tableHeader "Ações"
              , width = fill
              , view =
                  \_ ->
                  
                  row [ spacing 20, padding 10, Border.color gray2, Border.widthEach {bottom = 0, left = 0, top = 1, right = 0} ] 
                    [
                      column [ centerX ] 
                        [
                          editButtonTable (Nothing)
                        ]
                      , column [ centerX ] 
                        [
                          deleteItemButton (Nothing)
                        ]
                    ]
                  
          }
          ]
      }

--Componentes com Msg personalizado da tela
tableHeader : String -> Element msg
tableHeader titleColumn = row [ Font.bold, Font.size 18, Background.color gray2, padding 15 ] [Element.text titleColumn]

tableData : String -> Element msg
tableData data = row [ padding 10, Font.size 16, Border.color gray2, Border.widthEach {bottom = 0, left = 0, top = 1, right = 0} ] [Element.text data]

editButtonTable : Maybe msg -> Element msg
editButtonTable action =
    Input.button
        [ padding 5
        , Border.rounded 5
        , focused [ 
            Border.color gray2
        ]
        , mouseOver [ 
            Border.color gray2
            , Background.color gray2 
        ]
        ]
        { onPress = action
        , label = editIconTable
        }

deleteItemButton : Maybe msg -> Element msg
deleteItemButton action =
    Input.button
        [ padding 5
        , Border.rounded 5
        , focused [ 
            Border.color gray2
        ]
        , mouseOver [ 
            Border.color gray2
            , Background.color gray2 
        ]
        ]
        { onPress = action
        , label = deleteIcon
        }
