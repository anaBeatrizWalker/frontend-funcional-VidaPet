module Components.Table exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font

import Utils.Colors exposing (gray2)

--Cabeçalho da tabela
tableHeader : String -> Element msg
tableHeader titleColumn = row [ Font.bold, Font.size 18, Background.color gray2, padding 15 ] [text titleColumn]

--Dados da tabela
tableData : String -> Element msg
tableData data = row [ padding 10, Font.size 16, Border.color gray2, Border.widthEach {bottom = 0, left = 0, top = 1, right = 0} ] [text data]