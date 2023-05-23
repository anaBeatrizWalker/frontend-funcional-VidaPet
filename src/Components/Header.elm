module Components.Header exposing (..)

import Element exposing (..)
import Element.Font as Font
import Element.Background as Background
import Components.Buttons exposing (buttonWithoutIcon)
import Utils.Colors exposing (gray1, white)

headerLayout : Color -> Color -> String -> Element msg
headerLayout btnColor btnLightColor tableName = 
    row [ width fill ] 
    [
        --Textos
        column [ width (fillPortion 4), alignBottom, spacing 45, Background.color gray1 ] 
            [
            row [width fill] 
                [
                    paragraph [ padding 5 ]
                    [ 
                        el [ Font.bold ] (text "Bem-vindo(a) ao VidaPet, ")
                        , text "Ana Beatriz"
                    ]
                ]
            , row [width fill ] 
                [
                    paragraph [ padding 5 ]
                    [ 
                        el [ Font.bold ] (text tableName ) --nome da tabela
                    ]
                ]
            ]
        --Botões
        , column [ width (fillPortion 1), alignBottom, spacing 50, Font.color white, Font.size 16 ] 
            [ 
            row [ spacing 10, centerX ] 
                [
                    buttonWithoutIcon btnColor btnLightColor "Novo" Nothing --botão de adicionar novo item na tabela
                    , buttonWithoutIcon btnColor btnLightColor "Todos" Nothing --botão de filtrar a tabela
                ]
            ]
    ]