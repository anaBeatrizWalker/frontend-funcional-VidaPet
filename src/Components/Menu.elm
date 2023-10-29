module Components.Menu exposing (..)

import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Components.Buttons exposing (scheduleButtonMenu, clientsButtonMenu, employeesButtonMenu, attendantsButtonMenu, admsButtonMenu, editAccountButtonMenu, logoutButtonMenu)
import Utils.Colors exposing (white)

menuLayout : String -> Color -> String -> Element msg
menuLayout srcImage btnLightColor defaultUrl = 
  (column
    [ height (px 700), centerX, centerY, spacing 50, Font.color white]

    [ el [ centerX ] --foto de perfil do usuário
        (image 
           [
             width (px 90)
            , clip
            , Border.rounded 100
            ] 
          {src = srcImage, description = "Foto de perfil do usuário logado"}
        )

    , column [ alignLeft, spacing 20, Font.size 16 ] --coluna de botões
        [
          row [] 
              [
                scheduleButtonMenu btnLightColor "Agenda" defaultUrl
              ] 
          , row [] 
              [
                clientsButtonMenu btnLightColor "Clientes" defaultUrl
              ]
          , row [] 
              [
                employeesButtonMenu btnLightColor "Funcionários" defaultUrl
              ]
          , row [] 
              [
                attendantsButtonMenu btnLightColor "Atendentes" defaultUrl
              ]
          , row [] 
              [
                admsButtonMenu btnLightColor "Administradores" defaultUrl
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