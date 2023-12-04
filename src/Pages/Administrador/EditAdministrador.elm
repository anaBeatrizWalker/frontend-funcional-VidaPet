module Pages.Administrador.EditAdministrador exposing (Model, Msg, init, update, view)

import Browser.Navigation as Nav
import Http
import RemoteData exposing (WebData)
import Route

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (type_, style, value)
import Html.Events exposing (onInput)

import Server.Adm exposing (Administrador, AdmId, admDecoder, admEncoder)
import Server.ServerUtils exposing (..)
import Server.Adm exposing (Administrador, AdmId, admsDecoder)
import Server.Adm exposing (idToString)
import Server.Adm as Adm

import Element exposing (..)
import Element.Border as Border
import Element.Background as Background
import Element.Input as Input

import Components.MenuAdm exposing (menuLayout)
import Components.Header exposing (headerLayout)
import Components.Table exposing (tableHeader, tableData)
import Components.Buttons exposing (editButtonTable, deleteItemButton)
import Components.Header exposing (headerLayout)
import Utils.Colors exposing (blue3, lightBlue3, gray1, gray1)
import Utils.Colors exposing (blue4, lightBlue4, gray1, gray2)


import Html as Html
import Html.Attributes exposing (type_, style, value)



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

    Html.form [ style "width" "100%", style "margin-bottom" "20px" ] [
        Html.div [ style "display" "flex"]
            [ Html.div [ style "flex" "1", style "padding-right" "10px"]
                [ 
                    Html.label [ style "font-size" "16px" ] [ Html.text "Nome" ]
                    , Html.br [] []
                    , Html.input [ type_ "text", value adm.nome, onInput UpdateNome, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []
                    , Html.br [] []
                    ,Html.label [ style "font-size" "16px" ] [ Html.text "E-mail" ]
                    , Html.br [] []
                    , Html.input [ type_ "text", value adm.email,  onInput UpdateEmail , style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []
                    , Html.br [] []
                    , Html.label [ style "font-size" "16px" ] [ Html.text "CPF" ]
                    , Html.br [] []
                    , Html.input [ type_ "text", value adm.documento, onInput UpdateDocumento, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []
                    , Html.br [] []

                ]
            ]   
    ]


view : Model -> Html.Html Msg
view model = 
    Element.layout [] <|
        row [ Element.width fill, Element.height fill ] 
        [
            el [ Element.width (px 200), Element.height fill, Background.color blue3 ]
            (  menuLayout "./../../../assets/atendente.jpg" lightBlue3 )
        , row [ Element.width fill, Element.height fill ]
            [ column [ Element.width fill, Element.height fill, padding 50, centerX, centerY, spacing 30, Background.color gray1 ] 
                [ 
                headerLayout blue3 lightBlue3 "Editar Administrador" "Voltar" "http://localhost:8000/adm/"--cabeçalho  
                , viewDataOrError model
                , viewSaveError model.saveError
                , el [ alignRight ] --botao de Adicionar
                    (
                    Input.button [
                        padding 10
                        , Border.rounded 10
                        , Border.widthEach { bottom = 5, left = 50, right = 50, top = 5 }
                        , Border.color blue3
                        , Background.color blue3
                        , focused [ 
                            Border.color lightBlue3
                            , Background.color lightBlue3
                        ]
                        , mouseOver [ 
                            Border.color lightBlue3
                            , Background.color lightBlue3 
                        ]
                        ] 
                        { onPress = Just (SaveAdministrador)
                        , label = Element.text "Adicionar"
                        } 
                    ) 
                ] 
                , column [ Element.width (px 200), Element.height fill, padding 50, Background.color gray1 ] []
            ]
        ]