module Components.Buttons exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Input as Input
import Element.Border as Border
import Utils.Colors as Color
import Utils.Icons exposing (..)

--Layout para colocar ícone e label juntos
labelAndIconLayout : Element msg -> String -> Element msg
labelAndIconLayout icon label =
    row [ width fill, height fill ]
        [ el [ width <| px 30, height <| px 30, alignLeft ] icon
        , el [ alignLeft ] <| text label
        ]

--Botão sem ícone
buttonWithoutIcon : Color -> Color -> String -> Maybe msg -> Element msg
buttonWithoutIcon color lightColor label action = 
    Input.button [
        padding 10
        , Border.rounded 10
        , Border.widthEach { bottom = 5, left = 50, right = 50, top = 5 }
        , Border.color color
        , Background.color color
        , mouseOver [ 
            Border.color lightColor
            , Background.color lightColor 
        ]
        ] 
        { onPress = action
        , label = text label
        } 

--Botões do Menu
scheduleButtonMenu : Color -> String -> Maybe msg -> Element msg
scheduleButtonMenu lightColor label action = 
    Input.button [
        padding 10
        , Border.rounded 10
        , mouseOver [ 
            Border.color lightColor
            , Background.color lightColor 
        ]
        ] 
        { onPress = action
        , label = labelAndIconLayout scheduleIcon label
        }

clientsButtonMenu : Color -> String -> Maybe msg -> Element msg
clientsButtonMenu lightColor label action = 
    Input.button [
        padding 10
        , Border.rounded 10
        , mouseOver [ 
            Border.color lightColor
            , Background.color lightColor 
        ]
        ] 
        { onPress = action
        , label = labelAndIconLayout userIcon label
        }

employeesButtonMenu : Color -> String -> Maybe msg -> Element msg
employeesButtonMenu lightColor label action = 
    Input.button [
        padding 10
        , Border.rounded 10
        , mouseOver [ 
            Border.color lightColor
            , Background.color lightColor 
        ]
        ] 
        { onPress = action
        , label = labelAndIconLayout userIcon2 label
        }

attendantsButtonMenu : Color -> String -> Maybe msg -> Element msg
attendantsButtonMenu lightColor label action = 
    Input.button [
        padding 10
        , Border.rounded 10
        , mouseOver [ 
            Border.color lightColor
            , Background.color lightColor 
        ]
        ] 
        { onPress = action
        , label = labelAndIconLayout userIcon3 label
        }

admsButtonMenu : Color -> String -> Maybe msg -> Element msg
admsButtonMenu lightColor label action = 
    Input.button [
        padding 10
        , Border.rounded 10
        , mouseOver [ 
            Border.color lightColor
            , Background.color lightColor 
        ]
        ] 
        { onPress = action
        , label = labelAndIconLayout userIcon4 label
        }

editAccountButtonMenu : Color -> String -> Maybe msg -> Element msg
editAccountButtonMenu lightColor label action = 
    Input.button [
        padding 10
        , Border.rounded 10
        , mouseOver [ 
            Border.color lightColor
            , Background.color lightColor 
        ]
        ] 
        { onPress = action
        , label = labelAndIconLayout editIcon label
        }

logoutButtonMenu : Color -> String -> Maybe msg -> Element msg
logoutButtonMenu lightColor label action = 
    Input.button [
        padding 10
        , Border.rounded 10
        , mouseOver [ 
            Border.color lightColor
            , Background.color lightColor 
        ]
        ] 
        { onPress = action
        , label = labelAndIconLayout logoutIcon label
        }

--Botões da tabela
editButtonTable : Maybe msg -> Element msg
editButtonTable action =
    Input.button
        [ padding 5
        , Border.rounded 5
        , mouseOver [ 
            Border.color Color.gray2
            , Background.color Color.gray2 
        ]
        ]
        { onPress = action
        , label = editIcon
        }

deleteButtonTable : Maybe msg -> Element msg
deleteButtonTable action =
    Input.button
        [ padding 5
        , Border.rounded 5
        , mouseOver [ 
            Border.color Color.gray2
            , Background.color Color.gray2 
        ]
        ]
        { onPress = action
        , label = deleteIcon
        }