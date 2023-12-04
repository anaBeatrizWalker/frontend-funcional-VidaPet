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

--Botão sem ícone do componente Header
addNewButton : Color -> Color -> String -> String -> Element msg
addNewButton color lightColor label url = 
    link [
        padding 10
        , Border.rounded 10
        , Border.widthEach { bottom = 5, left = 50, right = 50, top = 5 }
        , Border.color color
        , Background.color color
        , focused [ 
            Border.color lightColor
            , Background.color lightColor
        ]
        , mouseOver [ 
            Border.color lightColor
            , Background.color lightColor 
        ]
        ] 
        { url = url
        , label = text label
        } 

--Botões do Menu
scheduleButtonMenu : Color -> String -> String -> Element msg
scheduleButtonMenu lightColor label url = 
    link [
        padding 10
        , Border.rounded 10
        , focused [ 
            Border.color lightColor
            , Background.color lightColor
        ]
        , mouseOver [ 
            Border.color lightColor
            , Background.color lightColor 
        ]
        ] 
        { url = url
        , label = labelAndIconLayout scheduleIcon label
        }

clientsButtonMenu : Color -> String -> String -> Element msg
clientsButtonMenu lightColor label url = 
    link [
        padding 10
        , Border.rounded 10
        , focused [ 
            Border.color lightColor
            , Background.color lightColor
        ]
        , mouseOver [ 
            Border.color lightColor
            , Background.color lightColor 
        ]
        ] 
        { url = url
        , label = labelAndIconLayout userIcon label
        }

animaisButtonMenu : Color -> String -> String -> Element msg
animaisButtonMenu lightColor label url   = 
    link [
        padding 10
        , Border.rounded 10
        , focused [ 
            Border.color lightColor
            , Background.color lightColor
        ]
        , mouseOver [ 
            Border.color lightColor
            , Background.color lightColor 
        ]
        ] 
        { url = url 
        , label = labelAndIconLayout userIcon label
        }

employeesButtonMenu : Color -> String -> String -> Element msg
employeesButtonMenu lightColor label url = 
    link [
        padding 10
        , Border.rounded 10
        , focused [ 
            Border.color lightColor
            , Background.color lightColor
        ]
        , mouseOver [ 
            Border.color lightColor
            , Background.color lightColor 
        ]
        ] 
        { url = url 
        , label = labelAndIconLayout userIcon2 label
        }

attendantsButtonMenu : Color -> String -> String -> Element msg
attendantsButtonMenu lightColor label url = 
    link [
        padding 10
        , Border.rounded 10
        , focused [ 
            Border.color lightColor
            , Background.color lightColor
        ]
        , mouseOver [ 
            Border.color lightColor
            , Background.color lightColor 
        ]
        ] 
        { url = url 
        , label = labelAndIconLayout userIcon3 label
        }

admsButtonMenu : Color -> String -> String -> Element msg
admsButtonMenu lightColor label url = 
    link [
        padding 10
        , Border.rounded 10
        , focused [ 
            Border.color lightColor
            , Background.color lightColor
        ]
        , mouseOver [ 
            Border.color lightColor
            , Background.color lightColor 
        ]
        ] 
        { url = url 
        , label = labelAndIconLayout userIcon4 label
        }

editAccountButtonMenu : Color -> String -> Maybe msg -> Element msg
editAccountButtonMenu lightColor label action = 
    Input.button [
        padding 10
        , Border.rounded 10
        , focused [ 
            Border.color lightColor
            , Background.color lightColor
        ]
        , mouseOver [ 
            Border.color lightColor
            , Background.color lightColor 
        ]
        ] 
        { onPress = action
        , label = labelAndIconLayout editIconMenu label
        }

logoutButtonMenu : Color -> String -> Maybe msg -> Element msg
logoutButtonMenu lightColor label action = 
    Input.button [
        padding 10
        , Border.rounded 10
        , focused [ 
            Border.color lightColor
            , Background.color lightColor
        ]
        , mouseOver [ 
            Border.color lightColor
            , Background.color lightColor 
        ]
        ] 
        { onPress = action
        , label = labelAndIconLayout logoutIcon label
        }

--Botões da tabela (estáticos)
editButtonTable : String -> Element msg
editButtonTable url =
    link
        [ padding 5
        , Border.rounded 5
        , focused [ 
            Border.color Color.gray2
        ]
        , mouseOver [ 
            Border.color Color.gray2
            , Background.color Color.gray2 
        ]
        ]
        { url = url
        , label = editIconTable
        }

deleteButtonTable : Maybe msg -> Element msg
deleteButtonTable action =
    Input.button
        [ padding 5
        , Border.rounded 5
        , focused [ 
            Border.color Color.gray2
        ]
        , mouseOver [ 
            Border.color Color.gray2
            , Background.color Color.gray2 
        ]
        ]
        { onPress = action
        , label = deleteIcon
        }

--Botões da tabela (com cliques)
deleteItemButton : msg -> Element msg
deleteItemButton clickAction =
    Input.button
        [ padding 5
        , Border.rounded 5
        , focused [ 
            Border.color Color.gray2
        ]
        , mouseOver [ 
            Border.color Color.gray2
            , Background.color Color.gray2 
        ]
        ]
        { onPress = Just clickAction
        , label = deleteIcon
        }

