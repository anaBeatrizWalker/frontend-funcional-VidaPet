module Pages.Administrador.NewAtendente exposing (Model, Msg, init, update, view)

import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Server.Atendente exposing (Atendente, AtendenteId, emptyAtendente, newAtendenteEncoder, atendenteDecoder)
import Route

import Element exposing (..)
import Element.Border as Border
import Element.Background as Background
import Utils.Colors exposing (blue4, lightBlue4, gray1, gray2)

import Components.Header exposing (headerLayout)
import Components.Table exposing (tableHeader, tableData)
import Components.Buttons exposing (editButtonTable, deleteItemButton)
import Server.ServerUtils exposing (..)

import Server.Atendente exposing (Atendente, AtendenteId, atendentesDecoder)
import RemoteData exposing (WebData)
import Server.Atendente exposing (Atendente)
import Server.Atendente exposing (AtendenteId)
import Server.Atendente exposing (idToString)
import Server.Atendente as Atendente

import Components.MenuAdm exposing (menuLayout)
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
import Json.Decode exposing (Decoder)
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (required)
import Json.Decode exposing (string)
import Json.Encode as Encode


import Components.Header exposing (headerLayout)
import Utils.Colors exposing (blue3, lightBlue3, gray1, gray1)
import Route

import Server.Agenda exposing(..)
import Server.ServerUtils exposing (..)
import Element.Font as Font
import Utils.Colors exposing (white)

type alias Model =
    { navKey : Nav.Key
    , atendente : Atendente
    , createError : Maybe String
    }


init : Nav.Key -> ( Model, Cmd Msg )
init navKey =
    ( initialModel navKey, Cmd.none )


initialModel : Nav.Key -> Model
initialModel navKey =
    { navKey = navKey
    , atendente = emptyAtendente
    , createError = Nothing
    }


newAtendenteForm : Html Msg
newAtendenteForm =
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
    | CreateAtendente
    | AtendenteCreated (Result Http.Error Atendente)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StoreNome nome ->
            let
                oldAtendente =
                    model.atendente

                updateNome =
                    { oldAtendente | nome = nome }
            in
            ( { model | atendente = updateNome }, Cmd.none )

        StoreEmail email ->
            let
                oldAtendente =
                    model.atendente

                updateEmail =
                    { oldAtendente | email = email }
            in
            ( { model | atendente = updateEmail }, Cmd.none )

        StoreDocumento documento ->
            let
                oldAtendente =
                    model.atendente

                updateDocumento =
                    { oldAtendente | documento = documento }
            in
            ( { model | atendente = updateDocumento }, Cmd.none )

        CreateAtendente ->
            ( model, createAtendente model.atendente )

        AtendenteCreated (Ok atendente) ->
            ( { model | atendente = atendente, createError = Nothing }
            , Route.pushUrl Route.AllAtendentes model.navKey
            )

        AtendenteCreated (Err error) ->
            ( { model | createError = Just (buildErrorMessage error) }
            , Cmd.none
            )


createAtendente : Atendente -> Cmd Msg
createAtendente atendente =
    Http.post
        { url = "https://vidapet-backend.herokuapp.com/atendentes"
        , body = Http.jsonBody (newAtendenteEncoder atendente)
        , expect = Http.expectJson AtendenteCreated atendenteDecoder
        }


view : Model -> Html.Html Msg
view model = 
    Element.layout [] <|
        row [ Element.width fill, Element.height fill ] 
        [
            el [ Element.width (px 200), Element.height fill, Background.color blue4 ]
                (menuLayout "./../../../assets/administradora.jpg" lightBlue4)
        , row [ Element.width fill, Element.height fill ]
            [ column [ Element.width fill, Element.height fill, padding 50, centerX, centerY, spacing 30, Background.color gray1 ] 
                [ 
                headerLayout blue4 lightBlue4 "Novo Atendente" "" "http://localhost:8000/adm/atendentes"--cabeçalho  
                , viewCreateError model.createError
                , Element.html <| newAtendenteForm
                , el [ alignRight ] --botao de Adicionar
                    (
                    Input.button [
                        padding 10
                        , Border.rounded 10
                        , Border.widthEach { bottom = 5, left = 50, right = 50, top = 5 }
                        , Border.color blue4
                        , Background.color blue4
                        , Font.color white
                        , focused [ 
                            Border.color lightBlue4
                            , Background.color lightBlue4
                        ]
                        , mouseOver [ 
                            Border.color lightBlue4
                            , Background.color lightBlue4 
                        ]
                        ] 
                        { onPress = Just (CreateAtendente)
                        , label = Element.text "Adicionar"
                        } 
                    ) 
                ] 
                , column [ Element.width (px 200), Element.height fill, padding 50, Background.color gray1 ] []
            ]
        ]