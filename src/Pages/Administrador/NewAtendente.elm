module Pages.Administrador.NewAtendente exposing (Model, Msg, init, update, view)

import Browser.Navigation as Nav
--import Error exposing (buildErrorMessage)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Server.Atendente exposing (Atendente, AtendenteId, emptyAtendente, newAtendenteEncoder, atendenteDecoder)
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

import Server.Atendente exposing (Atendente, AtendenteId, atendentesDecoder)
import RemoteData exposing (WebData)
import Server.Atendente exposing (Atendente)
import Server.Atendente exposing (AtendenteId)
import Server.Atendente exposing (idToString)
import Server.Atendente as Atendente

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

{-}
view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "Create New Atendente" ]
        , newAtendenteForm
        , viewError model.createError
        ]

-}

newAtendenteForm : Html Msg
newAtendenteForm =


    Html.form []
        [ div []
            [ Html.text "Nome"
            , br [] []
            , input [ type_ "text", onInput StoreNome ] []
            ]
        , br [] []
        , div []
            [ Html.text "E-mail"
            , br [] []
            , input [ type_ "text", onInput StoreEmail ] []
            ]
        , br [] []
        , div []
            [ Html.text "CPF"
            , br [] []
            , input [ type_ "text", onInput StoreDocumento ] []
            ]
        , br [] []
        , div []
            [ button [ type_ "button", onClick CreateAtendente ]
                [ Html.text "Submit" ]
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

{-}
viewError : Maybe String -> Html msg
viewError maybeError =
    case maybeError of
        Just error ->
            div []
                [ h3 [] [ text "Couldn't create a atendente at this time." ]
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
              headerLayout blue4 lightBlue4 "Adicionar Atendente" "Voltar" "http://localhost:8000/adm/atendentes"--cabeçalho            
            , Element.html <| newAtendenteForm
            , viewCreateError model.createError                       
            ]
          )
      ]

