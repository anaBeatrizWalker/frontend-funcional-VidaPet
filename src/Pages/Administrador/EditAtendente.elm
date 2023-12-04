module Pages.Administrador.EditAtendente exposing (Model, Msg, init, update, view)

import Browser.Navigation as Nav

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Server.Atendente exposing (Atendente, AtendenteId, atendenteDecoder, atendenteEncoder)
import RemoteData exposing (WebData)
import Route

import Server.Atendente exposing (idToString)
import Server.Atendente as Atendente

import Element exposing (..)
import Element.Border as Border
import Element.Background as Background
import Element.Input as Input
import Utils.Colors exposing (blue4, lightBlue4, gray1, gray2)
import Components.MenuAdm exposing (menuLayout)
import Components.Header exposing (headerLayout)
import Components.Table exposing (tableHeader, tableData)
import Components.Buttons exposing (editButtonTable, deleteItemButton)
import Server.ServerUtils exposing (..)

import Html as Html
import Html.Attributes exposing (type_, style, value)
import Html.Events exposing (onInput)
import Element exposing (..)

import Json.Decode exposing (Decoder)
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (required)
import Json.Decode exposing (string)
import Json.Encode as Encode

import Utils.Colors exposing (blue3, lightBlue3, gray1, gray1)
import Server.ServerUtils exposing (..)

type alias Model =
    { navKey : Nav.Key
    , atendente : WebData Atendente
    , saveError : Maybe String
    }


init : AtendenteId -> Nav.Key -> ( Model, Cmd Msg )
init atendenteId navKey =
    ( initialModel navKey, fetchAtendente atendenteId )


initialModel : Nav.Key -> Model
initialModel navKey =
    { navKey = navKey
    , atendente = RemoteData.Loading
    , saveError = Nothing
    }


fetchAtendente : AtendenteId -> Cmd Msg
fetchAtendente atendenteId =
    Http.get
        { url = "https://vidapet-backend.herokuapp.com/atendentes/" ++ Atendente.idToString atendenteId
        , expect =
            atendenteDecoder
                |> Http.expectJson (RemoteData.fromResult >> AtendenteReceived)
        }


type Msg
    = AtendenteReceived (WebData Atendente)
    | UpdateNome String
    | UpdateEmail String
    | UpdateDocumento String
    | SaveAtendente
    | AtendenteSaved (Result Http.Error Atendente)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AtendenteReceived atendente ->
            ( { model | atendente = atendente }, Cmd.none )

        UpdateNome newNome ->
            let
                updateNome =
                    RemoteData.map
                        (\atendenteData ->
                            { atendenteData | nome = newNome }
                        )
                        model.atendente
            in
            ( { model | atendente = updateNome }, Cmd.none )

        UpdateEmail newEmail ->
            let
                updateEmail =
                    RemoteData.map
                        (\atendenteData ->
                            { atendenteData | email = newEmail }
                        )
                        model.atendente
            in
            ( { model | atendente = updateEmail }, Cmd.none )

        UpdateDocumento newDocumento ->
            let
                updateDocumento =
                    RemoteData.map
                        (\atendenteData ->
                            { atendenteData | documento = newDocumento }
                        )
                        model.atendente
            in
            ( { model | atendente = updateDocumento }, Cmd.none )

        SaveAtendente ->
            ( model, saveAtendente model.atendente )

        AtendenteSaved (Ok atendenteData) ->
            let
                atendente =
                    RemoteData.succeed atendenteData
            in
            ( { model | atendente = atendente, saveError = Nothing }
            , Route.pushUrl Route.AllAtendentes model.navKey
            )

        AtendenteSaved (Err error) ->
            ( { model | saveError = Just (buildErrorMessage error) }
            , Cmd.none
            )


saveAtendente : WebData Atendente -> Cmd Msg
saveAtendente atendente =
    case atendente of
        RemoteData.Success atendenteData ->
            let
                atendenteUrl =
                    "https://vidapet-backend.herokuapp.com/atendentes/"
                        ++ Atendente.idToString atendenteData.id
            in
            Http.request
                { method = "PATCH"
                , headers = []
                , url = atendenteUrl
                , body = Http.jsonBody (atendenteEncoder atendenteData)
                , expect = Http.expectJson AtendenteSaved atendenteDecoder
                , timeout = Nothing
                , tracker = Nothing
                }

        _ ->
            Cmd.none


viewDataOrError : Model -> Element Msg
viewDataOrError model =
    case model.atendente of
        RemoteData.NotAsked -> 
            viewNoAskedMsg

        RemoteData.Loading -> 
            viewLoagindMsg

        RemoteData.Success atendenteData ->
            Element.html <| editForm atendenteData

        RemoteData.Failure httpError ->
            viewError (buildErrorMessage httpError)

editForm : Atendente -> Html Msg
editForm atendente =

    Html.form [ style "width" "100%", style "margin-bottom" "20px" ] [
        Html.div [ style "display" "flex"]
            [ Html.div [ style "flex" "1", style "padding-right" "10px"]
                [ 
                    Html.label [ style "font-size" "16px" ] [ Html.text "Nome" ]
                    , Html.br [] []
                    , Html.input [ type_ "text", value atendente.nome, onInput UpdateNome, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []
                    , Html.br [] []
                    ,Html.label [ style "font-size" "16px" ] [ Html.text "E-mail" ]
                    , Html.br [] []
                    , Html.input [ type_ "text", value atendente.email,  onInput UpdateEmail , style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []
                    , Html.br [] []
                    , Html.label [ style "font-size" "16px" ] [ Html.text "CPF" ]
                    , Html.br [] []
                    , Html.input [ type_ "text", value atendente.documento, onInput UpdateDocumento, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []
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
                headerLayout blue3 lightBlue3 "Editar Atendente" "Voltar" "http://localhost:8000/adm/atendentes"--cabeçalho  
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
                        { onPress = Just (SaveAtendente)
                        , label = Element.text "Adicionar"
                        } 
                    ) 
                ] 
                , column [ Element.width (px 200), Element.height fill, padding 50, Background.color gray1 ] []
            ]
        ]