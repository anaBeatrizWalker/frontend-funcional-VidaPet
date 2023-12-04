module Pages.Administrador.ListAdms exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode
import Server.Adm exposing (Administrador, AdmId, admsDecoder)
import RemoteData exposing (WebData)
import Server.Adm exposing (Administrador)
import Server.Adm exposing (AdmId)
import Server.Adm exposing (idToString)
import Server.Adm as Adm

import Browser
import Element exposing (..)
import Element.Border as Border
import Element.Background as Background
import Utils.Colors exposing (blue4, lightBlue4, gray1, gray2)
import Components.MenuAdm exposing (menuLayout)
import Components.Header exposing (headerLayout)
import Components.Table exposing (tableHeader, tableData)
import Components.Buttons exposing (editButtonTable, deleteItemButton)
import Server.ServerUtils exposing (..)

type alias Model =
    { adms : WebData (List Administrador)
    , deleteError : Maybe String
    }


type Msg
    = FetchAdms
    | AdmsReceived (WebData (List Administrador))
    | DeleteAdm AdmId
    | AdmDeleted (Result Http.Error String)


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetchAdms )


initialModel : Model
initialModel =
    { adms = RemoteData.Loading
    , deleteError = Nothing
    }


fetchAdms : Cmd Msg
fetchAdms =
    Http.get
        { url = "https://vidapet-backend.herokuapp.com/adm/"
        , expect =
            admsDecoder
                |> Http.expectJson (RemoteData.fromResult >> AdmsReceived)
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchAdms ->
            ( { model | adms = RemoteData.Loading }, fetchAdms )

        AdmsReceived response ->
            ( { model | adms = response }, Cmd.none )

        DeleteAdm admId ->
            ( model, deleteAdm admId )

        AdmDeleted (Ok _) ->
            ( model, fetchAdms )

        AdmDeleted (Err error) ->
            ( { model | deleteError = Just (buildErrorMessage error) }
            , Cmd.none
            )


deleteAdm : AdmId -> Cmd Msg
deleteAdm admId =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = "https://vidapet-backend.herokuapp.com/adm/" ++ Adm.idToString admId
        , body = Http.emptyBody
        , expect = Http.expectString AdmDeleted
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
                  \adm -> tableData adm.documento
          }
          , { header = tableHeader "Ações"
              , width = fill
              , view =
                  \adm ->
                  row [ spacing 20, padding 10, Border.color gray2, Border.widthEach {bottom = 0, left = 0, top = 1, right = 0} ] 
                    [
                      column [ centerX ] 
                        [
                          editButtonTable ("/adm/" ++ Adm.idToString adm.id)
                        ]
                      , column [ centerX ] 
                        [
                          deleteItemButton (DeleteAdm adm.id)
                        ]
                    ]
                  
          }
          ]
      }
