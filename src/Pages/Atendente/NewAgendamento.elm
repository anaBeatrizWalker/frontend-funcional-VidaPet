module Pages.Atendente.NewAgendamento exposing (..)

import Browser.Navigation as Nav
import Html exposing (Html)
import Element exposing (..)
import Element.Input as Input
import Element.Font as Font
import Element.Input exposing (labelAbove)
import Element.Background as Background

import Components.MenuAtendente exposing (menuLayout)
import Components.Header exposing (headerLayout)
import Components.Buttons exposing (addNewButton)
import Utils.Colors exposing (blue3, lightBlue3, gray1, gray1, gray3)

import Server.Agenda exposing(..)
import Server.ServerUtils exposing (..)
import Element.Border as Border

type alias Model =
    { navKey : Nav.Key
    }

type Msg
    = NameChanged String
    | EmailChanged String

init : Nav.Key -> ( Model, Cmd Msg )
init navKey =
    ( initialModel navKey, Cmd.none )


initialModel : Nav.Key -> Model
initialModel navKey =
    { 
      navKey = navKey
    }

view : Model -> Html Msg
view model = 
  Element.layout [] <|
    row [ width fill, height fill ] 
      [
        el [ width (px 200), height fill, Background.color blue3 ]
          (menuLayout "./../../../assets/atendente.jpg" lightBlue3 )
      , el [ width fill, height fill ]
          (column [ width fill, height fill, padding 50, centerX, centerY, spacing 30, Background.color gray1 ] 
            [ 
              headerLayout blue3 lightBlue3 "Novo agendamento" "" ""
            , viewForm
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
                        { onPress = Nothing
                        , label = text "Adicionar"
                        } 
                  )
            ]
          )
      ]
viewForm :  Element Msg
viewForm  =
      row [centerX, centerY, Background.color gray3 ] 
        [
          column [ width (px 525), height fill, padding 15, spacing 20 ] 
            [
              column [ width fill ]
                          [ Input.text [ height (px 35) ]
                              { onChange = NameChanged
                              , text = ""
                              , placeholder = Nothing 
                              , label = labelAbove [Font.size 14] (text "Nome")
                              }
                          ]
              , column [ width fill ]
                          [ Input.text [ height (px 35) ]
                              { onChange = NameChanged
                              , text = ""
                              , placeholder = Nothing 
                              , label = labelAbove [Font.size 14] (text "Nome")
                              }
                          ]
              , column [ width fill ]
                          [ Input.text [ height (px 35) ]
                              { onChange = NameChanged
                              , text = ""
                              , placeholder = Nothing 
                              , label = labelAbove [Font.size 14] (text "Nome")
                              }
                          ]
              , row [ spacing 20 ] 
                      [
                         column [ width fill ]
                          [ Input.text [ height (px 35) ]
                              { onChange = NameChanged
                              , text = ""
                              , placeholder = Nothing 
                              , label = labelAbove [Font.size 14] (text "Data")
                              }
                          ]
              , column [ width fill ]
                          [ Input.text [ height (px 35) ]
                              { onChange = NameChanged
                              , text = ""
                              , placeholder =  Nothing 
                              , label = labelAbove [Font.size 14] (text "Horário")
                              }
                          ]
                      ]
              

              , column [ width fill ]
                          [ Input.text [ height (px 35) ]
                              { onChange = NameChanged
                              , text = ""
                              , placeholder = Nothing 
                              , label = labelAbove [Font.size 14] (text "Nome")
                              }
                          ]
              

            ]
          , column [  width (px 525), height fill, padding 15, spacing 20 ]
            [
              column [ width fill ]
                          [ Input.text [ height (px 35) ]
                              { onChange = NameChanged
                              , text = ""
                              , placeholder = Nothing 
                              , label = labelAbove [Font.size 14] (text "Nome")
                              }
                          ]
              , column [ width fill ]
                          [ Input.text [ height (px 35) ]
                              { onChange = NameChanged
                              , text = ""
                              , placeholder = Nothing 
                              , label = labelAbove [Font.size 14] (text "Nome")
                              }
                          ]
              , column [ width fill ]
                          [ Input.text [ height (px 35) ]
                              { onChange = NameChanged
                              , text = ""
                              , placeholder = Nothing 
                              , label = labelAbove [Font.size 14] (text "Nome")
                              }
                          ]
            ]
        ]
        
        
        