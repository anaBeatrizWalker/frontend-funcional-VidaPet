module Main exposing(..)

import Html exposing (Html)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Menu exposing (menu)
import Table exposing (tableData)

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
          , Background.color (rgb255 0xF6 0xF5 0xFA) 
        ]
        (menu)
    , el --Corpo
        [ 
          width fill
          , height fill
          , Background.color (rgb255 0xFF 0xFF 0xFF) 
        ]
        (column
          [] 
          [ 
            titles --título
          , tableData --tabela de dados
          ]
        )
    ]
    
titles : Element msg
titles = 
    paragraph []
        [ 
          el [ Font.bold ] (text "Bem-vindo(a), ")
        , text "Ana Beatriz"
        ]