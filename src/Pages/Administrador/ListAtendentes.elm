{-module Pages.Administrador.ListAtendentes exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (onInput)
import Element exposing (..)
import Element.Border as Border
import Element.Background as Background
import RemoteData exposing (WebData)

import Utils.Colors exposing (blue4, lightBlue4, gray1, gray2)
import Components.MenuAdm exposing (menuLayout)
import Components.Header exposing (headerLayout)
import Components.Table exposing (tableHeader, tableData)
import Components.Buttons exposing (editButtonTable, deleteItemButton)

import Server.Atendente exposing (..)
import Server.ServerUtils exposing (..)
import Element.Input as Input

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

        _ ->
          ( model, Cmd.none )
          

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
                          editButtonTable ""
                        ]
                      , column [ centerX ] 
                        [
                          deleteItemButton (DeleteAtendente a.id)
                        ]
                    ]
                  
          }
          ]
      }

-}

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

{-
view : Model -> Html Msg
view model =
    div []
        [ button [ onClick FetchAtendentes ]
            [ text "Refresh atendentes" ]
        , br [] []
        , br [] []
        , a [ href "/atendentes/new" ]
            [ text "Create new atendente" ]
        , viewAtendentes model.atendentes
        , viewDeleteError model.deleteError
        ]


viewAtendentes : WebData (List Atendente) -> Html Msg
viewAtendentes atendentes =
    case atendentes of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            h3 [] [ text "Loading..." ]

        RemoteData.Success actualAtendentes ->
            div []
                [ h3 [] [ text "Atendentes" ]
                , table []
                    ([ viewTableHeader ] ++ List.map viewAtendente actualAtendentes)
                ]

        RemoteData.Failure httpError ->
            viewFetchError (buildErrorMessage httpError)


viewTableHeader : Html Msg
viewTableHeader =
    tr []
        [ th []
            [ text "ID" ]
        , th []
            [ text "Nome" ]
        , th []
            [ text "Email" ]
        , th []
            [ text "CPF" ]      
        ]


viewAtendente : Atendente -> Html Msg
viewAtendente atendente =
    let
        administradorPath =
            "/atendentes/" ++ Atendente.idToString atendente.id
    in
    tr []
        [ td []
            [ text (Atendente.idToString atendente.id) ]
        , td []
            [ text atendente.nome]
        , td []
            [ text atendente.email ]
        , td []
            [ text atendente.documento ]
        , td []
            [ a [ href administradorPath ] [ text "Edit" ] ]
        , td []
            [ button [ type_ "button", onClick (DeleteAtendente atendente.id) ]
                [ text "Delete" ]
            ]
        ]


viewFetchError : String -> Html Msg
viewFetchError errorMessage =
    let
        errorHeading =
            "Couldn't fetch atendentes at this time."
    in
    div []
        [ h3 [] [ text errorHeading ]
        , text ("Error: " ++ errorMessage)
        ]


viewDeleteError : Maybe String -> Html msg
viewDeleteError maybeError =
    case maybeError of
        Just error ->
            div []
                [ h3 [] [ text "Couldn't delete atendente at this time." ]
                , text ("Error: " ++ error)
                ]

        Nothing ->
            text ""

-}

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