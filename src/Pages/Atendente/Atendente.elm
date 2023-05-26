module Pages.Atendente.Atendente exposing (..)

import Html exposing (Html)
import Element exposing (..)
import Element.Background as Background
import Components.Menu exposing (menuLayout)
import Components.Header exposing (headerLayout)
import Components.Table exposing (tableLayout)
import Utils.Colors exposing (blue3, lightBlue3, gray1)

main : Html msg
main = layout [] view

view : Element msg
view = 
  row [ width fill, height fill ] 
    [
      el [ width (px 200), height fill, Background.color blue3 ] --Menu lateral
        (menuLayout "./../../../assets/atendente.jpg" lightBlue3)
    , el [ width fill, height fill ] --Corpo
        (column [ width fill, height fill, padding 50, centerX, centerY, spacing 30, Background.color gray1 ] 
          [ 
            headerLayout blue3 lightBlue3 "Lista de Agendamentos" --Cabeçalho
          , tableLayout --tabela de dados
          ]
        )
    ]