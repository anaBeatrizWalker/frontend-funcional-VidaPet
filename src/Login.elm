module Login exposing (..)

import Html exposing (Html)
import Element exposing (..)

main : Html msg
main = layout [] view

view : Element msg
view = 
  row [ width fill, height fill ] 
    [
      column 
        [ 
          width fill
          , height fill
        ] 
        [
          row [ centerX, centerY ] [ text "Formulário de login" ]
        ]
      , column 
          [
            width fill
            , height fill
          ] 
          [
            row [ centerX, centerY ] [ text "Imagem e logo" ]
          ]
    ]