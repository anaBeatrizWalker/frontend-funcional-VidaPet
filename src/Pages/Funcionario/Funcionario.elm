module Pages.Funcionario.Funcionario exposing (..)

import Html exposing (Html)
import Element exposing (..)
import Element.Background as Background
import Components.Menu exposing (menuLayout)
import Components.Header exposing (headerLayout)
import Components.Table exposing (tableLayout)
import Utils.Colors exposing (blue2, lightBlue2, gray1)

main : Html msg
main = layout [] view

view : Element msg
view = 
  row [ width fill, height fill ] 
    [
      el [ width (px 200), height fill, Background.color blue2 ]  --Menu lateral
        (menuLayout "./../../../assets/funcionaria.jpg" lightBlue2)
    , el [ width fill, height fill ] --Corpo
        (column [ width fill, height fill, padding 50, centerX, centerY, spacing 30, Background.color gray1 ] 
          [ 
            headerLayout blue2 lightBlue2 "Lista de Agendamentos" --Cabeçalho
          , tableLayout --tabela de dados
          ]
        )
    ]