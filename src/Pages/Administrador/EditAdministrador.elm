module Pages.Administrador.EditAdministrador exposing (Model, Msg, init, update, view)

import Browser.Navigation as Nav
--import Error exposing (buildErrorMessage)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Server.Adm exposing (Administrador, AdmId, admDecoder, admEncoder)
import RemoteData exposing (WebData)
import Route

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

import Server.Adm exposing (Administrador, AdmId, admsDecoder)
import RemoteData exposing (WebData)
import Server.Adm exposing (Administrador)
import Server.Adm exposing (AdmId)
import Server.Adm exposing (idToString)
import Server.Adm as Adm


type alias Model =
    { navKey : Nav.Key
    , adm : WebData Administrador
    , saveError : Maybe String
    }


init : AdmId -> Nav.Key -> ( Model, Cmd Msg )
init admId navKey =
    ( initialModel navKey, fetchAdm admId )


initialModel : Nav.Key -> Model
initialModel navKey =
    { navKey = navKey
    , adm = RemoteData.Loading
    , saveError = Nothing
    }


fetchAdm : AdmId -> Cmd Msg
fetchAdm admId =
    Http.get
        { url = "https://vidapet-backend.herokuapp.com/adm/" ++ Adm.idToString admId
        , expect =
            admDecoder
                |> Http.expectJson (RemoteData.fromResult >> AdministradorReceived)
        }


type Msg
    = AdministradorReceived (WebData Administrador)
    | UpdateNome String
    | UpdateEmail String
    | UpdateDocumento String
    | SaveAdministrador
    | AdministradorSaved (Result Http.Error Administrador)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AdministradorReceived adm ->
            ( { model | adm = adm }, Cmd.none )

        UpdateNome newNome ->
            let
                updateNome =
                    RemoteData.map
                        (\administradorData ->
                            { administradorData | nome = newNome }
                        )
                        model.adm
            in
            ( { model | adm = updateNome }, Cmd.none )

        UpdateEmail newEmail ->
            let
                updateEmail =
                    RemoteData.map
                        (\administradorData ->
                            { administradorData | email = newEmail }
                        )
                        model.adm
            in
            ( { model | adm = updateEmail }, Cmd.none )

        UpdateDocumento newDocumento ->
            let
                updateDocumento =
                    RemoteData.map
                        (\administradorData ->
                            { administradorData | documento = newDocumento }
                        )
                        model.adm
            in
            ( { model | adm = updateDocumento }, Cmd.none )

        SaveAdministrador ->
            ( model, saveAdministrador model.adm )

        AdministradorSaved (Ok administradorData) ->
            let
                adm =
                    RemoteData.succeed administradorData
            in
            ( { model | adm = adm, saveError = Nothing }
            , Route.pushUrl Route.AllAdms model.navKey
            )

        AdministradorSaved (Err error) ->
            ( { model | saveError = Just (buildErrorMessage error) }
            , Cmd.none
            )


saveAdministrador : WebData Administrador -> Cmd Msg
saveAdministrador adm =
    case adm of
        RemoteData.Success administradorData ->
            let
                administradorUrl =
                    "https://vidapet-backend.herokuapp.com/adm/"
                        ++ Adm.idToString administradorData.id
            in
            Http.request
                { method = "PATCH"
                , headers = []
                , url = administradorUrl
                , body = Http.jsonBody (admEncoder administradorData)
                , expect = Http.expectJson AdministradorSaved admDecoder
                , timeout = Nothing
                , tracker = Nothing
                }

        _ ->
            Cmd.none



{-
viewAdministrador : Model -> Html Msg
viewAdministrador model =
    div []
        [ h3 [] [ Html.text "Edit Administrador" ]
        , viewAdm model.adm
        , viewSaveError model.saveError
        ]


viewAdm : WebData Administrador -> Html Msg
viewAdm adm =
    case adm of
        RemoteData.NotAsked ->
            Html.text ""

        RemoteData.Loading ->
            h3 [] [ Html.text "Loading Administrador..." ]

        RemoteData.Success administradorData ->
            editForm administradorData

        RemoteData.Failure httpError ->
            viewFetchError (buildErrorMessage httpError)

-}

viewDataOrError : Model -> Element Msg
viewDataOrError model =
    case model.adm of
        RemoteData.NotAsked -> 
            viewNoAskedMsg

        RemoteData.Loading -> 
            viewLoagindMsg

        RemoteData.Success administradorData ->
            Element.html <| editForm administradorData

        RemoteData.Failure httpError ->
            viewError (buildErrorMessage httpError)

editForm : Administrador -> Html Msg
editForm adm =
    Html.form []
        [ div []
            [ Html.text "Nome"
            , br [] []
            , input
                [ type_ "text"
                , value adm.nome
                , onInput UpdateNome
                ]
                []
            ]
        , br [] []
        , div []
            [ Html.text "E-mail"
            , br [] []
            , input
                [ type_ "text"
                , value adm.email
                , onInput UpdateEmail
                ]
                []
            ]
        , br [] []
        , div []
            [ Html.text "CPF"
            , br [] []
            , input
                [ type_ "text"
                , value adm.documento
                , onInput UpdateDocumento
                ]
                []
            ]
        , br [] []
        , div []
            [ button [ type_ "button", onClick SaveAdministrador ]
                [ Html.text "Submit" ]
            ]
        ]

{-}

viewFetchError : String -> Html Msg
viewFetchError errorMessage =
    let
        errorHeading =
            "Couldn't fetch adm at this time."
    in
    div []
        [ h3 [] [ Html.text errorHeading ]
        , Html.text ("Error: " ++ errorMessage)
        ]


viewSaveError : Maybe String -> Html msg
viewSaveError maybeError =
    case maybeError of
        Just error ->
            div []
                [ h3 [] [ Html.text "Couldn't save adm at this time." ]
                , Html.text ("Error: " ++ error)
                ]

        Nothing ->
            Html.text ""

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
              headerLayout blue4 lightBlue4 "Editar Administrador" "Voltar" "http://localhost:8000/adm"--cabeçalho
                , viewDataOrError model
                , viewSaveError model.saveError

            ]
          )
      ]

