module Pages.Administrador.EditAtendente exposing (Model, Msg, init, update, view)

import Browser.Navigation as Nav
--import Error exposing (buildErrorMessage)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Server.Atendente exposing (Atendente, AtendenteId, atendenteDecoder, atendenteEncoder)
import RemoteData exposing (WebData)
import Route

import Server.Atendente exposing (idToString)
import Server.Atendente as Atendente


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


import RemoteData exposing (WebData)

import Server.Atendente exposing (AtendenteId)
import Server.Atendente exposing (idToString)
import Server.Atendente as Atendente

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

{-}
view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "Edit Atendente" ]
        , viewAtendente model.atendente
        , viewSaveError model.saveError
        ]


viewAtendente : WebData Atendente -> Html Msg
viewAtendente atendente =
    case atendente of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            h3 [] [ text "Loading Atendente..." ]

        RemoteData.Success atendenteData ->
            editForm atendenteData

        RemoteData.Failure httpError ->
            viewFetchError (buildErrorMessage httpError)
-}

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
    Html.form []
        [ div []
            [ Html.text "Nome"
            , br [] []
            , input
                [ type_ "text"
                , value atendente.nome
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
                , value atendente.email
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
                , value atendente.documento
                , onInput UpdateDocumento
                ]
                []
            ]
        , br [] []
        , div []
            [ button [ type_ "button", onClick SaveAtendente ]
                [ Html.text "Submit" ]
            ]
        ]

{-
viewFetchError : String -> Html Msg
viewFetchError errorMessage =
    let
        errorHeading =
            "Couldn't fetch atendente at this time."
    in
    div []
        [ h3 [] [ text errorHeading ]
        , text ("Error: " ++ errorMessage)
        ]


viewSaveError : Maybe String -> Html msg
viewSaveError maybeError =
    case maybeError of
        Just error ->
            div []
                [ h3 [] [ text "Couldn't save atendente at this time." ]
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
              headerLayout blue4 lightBlue4 "Editar Atendente" "Voltar" "http://localhost:8000/adm/atendentes"--cabeçalho
                , viewDataOrError model
                , viewSaveError model.saveError

            ]
          )
      ]