module Utils.Icons exposing (..)

import Ant.Icon exposing (fill, height, width)
import Ant.Icons as Icons
import Element exposing (Element)
import Utils.Colors exposing (gray4, red)


editIcon : Element msg
editIcon =
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
        , fill gray4
        ]

userIcon : Element msg
userIcon = 
    Icons.userOutlined
        [ width 24
        , height 24
        , fill gray4
        ]

userIcon2 : Element msg
userIcon2 = 
    Icons.idcardFilled
        [ width 24
        , height 24
        , fill gray4
        ]

userIcon3 : Element msg
userIcon3 =
    Icons.contactsFilled
        [ width 24
        , height 24
        , fill gray4
        ]

userIcon4 : Element msg
userIcon4 =
    Icons.signalFilled
        [ width 24
        , height 24
        , fill gray4
        ]
    
logoutIcon : Element msg
logoutIcon =
    Icons.poweroffOutlined
        [ width 24
        , height 24
        , fill gray4
        ]