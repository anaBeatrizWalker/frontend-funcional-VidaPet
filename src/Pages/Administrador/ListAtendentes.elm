module Pages.Administrador.ListAtendentes exposing (Model, Msg, init, update, view)

--import Error exposing (buildErrorMessage)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode
import Server.Atendente exposing (Atendente, AtendenteId, atendentesDecoder)
import RemoteData exposing (WebData)
import Server.Atendente exposing (Atendente)
import Server.Atendente exposing (AtendenteId)
import Server.Atendente exposing (idToString)
import Server.Atendente as Atendente

import Utils.Colors exposing (blue4, lightBlue4, gray1, gray2)
import Components.MenuAdm exposing (menuLayout)
import Components.Header exposing (headerLayout)
import Components.Table exposing (tableHeader, tableData)
import Components.Buttons exposing (editButtonTable, deleteItemButton)

import Browser
import Element exposing (..)
import Element.Border as Border
import Element.Background as Background
import Server.Atendente exposing (..)
import Server.ServerUtils exposing (..)
import Element.Input as Input

type alias Model =
    { atendentes : WebData (List Atendente)
    , deleteError : Maybe String
    }


type Msg
    = FetchAtendentes
    | AtendentesReceived (WebData (List Atendente))
    | DeleteAtendente AtendenteId
    | AtendenteDeleted (Result Http.Error String)


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetchAtendentes )


initialModel : Model
initialModel =
    { atendentes = RemoteData.Loading
    , deleteError = Nothing
    }


fetchAtendentes : Cmd Msg
fetchAtendentes =
    Http.get
        { url = "https://vidapet-backend.herokuapp.com/atendentes/"
        , expect =
            atendentesDecoder
                |> Http.expectJson (RemoteData.fromResult >> AtendentesReceived)
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchAtendentes ->
            ( { model | atendentes = RemoteData.Loading }, fetchAtendentes )

        AtendentesReceived response ->
            ( { model | atendentes = response }, Cmd.none )

        DeleteAtendente atendenteId ->
            ( model, deleteAtendente atendenteId )

        AtendenteDeleted (Ok _) ->
            ( model, fetchAtendentes )

        AtendenteDeleted (Err error) ->
            ( { model | deleteError = Just (buildErrorMessage error) }
            , Cmd.none
            )


deleteAtendente : AtendenteId -> Cmd Msg
deleteAtendente atendenteId =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = "https://vidapet-backend.herokuapp.com/atendentes/" ++ Atendente.idToString atendenteId
        , body = Http.emptyBody
        , expect = Http.expectString AtendenteDeleted
        , timeout = Nothing
        , tracker = Nothing
        }



-- VIEWS


view : Model -> Html Msg
view model = 
  Element.layout [] <|
    row [ Element.width fill, Element.height fill ] 
      [
        el [ Element.width (px 200), Element.height fill, Background.color blue4 ] --Menu lateral
          (menuLayout "./../../../assets/administradora.jpg" lightBlue4)
      , el [ Element.width fill, Element.height fill ] --Corpo
          (column [ Element.width fill, Element.height fill, padding 50, centerX, centerY, spacing 30, Background.color gray1 ] 
            [ 
              headerLayout blue4 lightBlue4 "Lista de Atendentes" "Adicionar atendente" "http://localhost:8000/adm/atendentes/novo"--cabeçalho
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
                  \a -> tableData a.documento
          }
          , { header = tableHeader "Ações"
              , width = fill
              , view =
                  \a ->
                  row [ spacing 20, padding 10, Border.color gray2, Border.widthEach {bottom = 0, left = 0, top = 1, right = 0} ] 
                    [
                      column [ centerX ] 
                        [
                          editButtonTable ("/adm/atendentes/" ++ Atendente.idToString a.id)
                        ]
                      , column [ centerX ] 
                        [
                          deleteItemButton (DeleteAtendente a.id)
                        ]
                    ]
                  
          }
          ]
      }