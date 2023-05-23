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
  row 
    [ 
      width fill
      , height fill
    ] 
    [
      el --Menu lateral
        [ 
          width (px 200)
          , height fill
          , Background.color blue3
        ]
        (menuLayout "./../../../assets/atendente.jpg" lightBlue3)
    , el --Corpo
        [ 
          width fill
          , height fill
        ]
        (column [ width fill, height fill, padding 50, centerX, centerY, spacing 30, Background.color gray1 ] 
          [ 
            headerLayout blue3 lightBlue3 --título de bem-vindo, subtítulo como nome da tabela, botões de adicionar novo e filtrar dados da tabela
          , tableLayout --tabela de dados
          ]
        )
    ]