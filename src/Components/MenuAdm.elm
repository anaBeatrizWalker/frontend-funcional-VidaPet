module Components.MenuAdm exposing (..)

import Element exposing (..)
import Element.Border as Border
import Element.Font as Font

import Components.Buttons exposing (scheduleButtonMenu, clientsButtonMenu, employeesButtonMenu, attendantsButtonMenu, admsButtonMenu, editAccountButtonMenu, logoutButtonMenu)
import Utils.Colors exposing (white)

menuLayout : String -> Color -> Element msg
menuLayout srcImage btnLightColor = 
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
    
    , let
          agendaPath =
              "/adm/agenda"
          clientesPath = 
              "/adm/clientes"
          funcionariosPath = 
              "/adm/funcionarios"
          atendentesPath = 
              "/adm/atendentes"
          admsPath = 
              "/adm"
      in
      column [ alignLeft, spacing 20, Font.size 16 ] --coluna de botões
        [
          row [] 
              [
                scheduleButtonMenu btnLightColor "Agenda" agendaPath
              ] 
          , row [] 
              [
                clientsButtonMenu btnLightColor "Clientes" clientesPath
              ]
          , row [] 
              [
                employeesButtonMenu btnLightColor "Funcionários" funcionariosPath
              ]
          , row [] 
              [
                attendantsButtonMenu btnLightColor "Atendentes" atendentesPath
              ]
          , row [] 
              [
                admsButtonMenu btnLightColor "Administradores" admsPath
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