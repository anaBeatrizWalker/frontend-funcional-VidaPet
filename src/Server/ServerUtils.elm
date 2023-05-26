module Server.ServerUtils exposing (..)

import Html exposing (..)
import Http
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Border as Border
import Utils.Colors exposing (gray1, gray3)

viewNoAskedMsg : Element msg
viewNoAskedMsg  = 
    Element.el [ width fill, height fill, Background.color gray1 ] 
    (
        row [ centerX, centerY, Background.color gray3, Border.rounded 10, padding 30 ] 
        [
            Element.textColumn [ spacing 10, padding 10 ]
            [ paragraph [ Font.bold ] 
                [ Element.text "Not Asked for Data..."]
            ]
        ]
    )

viewLoagindMsg : Element msg
viewLoagindMsg = 
    Element.el [ width fill, height fill, Background.color gray1 ] 
    (
        row [ centerX, centerY, Background.color gray3, Border.rounded 10, padding 30 ] 
        [
            Element.textColumn [ spacing 10, padding 10 ]
            [ paragraph [ Font.bold ] 
                [ Element.text "Carregando dados..."]
            ]
        ]
    )


viewError : String -> Element msg
viewError errorMessage =
    let
        errorHeading =
            "Couldn't fetch data at this time."
    in
    Element.el [ width fill, height fill, Background.color gray1 ] (
        row [ centerX, centerY, Background.color gray3, Border.rounded 10, padding 30 ] [
            Element.textColumn [ spacing 10, padding 10 ]
                [ paragraph [ Font.bold ] [ Element.text errorHeading]
                , el [ alignLeft ] none
                , paragraph [] [ Element.text ("Error " ++ errorMessage) ]
                ]
        ]
    )

buildErrorMessage : Http.Error -> String
buildErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "Unable to reach server."

        Http.BadStatus statusCode ->
            "Request failed with status code: " ++ String.fromInt statusCode

        Http.BadBody message ->
            message

viewDeleteError : Maybe String -> Element msg
viewDeleteError maybeError =
    case maybeError of
        Just error ->
            Element.el [ width fill, height fill, Background.color gray1 ] (
                row [ centerX, centerY, Background.color gray3, Border.rounded 10, padding 30 ] [
                    Element.textColumn [ spacing 10, padding 10 ]
                        [ paragraph [ Font.bold ] [ Element.text "Couldn't delete data at this time."]
                        , el [ alignLeft ] none
                        , paragraph [] [ Element.text ("Error " ++ error) ]
                        ]
                ]
            )
        Nothing ->
            Element.text ""