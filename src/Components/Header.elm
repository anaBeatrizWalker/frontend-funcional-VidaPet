module Components.Header exposing (..)

import Element exposing (..)
import Element.Font as Font
import Element.Background as Background

import Components.Buttons exposing (addNewButton)
import Utils.Colors exposing (gray1, white)

headerLayout : Color -> Color -> String -> String -> String-> Element msg
headerLayout btnColor btnLightColor tableName buttonName buttonUrl= 
    row [ width fill ] 
    [
        --Textos
        column [ width (fillPortion 4), alignBottom, spacing 45, Background.color gray1 ] 
            [
            row [width fill] 
                [
                    paragraph [ padding 5 ]
                        [ 
                            el [ Font.bold ] (text "VidaPet ")
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
            if buttonName /= "" then
                row [ spacing 10, centerX ] 
                    [
                        addNewButton btnColor btnLightColor buttonName buttonUrl --botão de adicionar novo item na tabela
                        --, buttonWithoutIcon btnColor btnLightColor "Todos" Nothing --botão de filtrar a tabela
                    ]
            else 
                row [] []
            ]
            
    ]