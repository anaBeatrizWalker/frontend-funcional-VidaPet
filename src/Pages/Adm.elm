module Pages.Adm exposing (..)

import Html exposing (Html)
import Element exposing (..)
import Element.Background as Background
import Components.Menu exposing (menuLayout)
import Components.Header exposing (headerLayout)
import Components.Table exposing (tableLayout)
import Utils.Colors exposing (green, lightGreen, gray1)

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
          , Background.color green
        ]
        (menuLayout "./../../assets/administradora.jpg" lightGreen)
    , el --Corpo
        [ 
          width fill
          , height fill
        ]
        (column [ width fill, height fill, padding 50, centerX, centerY, spacing 30, Background.color gray1 ] 
          [ 
            headerLayout green lightGreen --título de bem-vindo, subtítulo como nome da tabela, botões de adicionar novo e filtrar dados da tabela
          , tableLayout --tabela de dados
          ]
        )
    ]