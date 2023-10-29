module Components.MenuAtendente exposing (..)

import Element exposing (..)
import Element.Border as Border
import Element.Font as Font

import Components.Buttons exposing ( scheduleButtonMenu, clientsButtonMenu, editAccountButtonMenu, logoutButtonMenu)
import Utils.Colors exposing (white)

menuLayout : String -> Color -> Element msg
menuLayout srcImage btnLightColor  = 
  (column
    [ height (px 700), centerX, centerY, spacing 50, Font.color white]

    [ el [ centerX ] --foto de perfil do usuári
        (image 
           [
             width (px 90)
            , clip
            , Border.rounded 100
            ] 
          {src = srcImage, description = "Foto de perfil do usuário logado"}
        )

    , 
      column [ alignLeft, spacing 20, Font.size 16 ] --coluna de botões
        [
          row []
              [ 
                scheduleButtonMenu btnLightColor "Agenda" "/atendente/agenda"
              ]
          , row [] 
              [
                clientsButtonMenu btnLightColor "Clientes" "/atendente/clientes"
              ]
          , row [] 
              [
                editAccountButtonMenu btnLightColor "Editar conta" Nothing
              ]
          , row [] 
              [
                logoutButtonMenu btnLightColor "Sair" Nothing
              ]
        ]
    ]
  )