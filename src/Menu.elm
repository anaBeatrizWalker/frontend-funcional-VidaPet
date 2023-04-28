module Menu exposing (..)

import Ant.Icon as Icon
import Ant.Icons as Icons
import Element exposing (..)
import Element.Border as Border
import Element.Input as Input

menu : Element msg
menu = 
  (column
    [ centerY, spacing 100]

    [ el --foto de perfil do usuário
         [ centerX ]
        (image 
           [
             width (px 90)
            , clip
            , Border.rounded 100
            ] 
          {src = "https://picsum.photos/300/300", description = "Foto de perfil do usuário logado"})

    , column --coluna de botões
        [ centerX, spacing 40 ] 
        [
          el [ ] (
              row [] 
                [
                  Icons.homeFilled [Icon.width 24,  Icon.fill (rgb255 0x5 0x5 0x5)]
                  , Input.button 
                    [ Border.color blue
                    ] 
                    {onPress = Nothing, label = text "Agenda"}
                ]
            )
          , el [ ] (
              row [] 
              [
                 Icons.userOutlined [Icon.width 24, Icon.fill (rgb255 0xCC 0xCC 0xCC)]
                , Input.button 
                    [ Border.color blue
                    ] 
                    {onPress = Nothing, label = text "Clientes"}
              ]
            )
          , el [ ] (
              row [] 
              [
                Icons.idcardFilled [Icon.width 24, Icon.fill (rgb255 0xCC 0xCC 0xCC)]
               , Input.button 
                  [ Border.color blue
                  ] 
                  {onPress = Nothing, label = text "Funcionários"}
              ]
            
            )
          , el [ ] (
              row [] 
              [
                Icons.contactsFilled [Icon.width 24, Icon.fill (rgb255 0xCC 0xCC 0xCC)]
                , Input.button 
                  [ Border.color blue
                  ] 
                  {onPress = Nothing, label = text "Atendentes"}
              ]
            )
          , el [ ] (
              row [] 
              [
                Icons.signalFilled [Icon.width 24, Icon.fill (rgb255 0xCC 0xCC 0xCC)]
                , Input.button 
                  [ Border.color blue
                  ] 
                  {onPress = Nothing, label = text "Administradores"}
              ]
            )
          , el [ ] (
              row [] 
              [
                Icons.editFilled [Icon.width 24, Icon.fill (rgb255 0xCC 0xCC 0xCC)]
                , Input.button 
                  [ Border.color blue
                  ] 
                  {onPress = Nothing, label = text "Editar"}
              ]
            )
          , el [ ] (
              row [] 
              [
                Icons.poweroffOutlined [Icon.width 24, Icon.fill (rgb255 0xCC 0xCC 0xCC)]
                , Input.button 
                  [ Border.color blue
                  ] 
                  {onPress = Nothing, label = text "Sair"}
              ]
            )
        ]
    ]
  )

blue : Color
blue =
    Element.rgb255 238 238 238