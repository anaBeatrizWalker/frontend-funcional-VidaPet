module Utils.Icons exposing (..)

import Ant.Icon exposing (fill, height, width)
import Ant.Icons as Icons
import Element exposing (Element)
import Utils.Colors exposing (gray4, white, red)


editIconTable : Element msg
editIconTable =
    Icons.formOutlined
        [ width 24
        , height 24
        , fill gray4
        ]
    
deleteIcon : Element msg
deleteIcon = 
    Icons.deleteOutlined
        [ width 24
        , height 24
        , fill red
        ]
        
scheduleIcon : Element msg
scheduleIcon =
    Icons.calendarFilled
        [ width 24
        , height 24
        , fill white
        ]

userIcon : Element msg
userIcon = 
    Icons.userOutlined
        [ width 24
        , height 24
        , fill white
        ]

userIcon2 : Element msg
userIcon2 = 
    Icons.idcardFilled
        [ width 24
        , height 24
        , fill white
        ]

userIcon3 : Element msg
userIcon3 =
    Icons.contactsFilled
        [ width 24
        , height 24
        , fill white
        ]

userIcon4 : Element msg
userIcon4 =
    Icons.signalFilled
        [ width 24
        , height 24
        , fill white
        ]

editIconMenu : Element msg
editIconMenu =
    Icons.formOutlined
        [ width 24
        , height 24
        , fill white
        ]
    
logoutIcon : Element msg
logoutIcon =
    Icons.poweroffOutlined
        [ width 24
        , height 24
        , fill white
        ]