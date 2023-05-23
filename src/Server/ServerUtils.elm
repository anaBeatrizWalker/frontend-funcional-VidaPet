module Server.ServerUtils exposing (..)

import Html exposing (..)
import Http
import Server.Adm exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Border as Border
import Utils.Colors exposing (gray1, gray3)


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