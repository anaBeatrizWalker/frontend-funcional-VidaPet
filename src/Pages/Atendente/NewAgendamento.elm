module Pages.Atendente.NewAgendamento exposing (..)

import Browser.Navigation as Nav
import Http
import Html as Html
import Html.Attributes exposing (type_, style)
import Html.Events exposing (onInput)
import Element exposing (..)
import Element.Input as Input
import Element.Background as Background
import Element.Border as Border
import Json.Decode exposing (Decoder)
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (required)
import Json.Decode exposing (string)
import Json.Encode as Encode

import Components.MenuAtendente exposing (menuLayout)
import Components.Header exposing (headerLayout)
import Utils.Colors exposing (blue3, lightBlue3, gray1, gray1)
import Route

import Server.Agenda exposing(..)
import Server.ServerUtils exposing (..)
import Server.Funcionario exposing (FuncId(..), ServId(..), stringToFuncId, stringToServId, funcIdEncoder, funcIdDecoder, servIdEncoder, servIdDecoder)
import Server.Cliente exposing (AnimId(..), NewAnimal, stringToAnimId, newAgendamentoAnimalDecoder, newAgendamentoAnimalEncoder)


type alias NewAgendamento = 
    {
        id : AgenId
        , funcionario : NewFuncionario
        , observacao : String
        , data : String
        , horario : String
        , animal : NewAnimal
    }

type alias NewFuncionario = 
    {
        id : FuncId
        , nome : String
        , servico : NewServico
    }

type alias NewServico = 
    {
        id : ServId
        , nome : String
    }

type alias Model =
    { navKey : Nav.Key
    , agendamento : NewAgendamento
    , createError : Maybe String
    }

type Msg
    = FuncionarioId String
    | FuncioarioNome String
    | FuncServicoId String
    | FuncServicoNome String
    | Observacao String
    | Data String
    | Horario String
    | AnimalId String
    | AnimalNome String
    | CreateAgendamento
    | AgendamentoCreated (Result Http.Error NewAgendamento)


init : Nav.Key -> ( Model, Cmd Msg )
init navKey =
    ( initialModel navKey, Cmd.none )


initialModel : Nav.Key -> Model
initialModel navKey =
    { 
      navKey = navKey
      , agendamento = emptyAgendamento
      , createError = Nothing
    }
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
                headerLayout blue3 lightBlue3 "Novo agendamento" "" ""
                , viewCreateError model.createError
                , Element.html <| viewForm 
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
                        { onPress = Just (CreateAgendamento)
                        , label = text "Adicionar"
                        } 
                    )
                ]
            )
        ]

viewForm : Html.Html Msg
viewForm =
    Html.form [ style "width" "100%" ] [
        Html.div [ style "display" "flex"]
            [ Html.div [ style "flex" "1", style "padding-right" "10px"]
                [ 
                    Html.label [ style "font-size" "16px" ] [ Html.text "ID do funcionário" ]
                    , Html.br [] []
                    , Html.input [ type_ "text", onInput FuncionarioId, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []

                    , Html.br [] []
                   
                    , Html.label [ style "font-size" "16px" ] [ Html.text "Nome do funcionário" ]
                    , Html.br [] []
                    , Html.input [ type_ "text", onInput FuncioarioNome, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []

                    , Html.br [] []
                
                    , Html.label [ style "font-size" "16px" ] [ Html.text "ID do Serviço" ]
                    , Html.br [] []
                    , Html.input [ type_ "text", onInput FuncServicoId, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []
                    
                    , Html.br [] []
                
                    , Html.label [ style "font-size" "16px" ] [ Html.text "Nome do Serviço" ]
                    , Html.br [] []
                    , Html.input [ type_ "text", onInput FuncServicoNome, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []
                    
                    , Html.br [] []
                               
                    , Html.label [ style "font-size" "16px" ] [ Html.text "Observação" ]
                    , Html.br [] []
                    , Html.input [ type_ "text", onInput Observacao, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []

                    , Html.div [ style "display" "flex" ] 
                        [
                            Html.div [ style "flex" "1", style "padding-right" "50px"] 
                                [
                                    Html.div []
                                        [ Html.label [ style "font-size" "16px" ] [ Html.text "Data" ]
                                        , Html.br [] []
                                        , Html.input [ type_ "text", onInput Data, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []
                                        ]
                                    
                                ]
                            , Html.div [ style "flex" "1"] 
                                [
                                    Html.div []
                                        [ Html.label [ style "font-size" "16px" ] [ Html.text "Horário" ]
                                        , Html.br [] []
                                        , Html.input [ type_ "text", onInput Horario, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []
                                        ]
                                ]
                        ]
                    
                    
                ]
            , Html.div [ style "flex" "1", style "padding-left" "10px" ]
                [ 
                    Html.label [ style "font-size" "16px" ] [ Html.text "ID do Animal" ]
                    , Html.br [] []
                    , Html.input [ type_ "text", onInput AnimalId, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []

                     , Html.br [] []
                    , Html.label [ style "font-size" "16px" ] [ Html.text "Nome do Animal" ]
                    , Html.br [] []
                    , Html.input [ type_ "text", onInput AnimalNome, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] []
                ]
        ]
    ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FuncionarioId id ->
            let
                oldAgend =
                    model.agendamento

                oldFuncionario =
                    model.agendamento.funcionario

                updateFuncionario =
                    { oldFuncionario | id = (stringToFuncId id) } 

                updateAgendamento =
                    { oldAgend | funcionario = updateFuncionario }
            in
            ( { model | agendamento = updateAgendamento }, Cmd.none )

        FuncioarioNome novoNome ->
            let
                oldAgend =
                    model.agendamento 

                oldFuncionario =
                    model.agendamento.funcionario

                updateFuncionario =
                    { oldFuncionario | nome = novoNome }

                updateAgendamento =
                    { oldAgend | funcionario = updateFuncionario }
            in
            ( { model | agendamento = updateAgendamento }, Cmd.none )

        FuncServicoId id ->
            let
                oldAgend =
                    model.agendamento

                oldFuncionario =
                    model.agendamento.funcionario

                oldServico =
                    model.agendamento.funcionario.servico

                updateServico =
                    { oldServico | id = (stringToServId id) }

                updateFuncionario =
                    { oldFuncionario | servico = updateServico }

                updateAgendamento =
                    { oldAgend | funcionario = updateFuncionario }
            in
            ( { model | agendamento = updateAgendamento }, Cmd.none )

        FuncServicoNome nome ->
            let
                oldAgend =
                    model.agendamento

                oldFuncionario =
                    model.agendamento.funcionario

                oldServico =
                    model.agendamento.funcionario.servico

                updateServico =
                    { oldServico | nome = nome }

                updateFuncionario =
                    { oldFuncionario | servico = updateServico }

                updateAgendamento =
                    { oldAgend | funcionario = updateFuncionario }
            in
            ( { model | agendamento = updateAgendamento }, Cmd.none )

        Observacao observacao ->
            let
                oldAgend =
                    model.agendamento

                updateObs =
                    { oldAgend | observacao = observacao }
            in
            ( { model | agendamento = updateObs }, Cmd.none )

        Data data ->
            let
                oldAgend =
                    model.agendamento

                updateData =
                    { oldAgend | data = data }
            in
            ( { model | agendamento = updateData }, Cmd.none )

        Horario horario ->
            let
                oldAgend =
                    model.agendamento 

                updateHora =
                    { oldAgend | horario = horario }

            in
            ({model | agendamento = updateHora}, Cmd.none)

        AnimalId id ->
            let
                oldAgend =
                    model.agendamento

                oldAnimal =
                    model.agendamento.animal

                updateAnimal =
                    { oldAnimal | id = stringToAnimId id } 

                updateAgendamento =
                    { oldAgend | animal = updateAnimal }
            in
            ( { model | agendamento = updateAgendamento }, Cmd.none )

        AnimalNome nome ->
            let
                oldAgend =
                    model.agendamento

                oldAnimal =
                    model.agendamento.animal

                updateAnimal =
                    { oldAnimal | nome = nome } 

                updateAgendamento =
                    { oldAgend | animal = updateAnimal }
            in
            ( { model | agendamento = updateAgendamento }, Cmd.none )

        CreateAgendamento ->
            ( model, createAgendamento model.agendamento )

        AgendamentoCreated (Ok agendamento) ->
           ( { model | agendamento = agendamento, createError = Nothing }
            , Route.pushUrl Route.AllAgendaForAtend model.navKey
            )

        AgendamentoCreated (Err error) ->
            ( { model | createError = Just (buildErrorMessage error) }
            , Cmd.none
            )

--Método POST
createAgendamento : NewAgendamento -> Cmd Msg
createAgendamento agendamento =
    Http.post
        { url = "https://vidapet-backend.herokuapp.com/agenda"
        , body = Http.jsonBody (newAgendaEncoder agendamento)
        , expect = Http.expectJson AgendamentoCreated newAgendaDecoder
        }

--Decoders
newAgendaDecoder : Decoder NewAgendamento
newAgendaDecoder =
    Decode.succeed NewAgendamento 
        |> required "id" agenIdDecoder
        |> required "funcionario" newAgendamentoFuncionarioDecoder
        |> required "observacao" string
        |> required "data" string
        |> required "horario" string
        |> required "animal" newAgendamentoAnimalDecoder

newAgendamentoFuncionarioDecoder : Decoder NewFuncionario
newAgendamentoFuncionarioDecoder = 
    Decode.succeed NewFuncionario
        |> required "id" funcIdDecoder
        |> required "nome" string
        |> required "servico" newAgendamentoServicoDecoder


newAgendamentoServicoDecoder : Decoder NewServico
newAgendamentoServicoDecoder = 
    Decode.succeed NewServico
        |> required "id" servIdDecoder
        |> required "nome" string

--Encoders
newAgendaEncoder : NewAgendamento -> Encode.Value
newAgendaEncoder agendamento =
    Encode.object
        [ ( "funcionario",  newAgendamentoFuncionarioEncoder agendamento.funcionario )
        , ( "observacao", Encode.string agendamento.observacao )
        , ( "data", Encode.string agendamento.data )
        , ( "horario", Encode.string agendamento.horario )
        , ( "animal", newAgendamentoAnimalEncoder agendamento.animal )
        ]

newAgendamentoFuncionarioEncoder : NewFuncionario -> Encode.Value
newAgendamentoFuncionarioEncoder funcionario =
    Encode.object
        [ ( "id", funcIdEncoder funcionario.id )
        , ( "nome",  Encode.string funcionario.nome )
        , ( "servico",  newAgendamentoServicoEncoder funcionario.servico )
        ]

newAgendamentoServicoEncoder : NewServico -> Encode.Value
newAgendamentoServicoEncoder servico =
    Encode.object
        [ ( "id", servIdEncoder servico.id )
        , ( "nome",  Encode.string servico.nome )
        ]

--Valores iniciais default   
emptyAgendamento : NewAgendamento
emptyAgendamento =
    { id = emptyAgendamentoId
    , funcionario = emptyFuncionario
    , observacao = ""
    , data = ""
    , horario = ""
    , animal = 
      {
         id = emptyAnimalId
        , nome = ""
      }
    }

emptyFuncionario : NewFuncionario
emptyFuncionario =
 {
    id = emptyFuncionarioId
    , nome = ""
    , servico = 
      { 
        id = emptyServicoId
      , nome = ""
      }
    }

emptyAgendamentoId : AgenId
emptyAgendamentoId =
    AgenId -1

emptyFuncionarioId : FuncId
emptyFuncionarioId =
    FuncId -1

emptyServicoId : ServId
emptyServicoId =
    ServId -1

emptyAnimalId : AnimId
emptyAnimalId =
    AnimId -1