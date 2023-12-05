module Pages.Atendente.NewAgendamento exposing (..)

import Browser.Navigation as Nav
import Http
import Html as Html
import Html.Attributes exposing (type_, style, value)
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
import Server.Funcionario exposing (FuncId(..), ServId(..), Servico, funcIdEncoder, funcIdDecoder, funcIdToString, servIdToString, servicoEncoder, servicoDecoder, emptyFuncionarioId, emptyServicoId)
import Server.Cliente exposing (AnimId(..), Animal, animIdToString, emptyAnimal, animalDecoder, animalEncoder)
import Element.Font as Font
import Utils.Colors exposing (white)


type alias NewAgendamento = 
    {
        id : AgenId
        , funcionario : NewFuncionario
        , observacao : String
        , data : String
        , horario : String
        , animal : Animal
    }

type alias NewFuncionario = 
    {
        id : FuncId
        , nome : String
        , servico : Servico
    }

type alias Model =
    { navKey : Nav.Key
    , agendamento : NewAgendamento
    , funcionarios : List NewFuncionario
    , animais : List Animal
    , createError : Maybe String
    }

type Msg
    = SelectFuncionario NewFuncionario
    | GotFuncionarios (Result Http.Error (List NewFuncionario))
    | SelectAnimal Animal
    | GotAnimais (Result Http.Error (List Animal))
    | Observacao String
    | Data String
    | Horario String
    | CreateAgendamento
    | AgendamentoCreated (Result Http.Error NewAgendamento)


init : Nav.Key -> ( Model, Cmd Msg )
init navKey =
    ( initialModel navKey, Cmd.batch [getFuncionarios, getAnimais]  )


initialModel : Nav.Key -> Model
initialModel navKey =
    { 
      navKey = navKey
      , agendamento = emptyAgendamento
      , funcionarios = []
      , animais = []
      , createError = Nothing
    }

getFuncionarios : Cmd Msg
getFuncionarios =
    Http.get
        { url = baseUrlDefault ++ "funcionarios"
        , expect = Http.expectJson GotFuncionarios (Decode.list newAgendamentoFuncionarioDecoder)
        }

getAnimais : Cmd Msg
getAnimais =
    Http.get
        { url = baseUrlDefault ++ "animais"
        , expect = Http.expectJson GotAnimais (Decode.list animalDecoder)
        }

        
view : Model -> Html.Html Msg
view model = 
    Element.layout [] <|
        row [ width fill, height fill ] 
        [
            el [ width (px 200), height fill, Background.color blue3 ]
            (  menuLayout "./../../../assets/atendente.jpg" lightBlue3 )
        , row [ width fill, height fill ]
            [ column [ width fill, height fill, padding 50, centerX, centerY, spacing 30, Background.color gray1 ] 
                [ 
                headerLayout blue3 lightBlue3 "Novo agendamento" "" ""
                , viewCreateError model.createError
                , Element.html <| viewForm model.funcionarios model.animais
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
                        { onPress = Just (CreateAgendamento)
                        , label = text "Adicionar"
                        } 
                    )
                ]
                , column [ width (px 200), height fill, padding 50, Background.color gray1 ] []
            ]
        ]

viewForm : List NewFuncionario  -> List Animal -> Html.Html Msg
viewForm funcionarios animais =
    Html.form [ style "width" "100%", style "margin-bottom" "20px" ] [
        Html.div [ style "display" "flex"]
            [ Html.div [ style "flex" "1", style "padding-right" "10px"]
                [ 
                    Html.label [ style "font-size" "16px" ] [ Html.text "Serviço" ]
                    , Html.br [] []
                    , Html.select [ onInput (SelectFuncionario << stringToFuncionario), style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] (List.map viewFuncionarioOption funcionarios)
                    
                    , Html.br [] []

                    , Html.label [ style "font-size" "16px" ] [ Html.text "Pet" ]
                    , Html.br [] []
                    , Html.select [ onInput (SelectAnimal << stringToAnimal), style "height" "35px", style "margin-bottom" "10px", style "width" "100%" ] (List.map viewAnimalOption animais)

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
        ]
    ]

viewFuncionarioOption : NewFuncionario -> Html.Html Msg
viewFuncionarioOption funcionario =
    Html.option [ value (funcionarioToString funcionario) ] [ Html.text (funcionario.servico.nome ++ " (" ++ funcionario.nome ++ ")") ]

viewAnimalOption : Animal -> Html.Html Msg
viewAnimalOption  animal =
    Html.option [ value (animalToString animal) ] [ Html.text (animal.nome ++ " (" ++ animal.raca ++ ")") ]


stringToFuncionario : String -> NewFuncionario
stringToFuncionario str =
    let
        parts = String.split "-" str
    in
    case parts of
        [funcionarioIdStr, funcionarioNome, servicoIdStr, servicoNome, servicoPreco] ->
            { id = FuncId (stringToInt funcionarioIdStr)
            , nome = String.trim funcionarioNome
            , servico = { id = ServId (stringToInt servicoIdStr), nome = String.trim servicoNome, preco = stringToFloat servicoPreco }
            }

        _ ->
            emptyFuncionario

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

funcionarioToString : NewFuncionario -> String
funcionarioToString funcionario =
    funcIdToString funcionario.id ++ "-" ++ funcionario.nome ++ "-" ++ servIdToString funcionario.servico.id ++ "-" ++ funcionario.servico.nome ++ "-" ++ String.fromFloat funcionario.servico.preco

animalToString : Animal -> String
animalToString animal =
    animIdToString animal.id ++ "-" ++ animal.nome ++ "-" ++ animal.especie ++ "-" ++ animal.raca ++ "-" ++ animal.sexo ++ "-" ++ animal.dataDeNascimento ++ "-" ++ animal.porte ++ "-" ++ animal.pelagem ++ "-" ++ String.fromFloat animal.peso

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectFuncionario funcionario ->
            let
                oldAgend =
                    model.agendamento

                updateAgendamento =
                    { oldAgend | funcionario = funcionario }
            in
            ( { model | agendamento = updateAgendamento }, Cmd.none )

        GotFuncionarios result ->
            case result of
                Ok funcionarios ->
                    let
                        firstFuncionario = Maybe.withDefault emptyFuncionario (List.head funcionarios)
                        oldAgendamento = model.agendamento
                        newAgendamento = { oldAgendamento | funcionario = firstFuncionario }
                    in
                    ( { model | funcionarios = funcionarios, agendamento = newAgendamento }, Cmd.none )

                Err _ ->
                    (model, Cmd.none)


        SelectAnimal animal ->
            let
                oldAgend =
                    model.agendamento

                updateAgendamento =
                    { oldAgend | animal = animal }
            in
            ( { model | agendamento = updateAgendamento }, Cmd.none )

        GotAnimais result ->
            case result of
                Ok animais ->
                    let
                        firstAnimal = Maybe.withDefault emptyAnimal (List.head animais)
                        oldAgendamento = model.agendamento
                        newAgendamento = { oldAgendamento | animal = firstAnimal }
                    in
                    ( { model | animais = animais, agendamento = newAgendamento }, Cmd.none )

                Err _ ->
                    (model, Cmd.none)

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
        { url = baseUrl
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
        |> required "animal" animalDecoder

newAgendamentoFuncionarioDecoder : Decoder NewFuncionario
newAgendamentoFuncionarioDecoder = 
    Decode.succeed NewFuncionario
        |> required "id" funcIdDecoder
        |> required "nome" string
        |> required "servico" servicoDecoder

--Encoders
newAgendaEncoder : NewAgendamento -> Encode.Value
newAgendaEncoder agendamento =
    Encode.object
        [ ( "funcionario",  newAgendamentoFuncionarioEncoder agendamento.funcionario )
        , ( "observacao", Encode.string agendamento.observacao )
        , ( "data", Encode.string agendamento.data )
        , ( "horario", Encode.string agendamento.horario )
        , ( "animal", animalEncoder agendamento.animal )
        ]

newAgendamentoFuncionarioEncoder : NewFuncionario -> Encode.Value
newAgendamentoFuncionarioEncoder funcionario =
    Encode.object
        [ ( "id", funcIdEncoder funcionario.id )
        , ( "nome",  Encode.string funcionario.nome )
        , ( "servico",  servicoEncoder funcionario.servico )
        ]


--Valores iniciais default   
emptyAgendamento : NewAgendamento
emptyAgendamento =
    { id = emptyAgendamentoId
    , funcionario = emptyFuncionario
    , observacao = ""
    , data = ""
    , horario = ""
    , animal = emptyAnimal
    }

emptyAgendamentoId : AgenId
emptyAgendamentoId =
    AgenId -1

emptyFuncionario : NewFuncionario
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

