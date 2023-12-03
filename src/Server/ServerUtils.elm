module Server.ServerUtils exposing (..)

import Html exposing (..)
import Http
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Border as Border
import Utils.Colors exposing (gray1, gray3)


baseUrlDefault : String
baseUrlDefault = 
    -- "http://localhost:8080/"
    "https://vidapet-backend.herokuapp.com/"

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
            "Não foi possível fazer a requisição no momento."
    in
    Element.el [ width fill, height fill, Background.color gray1 ] (
        row [ centerX, centerY, Background.color gray3, Border.rounded 10, padding 30 ] [
            Element.textColumn [ spacing 10, padding 10 ]
                [ paragraph [ Font.bold ] [ Element.text errorHeading]
                , el [ alignLeft ] none
                , paragraph [] [ Element.text ("Erro: " ++ errorMessage) ]
                ]
        ]
    )

viewCreateError : Maybe String -> Element msg
viewCreateError maybeError =
    case maybeError of
        Just error ->
            let
                errorHeading =
                    "Ops... algo deu errado ao criar um novo registro!"
            in
            Element.el [ width fill, height fill, Background.color gray1 ] (
                row [ centerX, centerY, Background.color gray3, Border.rounded 10, padding 30 ] [
                    Element.textColumn [ spacing 10, padding 10 ]
                        [ paragraph [ Font.bold ] [ Element.text errorHeading]
                        , el [ alignLeft ] none
                        , paragraph [] [ Element.text ("Erro: " ++ error) ]
                        ]
                ]
            )
        Nothing ->
            Element.text ""

viewEditError : Maybe String -> Element msg
viewEditError maybeError =
    case maybeError of
        Just error ->
            let
                errorHeading =
                    "Ops... algo deu errado ao atualizar o registro!"
            in
            Element.el [ width fill, height fill, Background.color gray1 ] (
                row [ centerX, centerY, Background.color gray3, Border.rounded 10, padding 30 ] [
                    Element.textColumn [ spacing 10, padding 10 ]
                        [ paragraph [ Font.bold ] [ Element.text errorHeading]
                        , el [ alignLeft ] none
                        , paragraph [] [ Element.text ("Erro: " ++ error) ]
                        ]
                ]
            )
        Nothing ->
            Element.text ""
     

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
                        [ paragraph [ Font.bold ] [ Element.text "Não foi possível excluir os dados no momento."]
                        , el [ alignLeft ] none
                        , paragraph [] [ Element.text ("Erro: " ++ error) ]
                        ]
                ]
            )
        Nothing ->
            Element.text ""

stringToFloat : String -> Float
stringToFloat str =
    let
        maybeNum = String.toFloat str
    in
    case maybeNum of
        Just num -> num
        Nothing -> 0.0

stringToInt : String -> Int
stringToInt str =
    let
        maybeNum = String.toInt str
    in
    case maybeNum of
        Just num -> num
        Nothing -> 0