{-module Pages.Administrador.ListAdms exposing (..)

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

        _ ->
          (model, Cmd.none)

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
                          editButtonTable ""
                        ]
                      , column [ centerX ] 
                        [
                          deleteItemButton (DeleteAdm adm.id)
                        ]
                    ]
                  
          }
          ]
      }

-}

module Pages.Administrador.ListAdms exposing (Model, Msg, init, update, view)

--import Error exposing (buildErrorMessage)
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


{-view : Model -> Html Msg
view model =
    div []
        [ button [ onClick FetchAdms ]
            [ text "Refresh adms" ]
        , br [] []
        , br [] []
        , a [ href "/adm/new" ]
            [ text "Create new adm" ]
        , viewAdms model.adms
        , viewDeleteError model.deleteError
        ]

viewAdms : WebData (List Administrador) -> Html Msg
viewAdms adms =
    case adms of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            h3 [] [ text "Loading..." ]

        RemoteData.Success actualAdministradores ->
            div []
                [ h3 [] [ text "Administradores" ]
                , table []
                    ([ viewTableHeader ] ++ List.map viewAdm actualAdministradores)
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


viewAdm : Administrador -> Html Msg
viewAdm adm =
    let
        administradorPath =
            "/adm/" ++ Adm.idToString adm.id
    in
    tr []
        [ td []
            [ text (Adm.idToString adm.id) ]
        , td []
            [ text adm.nome]
        , td []
            [ text adm.email ]
        , td []
            [ text adm.documento ]
        , td []
            [ a [ href administradorPath ] [ text "Edit" ] ]
        , td []
            [ button [ type_ "button", onClick (DeleteAdm adm.id) ]
                [ text "Delete" ]
            ]
        ]


viewFetchError : String -> Html Msg
viewFetchError errorMessage =
    let
        errorHeading =
            "Couldn't fetch adms at this time."
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
                [ h3 [] [ text "Couldn't delete adm at this time." ]
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
