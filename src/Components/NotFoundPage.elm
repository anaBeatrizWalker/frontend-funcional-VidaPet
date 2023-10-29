module Components.NotFoundPage exposing (notFoundView)

import Html exposing (Html, div, h1, p, text, table, thead, tr, th,tbody, td)
import Html.Attributes exposing (class, style)

notFoundView : Html msg
notFoundView =
     div
        [ class "not-found-container"
        , style "background-color" "#f2f2f2"
        , style "text-align" "center"
        , style "color" "#555555"
        , style "padding" "20px"
        , style "position" "absolute"
        , style "top" "50%"
        , style "left" "50%"
        , style "transform" "translate(-50%, -50%)"
        , style "width" "50%"
        , style "font-family" "Arial, sans-serif"
        ]
        [ h1 [ style "font-size" "2em", style "margin-bottom" "20px" ] [ text "Página não encontrada" ]
        , p [ style "font-size" "1.2em", style "margin-bottom" "20px" ] [ text "A rota que você está tentando acessar não existe." ]
        , p [] [ text "Confira as rotas existentes dessa aplicação:" ]
        , table
            [ style "width" "100%", style "margin" "20px auto", style "border-collapse" "collapse" ]
            [ thead []
                [ tr []
                    [ th [ style "padding" "10px", style "border" "1px solid #ddd", style "background-color" "#ddd"  ] [ text "Rotas do administrador" ]
                    , th [ style "padding" "10px", style "border" "1px solid #ddd", style "background-color" "#ddd"  ] [ text "Rotas dos atendentes" ]
                    , th [ style "padding" "10px", style "border" "1px solid #ddd", style "background-color" "#ddd"  ] [ text "Rotas dos funcionários" ]
                    , th [ style "padding" "10px", style "border" "1px solid #ddd", style "background-color" "#ddd"  ] [ text "Rotas dos clientes" ]
                    ]
                ]
            , tbody []
                [ tr []
                    [ td [ style "padding" "10px", style "border" "1px solid #ddd" ] [ text "/adm" ]
                    , td [ style "padding" "10px", style "border" "1px solid #ddd" ] [ text "/atendente/agenda" ]
                    , td [ style "padding" "10px", style "border" "1px solid #ddd" ] [ text "/funcionario/agenda/{id}" ]
                    , td [ style "padding" "10px", style "border" "1px solid #ddd" ] [ text "/cliente/agenda/{id}" ]
                    ]
                , tr []
                    [ td [ style "padding" "10px", style "border" "1px solid #ddd" ] [ text "/adm/agenda" ]
                    , td [ style "padding" "10px", style "border" "1px solid #ddd" ] [ text "/atendente/clientes" ]
                    , td [ style "padding" "10px", style "border" "1px solid #ddd" ] [ text "-" ]
                    , td [ style "padding" "10px", style "border" "1px solid #ddd" ] [ text "/cliente/animais/{id}" ]
                    ]
                , tr []
                    [ td [ style "padding" "10px", style "border" "1px solid #ddd" ] [ text "/adm/atendentes" ]
                    , td [ style "padding" "10px", style "border" "1px solid #ddd" ] [ text "-" ]
                    , td [ style "padding" "10px", style "border" "1px solid #ddd" ] [ text "-" ]
                    , td [ style "padding" "10px", style "border" "1px solid #ddd" ] [ text "-" ]
                    ]
                , tr []
                    [ td [ style "padding" "10px", style "border" "1px solid #ddd" ] [ text "/adm/funcionarios" ]
                    , td [ style "padding" "10px", style "border" "1px solid #ddd" ] [ text "-" ]
                    , td [ style "padding" "10px", style "border" "1px solid #ddd" ] [ text "-" ]
                    , td [ style "padding" "10px", style "border" "1px solid #ddd" ] [ text "-" ]
                    ]
                , tr []
                    [ td [ style "padding" "10px", style "border" "1px solid #ddd" ] [ text "/adm/clientes" ]
                    , td [ style "padding" "10px", style "border" "1px solid #ddd" ] [ text "-" ]
                    , td [ style "padding" "10px", style "border" "1px solid #ddd" ] [ text "-" ]
                    , td [ style "padding" "10px", style "border" "1px solid #ddd" ] [ text "-" ]
                    ]
                ]
            ]
        ]
