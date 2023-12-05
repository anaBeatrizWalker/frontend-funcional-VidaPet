module Pages.Atendente.EditAgendamento exposing (..)

import Browser.Navigation as Nav
import Http
import Html as Html
import Html.Attributes exposing (type_, style, value, disabled, selected)
import Html.Events exposing (onInput)
import Element exposing (..)
import Element.Input as Input
import Element.Background as Background
import Element.Border as Border
import RemoteData exposing (WebData)
import Json.Encode as Encode
import Json.Decode exposing (Decoder, string, float)
import Json.Decode.Pipeline exposing (required)
import Json.Decode as Decode

import Components.MenuAtendente exposing (menuLayout)
import Components.Header exposing (headerLayout)
import Utils.Colors exposing (blue3, lightBlue3, gray1, gray1)
import Route

import Server.ServerUtils exposing (..)
import Server.Funcionario exposing (FuncId(..), ServId(..), Servico, funcIdToString, servIdToString, funcIdEncoder, funcIdDecoder, servIdEncoder, servIdDecoder, emptyFuncionarioId, emptyServicoId)
import Server.Cliente exposing (AnimId(..), Animal,  animIdToString, animalDecoder, animalEncoder, emptyAnimal)
import Server.Agenda exposing (AgenId, agenIdToString, agendIdEncoder, agenIdDecoder, baseUrl)
import Element.Font as Font
import Utils.Colors exposing (white)

type alias EditAgendamento = 
    {
        id : AgenId
        , funcionario : EditFuncionario
        , observacao : String
        , data : String
        , horario : String
        , animal : Animal
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
    , funcionarios : List EditFuncionario
    , selectedFuncionario : EditFuncionario
    , animais : List Animal
    , selectedAnimal : Animal
    , saveError : Maybe String
    }


init : AgenId -> Nav.Key -> ( Model, Cmd Msg )
init agendaId navKey =
    ( initialModel navKey, getAgendamentoById agendaId )

initialModel : Nav.Key -> Model
initialModel navKey =
    { navKey = navKey
    , agendamento = RemoteData.Loading
    , funcionarios = []
    , selectedFuncionario = emptyFuncionario
    , animais = []
    , selectedAnimal = emptyAnimal
    , saveError = Nothing
    }

type Msg
    = AgendamentoReceived (WebData EditAgendamento)    
    | SelectFuncionario EditFuncionario
    | GotFuncionarios (Result Http.Error (List EditFuncionario))
    | SelectAnimal Animal
    | GotAnimais (Result Http.Error (List Animal))
    | Observacao String
    | Data String
    | Horario String
    | SaveAgendamento
    | AgendamentoSaved (Result Http.Error EditAgendamento)

view : Model -> Html.Html Msg
view model = 
    Element.layout [] <|
        row [ width fill, height fill ] 
        [
            el [ width (px 200), height fill, Background.color blue3 ]
            (  menuLayout "./../../../assets/atendente.jpg" lightBlue3 )
        , row [ width fill, height fill ]
            [column [ width fill, height fill, padding 50, centerX, centerY, spacing 30, Background.color gray1 ] 
                [ 
                headerLayout blue3 lightBlue3 "Editar agendamento" "" ""
                , viewEditError model.saveError
                , viewFormOrError model.agendamento model.funcionarios model.animais
                , el [ alignRight ] --botao de Adicionar
                    (
                    Input.button [
                        padding 10
                        , Border.rounded 10
                        , Border.widthEach { bottom = 5, left = 50, right = 50, top = 5 }
                        , Border.color blue3
                        , Background.color blue3
                        , Font.color white
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
                , column [ width (px 200), height fill, padding 50, Background.color gray1 ] []
            ]
        ]

viewFormOrError : WebData EditAgendamento -> List EditFuncionario -> List Animal ->Element Msg
viewFormOrError agendamento funcionarios animais =
    case agendamento of
        RemoteData.NotAsked ->
            viewNoAskedMsg

        RemoteData.Loading ->
            viewLoagindMsg

        RemoteData.Success data ->
            viewForm data funcionarios animais

        RemoteData.Failure httpError ->
            viewError (buildErrorMessage httpError)

viewForm : EditAgendamento -> List EditFuncionario -> List Animal -> Element Msg
viewForm  agendamento funcionarios animais =
    Element.html <|
        Html.form [ style "width" "100%" ] [
            Html.div [ style "display" "flex"]
                [ Html.div [ style "flex" "1", style "padding-right" "10px"]
                    [ 
                        Html.label [ style "font-size" "16px" ] [ Html.text "Serviço" ]
                        , Html.br [] []
                        , Html.select [ onInput (SelectFuncionario << stringToFuncionario), style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] (List.map (viewFuncionarioOption agendamento.funcionario) funcionarios)

                        , Html.br [] []
                        
                        , Html.label [ style "font-size" "16px" ] [ Html.text "Pet" ]
                        , Html.br [] []
                        , Html.select [ onInput (SelectAnimal << stringToAnimal), disabled True, style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] (List.map (viewAnimalOption agendamento.animal) animais)
                        
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
                                            value agendamento.horario, onInput Horario, style "height" "35px", style "margin-bottom" "30px", style "width" "100%" ] []
                                            ]
                                    ]
                            ]
                    ]
            ]
        ]

viewFuncionarioOption : EditFuncionario -> EditFuncionario -> Html.Html Msg
viewFuncionarioOption selectedFuncionario funcionario =
    let
        isSelected = funcionario.id == selectedFuncionario.id
    in
    Html.option [ value (funcionarioToString funcionario), selected isSelected ] [ Html.text (funcionario.servico.nome ++ " (" ++ funcionario.nome ++ ")") ]

viewAnimalOption : Animal -> Animal -> Html.Html Msg
viewAnimalOption selectedAnimal animal =
    let
        isSelected = animal.id == selectedAnimal.id
    in
    Html.option [ value (animalToString animal), selected isSelected ] [ Html.text (animal.nome ++ " (" ++ animal.raca ++ ")") ]

stringToFuncionario : String -> EditFuncionario
stringToFuncionario str =
    let
        parts = String.split "-" str
    in
    case parts of
        [funcionarioIdStr, funcionarioNome, servicoIdStr, servicoNome, servicoPreco] ->
            {  id = FuncId (stringToInt funcionarioIdStr)
            , nome = String.trim funcionarioNome
            , servico = { id = ServId (stringToInt servicoIdStr), nome = String.trim servicoNome, preco = stringToFloat servicoPreco}
            }

        _ ->
            { id = FuncId 0, nome = "", servico = { id = ServId 0, nome = "", preco = 0 } }

stringToAnimal : String -> Animal
stringToAnimal str =
    let
        parts = String.split "-" str
    in
    case parts of
        [animalId, animalNome, animalEspecie, animalRaca, animalSexo, animalData, animalPorte, animalPelagem, animalPeso] ->
            {  id = AnimId (stringToInt animalId)
            , nome = String.trim animalNome
            , especie = String.trim animalEspecie
            , raca= String.trim animalRaca
            , sexo= String.trim animalSexo
            , dataDeNascimento= String.trim animalData
            , porte= String.trim animalPorte
            , pelagem= String.trim animalPelagem
            , peso= stringToFloat animalPeso
            }
        _ ->
            emptyAnimal

funcionarioToString : EditFuncionario -> String
funcionarioToString funcionario =
    funcIdToString funcionario.id ++ "-" ++ funcionario.nome ++ "-" ++ servIdToString funcionario.servico.id ++ "-" ++ funcionario.servico.nome ++ "-" ++ String.fromFloat funcionario.servico.preco

animalToString : Animal -> String
animalToString animal =
    animIdToString animal.id ++ "-" ++ animal.nome ++ "-" ++ animal.especie ++ "-" ++ animal.raca ++ "-" ++ animal.sexo ++ "-" ++ animal.dataDeNascimento ++ "-" ++ animal.porte ++ "-" ++ animal.pelagem ++ "-" ++ String.fromFloat animal.peso
    

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AgendamentoReceived agendamento ->
            case agendamento of
                RemoteData.Success _ ->
                    ( { model | agendamento = agendamento }, Cmd.batch [getFuncionarios, getAnimais] )
                _ ->
                    ( { model | agendamento = agendamento }, Cmd.none )
        
        GotFuncionarios result ->
            case result of
                Ok funcionarios ->
                    ( { model | funcionarios = funcionarios }, Cmd.none )
                Err _ ->
                    (model, Cmd.none)

        GotAnimais result ->
            case result of
                Ok animais ->
                    ( { model | animais = animais }, Cmd.none )
                Err _ ->
                    (model, Cmd.none)

        SelectFuncionario funcionario ->
            let
                updateAgendamento agendamento =
                    { agendamento | funcionario = funcionario }
                updatedAgendamento =
                    RemoteData.map updateAgendamento model.agendamento
            in
            ( { model | agendamento = updatedAgendamento }, Cmd.none )

        SelectAnimal animal ->
            let
                updateAgendamento agendamento =
                    { agendamento | animal = animal }
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
      
getAgendamentoById : AgenId -> Cmd Msg
getAgendamentoById agendaId =
    Http.get
        { url = baseUrl ++ "/" ++ agenIdToString agendaId
        , expect = 
            editAgendaDecoder 
                |> Http.expectJson (RemoteData.fromResult >> AgendamentoReceived)
        }

getFuncionarios : Cmd Msg
getFuncionarios =
    Http.get
        { url = baseUrlDefault ++ "funcionarios"
        , expect = Http.expectJson GotFuncionarios (Decode.list editAgendamentoFuncionarioDecoder)
        }

getAnimais : Cmd Msg
getAnimais =
    Http.get
        { url = baseUrlDefault ++ "animais"
        , expect = Http.expectJson GotAnimais (Decode.list animalDecoder)
        }

editAgendamento : WebData EditAgendamento -> Cmd Msg
editAgendamento agendamento =
    case agendamento of
        RemoteData.Success agend ->
            let
                agendUrl = baseUrl ++ "/" ++ (agenIdToString agend.id)
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
        , ( "animal", animalEncoder agendamento.animal )
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
        |> required "animal" animalDecoder

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


emptyFuncionario : EditFuncionario
emptyFuncionario =
 {
    id = emptyFuncionarioId
    , nome = ""
    , servico = 
      { 
        id = emptyServicoId
      , nome = ""
      , preco = 0
      }
    }
