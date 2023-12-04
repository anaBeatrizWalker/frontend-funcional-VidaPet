module Pages.Administrador.NewAdministrador exposing (Model, Msg, init, update, view)

import Browser.Navigation as Nav
--import Error exposing (buildErrorMessage)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Server.Adm exposing (Administrador, AdmId, emptyAdm, newAdmEncoder, admDecoder)
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


{-view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ Html.text "Create New Administrador" ]
        , newAdmForm
        , viewError model.createError
        ]
-}

newAdmForm : Html Msg
newAdmForm =

    let
        administradorPath =
            "/adm"
    in

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
            [ button [ type_ "button", onClick CreateAdministrador ]
                [Html.text "Submit"] 
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


{-viewError : Maybe String -> Html msg
viewError maybeError =
    case maybeError of
        Just error ->
            div []
                [ h3 [] [ Html.text "Couldn't create a adm at this time." ]
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
              headerLayout blue4 lightBlue4 "Lista de Administradores" "Voltar" "http://localhost:8000/adm"--cabeçalho            
            , Element.html <| newAdmForm
            , viewCreateError model.createError                       
            ]
          )
      ]


