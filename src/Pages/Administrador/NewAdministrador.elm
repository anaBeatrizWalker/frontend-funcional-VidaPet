module Pages.Administrador.NewAdministrador exposing (Model, Msg, init, update, view)

import Browser.Navigation as Nav

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Server.Adm exposing (Administrador, AdmId, emptyAdm, newAdmEncoder, admDecoder)
import Route

import Element exposing (..)
import Element.Border as Border
import Element.Background as Background
import Utils.Colors exposing (blue4, lightBlue4, gray1, gray2)
import Utils.Colors exposing (blue3, lightBlue3, gray1, gray1)
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

import Components.Header exposing (headerLayout)
import Utils.Colors exposing (blue3, lightBlue3, gray1, gray1)
import Html.Attributes exposing (type_, style, value)
import Html.Events exposing (onInput)


import Browser.Navigation as Nav
import Http
import Html as Html
import Html.Attributes exposing (type_, style, value)
import Html.Events exposing (onInput)
import Element exposing (..)
import Element.Input as Input
import Element.Background as Background
import Element.Border as Border

type alias Model =
    { navKey : Nav.Key
    , adm : Administrador
    , createError : Maybe String
    }


init : Nav.Key -> ( Model, Cmd Msg )
init navKey =
    ( initialModel navKey, Cmd.none )


initialModel : Nav.Key -> Model
initialModel navKey =
    { navKey = navKey
    , adm = emptyAdm
    , createError = Nothing
    }


newAdmForm : Html Msg
newAdmForm =


    Html.form [ style "width" "100%", style "margin-bottom" "20px" ] [
        Html.div [ style "display" "flex"]
            [ Html.div [ style "flex" "1", style "padding-right" "10px"]
                [ 
                    Html.label [ style "font-size" "16px" ] [ Html.text "Nome" ]
                    , Html.br [] []
                    , Html.input [ type_ "text", onInput StoreNome, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []
                    , Html.br [] []
                    ,Html.label [ style "font-size" "16px" ] [ Html.text "E-mail" ]
                    , Html.br [] []
                    , Html.input [ type_ "text", onInput StoreEmail, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []
                    , Html.br [] []
                    , Html.label [ style "font-size" "16px" ] [ Html.text "CPF" ]
                    , Html.br [] []
                    , Html.input [ type_ "text", onInput StoreDocumento, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []
                    , Html.br [] []

                ]
            ]   
    ]


type Msg
    = StoreNome String
    | StoreEmail String
    | StoreDocumento String
    | CreateAdministrador
    | AdministradorCreated (Result Http.Error Administrador)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StoreNome nome ->
            let
                oldAdministrador =
                    model.adm

                updateNome =
                    { oldAdministrador | nome = nome }
            in
            ( { model | adm = updateNome }, Cmd.none )

        StoreEmail email ->
            let
                oldAdministrador =
                    model.adm

                updateEmail =
                    { oldAdministrador | email = email }
            in
            ( { model | adm = updateEmail }, Cmd.none )

        StoreDocumento documento ->
            let
                oldAdministrador =
                    model.adm

                updateDocumento =
                    { oldAdministrador | documento = documento }
            in
            ( { model | adm = updateDocumento }, Cmd.none )

        CreateAdministrador ->
            ( model, createAdministrador model.adm )

        AdministradorCreated (Ok adm) ->
            ( { model | adm = adm, createError = Nothing }
            , Route.pushUrl Route.AllAdms model.navKey
            )

        AdministradorCreated (Err error) ->
            ( { model | createError = Just (buildErrorMessage error) }
            , Cmd.none
            )


createAdministrador : Administrador -> Cmd Msg
createAdministrador adm =
    Http.post
        { url = "https://vidapet-backend.herokuapp.com/adm"
        , body = Http.jsonBody (newAdmEncoder adm)
        , expect = Http.expectJson AdministradorCreated admDecoder
        }



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
                headerLayout blue4 lightBlue4 "Lista de Administradores" "Voltar" "http://localhost:8000/adm"--cabeçalho            
                , Element.html <| newAdmForm
                , viewCreateError model.createError   
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
                        { onPress = Just (CreateAdministrador)
                        , label = Element.text "Adicionar"
                        } 
                    ) 
                ] 
                , column [ Element.width (px 200), Element.height fill, padding 50, Background.color gray1 ] []
            ]
        ]