module Pages.Atendente.EditAgendamento exposing (..)

import Browser.Navigation as Nav
import Http
import Html as Html
import Html.Attributes exposing (type_, style, value, disabled)
import Html.Events exposing (onInput)
import Element exposing (..)
import Element.Input as Input
import Element.Background as Background
import Element.Border as Border
import RemoteData exposing (WebData)
import Json.Encode as Encode
import Json.Decode exposing (Decoder, string, float)
import Json.Decode.Pipeline exposing (required, optional)
import Json.Decode as Decode

import Components.MenuAtendente exposing (menuLayout)
import Components.Header exposing (headerLayout)
import Utils.Colors exposing (blue3, lightBlue3, gray1, gray1)
import Route

import Server.ServerUtils exposing (..)
import Server.Funcionario exposing (FuncId(..), ServId(..), Servico, stringToFloat, stringToFuncId, stringToServId, funcIdToString, servIdToString, funcIdEncoder, funcIdDecoder, servIdEncoder, servIdDecoder)
import Server.Cliente exposing (AnimId(..), NewAnimal,  animIdToString, newAgendamentoAnimalEncoder, newAgendamentoAnimalDecoder)
import Server.Agenda exposing (AgenId, agenIdToString, agendIdEncoder, agenIdDecoder)

type alias EditAgendamento = 
    {
        id : AgenId
        , funcionario : EditFuncionario
        , observacao : String
        , data : String
        , horario : String
        , animal : NewAnimal
    }

type alias EditFuncionario = 
    {
        id : FuncId
        , nome : String
        , servico : Servico
    }

type alias Model =
    { navKey : Nav.Key
    , agendamento : WebData EditAgendamento
    , saveError : Maybe String
    }


init : AgenId -> Nav.Key -> ( Model, Cmd Msg )
init agendaId navKey =
    ( initialModel navKey, getAgendamentoById agendaId )


initialModel : Nav.Key -> Model
initialModel navKey =
    { navKey = navKey
    , agendamento = RemoteData.Loading
    , saveError = Nothing
    }


type Msg
    = AgendamentoReceived (WebData EditAgendamento)    
    | FuncionarioId String
    | FuncionarioNome String
    | FuncServicoId String
    | FuncServicoNome String
    | FuncServicoPreco String
    | Observacao String
    | Data String
    | Horario String
    | AnimalId String
    | AnimalNome String 
    | SaveAgendamento
    | AgendamentoSaved (Result Http.Error EditAgendamento)

view : Model -> Html.Html Msg
view model = 
    Element.layout [] <|
        row [ width fill, height fill ] 
        [
            el [ width (px 200), height fill, Background.color blue3 ]
            (  menuLayout "./../../../assets/atendente.jpg" lightBlue3 )
        , el [ width fill, height fill ]
            (column [ width fill, height fill, padding 50, centerX, centerY, spacing 30, Background.color gray1 ] 
                [ 
                headerLayout blue3 lightBlue3 "Editar agendamento" "" ""
                , viewFormOrError model.agendamento
                , viewEditError model.saveError
                , el [ alignRight ] --botao de Adicionar
                    (
                    Input.button [
                        padding 10
                        , Border.rounded 10
                        , Border.widthEach { bottom = 5, left = 50, right = 50, top = 5 }
                        , Border.color blue3
                        , Background.color blue3
                        , focused [ 
                            Border.color lightBlue3
                            , Background.color lightBlue3
                        ]
                        , mouseOver [ 
                            Border.color lightBlue3
                            , Background.color lightBlue3 
                        ]
                        ] 
                        { onPress = Just (SaveAgendamento)
                        , label = text "Adicionar"
                        } 
                    )
                ]
            )
        ]

viewFormOrError : WebData EditAgendamento -> Element Msg
viewFormOrError agendamento =
    case agendamento of
        RemoteData.NotAsked ->
            viewNoAskedMsg

        RemoteData.Loading ->
            viewLoagindMsg

        RemoteData.Success data ->
            viewForm data

        RemoteData.Failure httpError ->
            viewError (buildErrorMessage httpError)

viewForm : EditAgendamento -> Element Msg
viewForm  agendamento =
    Element.html <|
        Html.form [ style "width" "100%" ] [
            Html.div [ style "display" "flex"]
                [ Html.div [ style "flex" "1", style "padding-right" "10px"]
                    [ 
                        Html.label [ style "font-size" "16px" ] [ Html.text "ID do funcionário" ]
                        , Html.br [] []
                        , Html.input [ type_ "text", value (funcIdToString agendamento.funcionario.id), onInput FuncionarioId, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []

                        , Html.br [] []
                    
                        , Html.label [ style "font-size" "16px" ] [ Html.text "Nome do funcionário" ]
                        , Html.br [] []
                        , Html.input [ type_ "text", value agendamento.funcionario.nome,onInput FuncionarioNome, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []

                        , Html.br [] []
                    
                        , Html.label [ style "font-size" "16px" ] [ Html.text "ID do Serviço" ]
                        , Html.br [] []
                        , Html.input [ type_ "text", value (servIdToString agendamento.funcionario.servico.id), onInput FuncServicoId, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []
                        
                        , Html.br [] []
                    
                        , Html.label [ style "font-size" "16px" ] [ Html.text "Nome do Serviço" ]
                        , Html.br [] []
                        , Html.input [ type_ "text", value agendamento.funcionario.servico.nome,onInput FuncServicoNome, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []

                        , Html.br [] []
                    
                        , Html.label [ style "font-size" "16px" ] [ Html.text "Preço do Serviço" ]
                        , Html.br [] []
                        , Html.input [ type_ "text", value (String.fromFloat agendamento.funcionario.servico.preco), onInput FuncServicoPreco, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []
                        
                        , Html.br [] []
                    
                        , Html.label [ style "font-size" "16px" ] [ Html.text "Observação" ]
                        , Html.br [] []
                        , Html.input [ type_ "text", value agendamento.observacao, onInput Observacao, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []

                        , Html.div [ style "display" "flex" ] 
                            [
                                Html.div [ style "flex" "1", style "padding-right" "50px"] 
                                    [
                                        Html.div []
                                            [ Html.label [ style "font-size" "16px" ] [ Html.text "Data" ]
                                            , Html.br [] []
                                            , Html.input [ type_ "text", 
                                            value agendamento.data
                                            , onInput Data, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []
                                            ]
                                        
                                    ]
                                , Html.div [ style "flex" "1"] 
                                    [
                                        Html.div []
                                            [ Html.label [ style "font-size" "16px" ] [ Html.text "Horário" ]
                                            , Html.br [] []
                                            , Html.input [ type_ "text",
                                            value agendamento.horario, onInput Horario, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []
                                            ]
                                    ]
                            ]
                        
                        
                    ]
                , Html.div [ style "flex" "1", style "padding-left" "10px" ]
                    [ 
                        Html.label [ style "font-size" "16px" ] [ Html.text "ID do Animal" ]
                        , Html.br [] []
                        , Html.input [ type_ "text", value (animIdToString agendamento.animal.id), onInput AnimalId, disabled True, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []

                        , Html.br [] []
                        , Html.label [ style "font-size" "16px" ] [ Html.text "Nome do Animal" ]
                        , Html.br [] []
                        , Html.input [ type_ "text", value agendamento.animal.nome, onInput AnimalNome, disabled True, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []
                    ]
            ]
        ]
    

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AgendamentoReceived agendamento ->
            ({model | agendamento = agendamento}, Cmd.none)

        FuncionarioId id ->
            let
                updateFuncionario funcionario =
                    { funcionario | id = stringToFuncId id }

                updateAgendamento agendamento =
                    { agendamento | funcionario = updateFuncionario agendamento.funcionario }

                updatedAgendamento =
                    RemoteData.map updateAgendamento model.agendamento
            in
            ( { model | agendamento = updatedAgendamento }, Cmd.none )

        FuncionarioNome novoNome ->
            let
                updateFuncionario funcionario =
                    { funcionario | nome = novoNome }

                updateAgendamento agendamento =
                    { agendamento | funcionario = updateFuncionario agendamento.funcionario }

                updatedAgendamento =
                    RemoteData.map updateAgendamento model.agendamento
            in
            ( { model | agendamento = updatedAgendamento }, Cmd.none )

        FuncServicoId id ->
            let
                updateServico servico =
                    { servico | id = stringToServId id }

                updateFuncionario funcionario =
                    { funcionario | servico = updateServico funcionario.servico }

                updateAgendamento agendamento =
                    { agendamento | funcionario = updateFuncionario agendamento.funcionario }

                updatedAgendamento =
                    RemoteData.map updateAgendamento model.agendamento
            in
            ( { model | agendamento = updatedAgendamento }, Cmd.none )

        FuncServicoNome nome ->
            let
                updateServico servico =
                    { servico | nome = nome }

                updateFuncionario funcionario =
                    { funcionario | servico = updateServico funcionario.servico }

                updateAgendamento agendamento =
                    { agendamento | funcionario = updateFuncionario agendamento.funcionario }

                updatedAgendamento =
                    RemoteData.map updateAgendamento model.agendamento
            in
            ( { model | agendamento = updatedAgendamento }, Cmd.none )


        FuncServicoPreco preco ->
            let
                updateServico servico =
                    { servico | preco = stringToFloat preco }

                updateFuncionario funcionario =
                    { funcionario | servico = updateServico funcionario.servico }

                updateAgendamento agendamento =
                    { agendamento | funcionario = updateFuncionario agendamento.funcionario }

                updatedAgendamento =
                    RemoteData.map updateAgendamento model.agendamento
            in
            ( { model | agendamento = updatedAgendamento }, Cmd.none )

        Observacao observacao ->
            let
                oldAgend =
                    model.agendamento

                updateObs =
                    RemoteData.map
                        (\agendamento -> {agendamento | observacao = observacao})
                        oldAgend
            in
            ( { model | agendamento = updateObs }, Cmd.none )

        Data data ->
            let
                oldAgend =
                    model.agendamento

                updateData =
                   RemoteData.map
                        (\agendamento -> {agendamento | data = data})
                        oldAgend
            in
            ( { model | agendamento = updateData }, Cmd.none )

        Horario horario ->
            let
                oldAgend =
                    model.agendamento 

                updateHora =
                    RemoteData.map
                        (\agendamento -> {agendamento | horario = horario})
                        oldAgend

            in
            ({model | agendamento = updateHora}, Cmd.none)

        -- AnimalId id ->
        --     let
        --         oldAgend =
        --             model.agendamento

        --         oldAnimal =
        --             model.agendamento.animal

        --         updateAnimal =
        --             { oldAnimal | id = stringToAnimId id } 

        --         updateAgendamento =
        --             { oldAgend | animal = updateAnimal }
        --     in
        --     ( { model | agendamento = updateAgendamento }, Cmd.none )

        -- AnimalNome nome ->
        --     let
        --         oldAgend =
        --             model.agendamento

        --         oldAnimal =
        --             model.agendamento.animal

        --         updateAnimal =
        --             { oldAnimal | nome = nome } 

        --         updateAgendamento =
        --             { oldAgend | animal = updateAnimal }
        --     in
        --     ( { model | agendamento = updateAgendamento }, Cmd.none )

        SaveAgendamento ->
            ( model, editAgendamento model.agendamento )

        AgendamentoSaved (Ok agendamento) ->
            let
                agend =
                    RemoteData.succeed agendamento
            in
            ({model | agendamento = agend, saveError = Nothing}, Route.pushUrl Route.AllAgendaForAtend model.navKey)

        AgendamentoSaved (Err error) ->
            ( { model | saveError = Just (buildErrorMessage error) }
            , Cmd.none
            )
        
        _ ->
            (model, Cmd.none)

getAgendamentoById : AgenId -> Cmd Msg
getAgendamentoById agendaId =
    Http.get
        { url = baseUrlDefault ++ "agenda/" ++ agenIdToString agendaId
        , expect = 
            editAgendaDecoder 
                |> Http.expectJson (RemoteData.fromResult >> AgendamentoReceived)
        }

editAgendamento : WebData EditAgendamento -> Cmd Msg
editAgendamento agendamento =
    case agendamento of
        RemoteData.Success agend ->
            let
                agendUrl = "https://vidapet-backend.herokuapp.com/agenda/" ++ (agenIdToString agend.id)
            in
            Http.request
                { method = "PATCH"
                , headers = []
                , url = agendUrl
                , body = Http.jsonBody (editAgendaEncoder agend)
                , expect = Http.expectJson AgendamentoSaved editAgendaDecoder
                , timeout = Nothing
                , tracker = Nothing                
                }

        _ ->
            Cmd.none

editAgendaEncoder : EditAgendamento -> Encode.Value
editAgendaEncoder agendamento =
    Encode.object
        [ ("id", agendIdEncoder agendamento.id )
        , ( "funcionario",  editAgendamentoFuncionarioEncoder agendamento.funcionario )
        , ( "observacao", Encode.string agendamento.observacao )
        , ( "data", Encode.string agendamento.data )
        , ( "horario", Encode.string agendamento.horario )
        , ( "animal", newAgendamentoAnimalEncoder agendamento.animal )
        ]

editAgendamentoFuncionarioEncoder : EditFuncionario -> Encode.Value
editAgendamentoFuncionarioEncoder funcionario =
    Encode.object
        [ ( "id", funcIdEncoder funcionario.id )
        , ( "nome",  Encode.string funcionario.nome )
        , ( "servico",  editAgendamentoServicoEncoder funcionario.servico )
        ]

editAgendamentoServicoEncoder : Servico -> Encode.Value
editAgendamentoServicoEncoder servico =
    Encode.object
        [ ( "id", servIdEncoder servico.id )
        , ( "nome",  Encode.string servico.nome )
         , ( "preco",  Encode.float servico.preco )
        ]

editAgendaDecoder : Decoder EditAgendamento
editAgendaDecoder =
    Decode.succeed EditAgendamento 
        |> required "id" agenIdDecoder
        |> required "funcionario" editAgendamentoFuncionarioDecoder
        |> required "observacao" string
        |> required "data" string
        |> required "horario" string
        |> required "animal" newAgendamentoAnimalDecoder

editAgendamentoFuncionarioDecoder : Decoder EditFuncionario
editAgendamentoFuncionarioDecoder = 
    Decode.succeed EditFuncionario
        |> required "id" funcIdDecoder
        |> required "nome" string
        |> required "servico" editAgendamentoServicoDecoder

editAgendamentoServicoDecoder : Decoder Servico
editAgendamentoServicoDecoder = 
    Decode.succeed Servico
        |> required "id" servIdDecoder
        |> required "nome" string
        |> required "preco" float



