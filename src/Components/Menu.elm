module Components.Menu exposing (..)

import Element exposing (..)
import Element.Border as Border
import Components.Buttons exposing (scheduleButtonMenu, clientsButtonMenu, employeesButtonMenu, attendantsButtonMenu, admsButtonMenu, editAccountButtonMenu, logoutButtonMenu)

menuLayout : String -> Color -> Element msg
menuLayout srcImage btnLightColor = 
  (column
    [ height (px 700), centerX, centerY, spacing 50]

    [ el [ centerX ] --foto de perfil do usuári
        (image 
           [
             width (px 90)
            , clip
            , Border.rounded 100
            ] 
          {src = srcImage, description = "Foto de perfil do usuário logado"}
        )

    , column [ alignLeft, spacing 20 ] --coluna de botões
        [
          row [] 
              [
                scheduleButtonMenu btnLightColor "Agenda" Nothing
              ] 
          , row [] 
              [
                clientsButtonMenu btnLightColor "Clientes" Nothing
              ]
          , row [] 
              [
                employeesButtonMenu btnLightColor "Funcionários" Nothing
              ]
          , row [] 
              [
                attendantsButtonMenu btnLightColor "Atendentes" Nothing
              ]
          , row [] 
              [
                admsButtonMenu btnLightColor "Administradores" Nothing
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