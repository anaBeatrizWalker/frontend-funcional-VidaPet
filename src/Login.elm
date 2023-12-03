module Login exposing (..)

import Browser.Navigation as Nav
import Html exposing (Html, div, input, form, h2, a, label)
import Html.Attributes exposing (placeholder, type_, name, value, checked, style, href)
import Html.Events exposing (onClick, onInput)
import Element exposing (..)
import Server.ServerUtils exposing (stringToInt)


type Perfil = Administrador | Funcionario | Atendente | Cliente

type Msg 
  = UpdateId String
  | UpdateNome String 
  | UpdateEmail String
  | UpdatePerfil Perfil

type alias Model =
    { navKey : Nav.Key
    , id : Int
    , nome : String
    , email : String
    , perfil : Perfil
    , route : String
    }

init : Nav.Key -> ( Model, Cmd Msg )
init navKey =
    ( initialModel navKey, Cmd.none )

initialModel : Nav.Key -> Model
initialModel navKey =
    { navKey = navKey
    , id = 0
    , nome = ""
    , email = ""
    , perfil = Administrador
    , route = ""
    }

view : Model -> Html Msg
view model = 
  Element.layout [] <| 
    row [ centerX, centerY ] 
      [
        Element.html <| viewForm model

      ]

viewForm : Model -> Html Msg
viewForm model =
    div [  style "width" "800px", style "display" "flex", style "flex-direction" "column", style "align-items" "center", style "justify-content" "center", style "height" "100%" ]
        [ h2 [] [ Html.text "Entre com seus dados" ]
        , form [ style "display" "flex", style "flex-direction" "column", style "width" "70%" ]
            [ 
              label [ style "font-size" "20px", style "margin-bottom" "5px" ] [ Html.text "ID" ]
              ,input [ placeholder "Identificação do usuário", onInput UpdateId, style "height" "35px", style "margin-bottom" "20px", style "width" "100%" ] []
            
            , label [ style "font-size" "20px", style "margin-bottom" "5px" ] [ Html.text "Nome" ]
            , input [ placeholder "Nome", onInput UpdateNome, style "height" "35px", style "margin-bottom" "20px", style "width" "100%" ] []
            
            , label [ style "font-size" "20px", style "margin-bottom" "5px" ] [ Html.text "E-mail" ]
            , input [ placeholder "E-mail", onInput UpdateEmail, style "height" "35px", style "margin-bottom" "20px", style "width" "100%" ] []
            
            , label [ style "font-size" "20px", style "margin-bottom" "5px" ] [ Html.text "Perfil de Usuário: " ]
            , div [   ]
                [ 
                  div [ style "font-size" "20px" ] 
                    [
                      input [ type_ "radio", name "perfil", value "Administrador", checked (model.perfil == Administrador), onClick (UpdatePerfil Administrador), style "margin" "10px" ] [], Html.text "Administrador"
                    ]
                
                , div [ style "font-size" "20px" ] 
                    [
                      input [ type_ "radio", name "perfil", value "Funcionario", checked (model.perfil == Funcionario), onClick (UpdatePerfil Funcionario), style "margin" "10px" ] [], Html.text "Funcionario"
                    ]
                
                , div [ style "font-size" "20px" ] 
                    [
                      input [ type_ "radio", name "perfil", value "Atendente", checked (model.perfil == Atendente), onClick (UpdatePerfil Atendente), style "margin" "10px" ] [], Html.text "Atendente"
                    ] 
                
                , div [ style "font-size" "20px", style "margin-bottom" "25px" ] 
                    [
                      input [ type_ "radio", name "perfil", value "Cliente", checked (model.perfil == Cliente), onClick (UpdatePerfil Cliente), style "margin" "10px" ] [], Html.text "Cliente"
                    ]
                ]
             , a [ href (rotaPerfil model.perfil (String.fromInt model.id)), style "padding" "10px", style "border-radius" "10px", style "border" "5px solid blue", style "background-color" "blue", style ":hover" "background-color: lightblue; border-color: lightblue;", style "color" "white", style "text-decoration" "none", style "text-align" "center" ] [ Html.text "Entrar" ]
            ]
        ]

rotaPerfil : Perfil -> String -> String
rotaPerfil perfil id =
    case perfil of
        Administrador ->
            "/adm/agenda"

        Funcionario ->
            "/funcionario/agenda/" ++ id

        Atendente ->
            "/atendente/agenda"

        Cliente ->
            "/cliente/agenda/" ++ id

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateId id ->
          ({model | id = (stringToInt id)}, Cmd.none)

        UpdateNome nome ->
          ({model | nome = nome}, Cmd.none)

        UpdateEmail email ->
          ({model | email = email}, Cmd.none)

        UpdatePerfil perfil ->
          ({model | perfil = perfil}, Cmd.none)