module Components.MenuCliente exposing (..)

import Element exposing (..)
import Element.Border as Border
import Element.Font as Font

import Components.Buttons exposing (scheduleButtonMenu, animaisButtonMenu, editAccountButtonMenu, logoutButtonMenu)
import Utils.Colors exposing (white)
import Utils.Icons exposing (..)

import Server.Cliente as Cliente
import Server.Cliente exposing (ClieId)

menuLayout : ClieId ->  String -> Color -> Element msg
menuLayout id srcImage btnLightColor = 

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
    , 
      let
          agendaPath =
              "/cliente/agenda/" ++ Cliente.clieIdToString id
          animaisPath = 
              "/cliente/animais/" ++ Cliente.clieIdToString id
      in
      column [ alignLeft, spacing 20, Font.size 16 ] --coluna de botões
        [
            row []
              [ 
                scheduleButtonMenu btnLightColor "Agenda" agendaPath
              ]
          , row []
              [ 
                animaisButtonMenu btnLightColor "Meus pet's" animaisPath
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

-- menuLayout : WebData Cliente -> String -> Color -> Element Msg
-- menuLayout clientData srcImage btnLightColor =
--     RemoteData.fold
--         { notAsked = -- O que fazer quando for RemoteData.NotAsked
--             (column [] [ text "Loading..." ]) -- Exemplo, você pode mostrar uma mensagem de carregamento aqui

--         , loading = -- O que fazer quando for RemoteData.Loading
--             (column [] [ text "Loading..." ]) -- Exemplo, você pode mostrar uma mensagem de carregamento aqui

--         , success = \cliente -> -- O que fazer quando for RemoteData.Success
--             column
--                 [ height (px 700)
--                 , centerX
--                 , centerY
--                 , spacing 50
--                 , Font.color white
--                 ]
--                 [ el [ centerX ]
--                     (image
--                         [ width (px 90)
--                         , clip
--                         , Border.rounded 100
--                         ]
--                         { src = srcImage, description = "Foto de perfil do usuário logado" }
--                     )
--                 , column [ alignLeft, spacing 20, Font.size 16 ]
--                     [ -- Seu código para a coluna de botões aqui, usando `cliente` normalmente
--                     ]
--                 ]

--         , failure = \_ -> -- O que fazer quando for RemoteData.Failure
--             (column [] [ text "Erro ao carregar cliente" ]) -- Exemplo, você pode mostrar uma mensagem de erro aqui
--         }
--         clientData


