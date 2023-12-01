module Pages.Atendente.NewAgendamento exposing (..)

import Browser.Navigation as Nav
import Http
import Html as Html
import Element exposing (..)
import Element.Input as Input
import Element.Font as Font
import Element.Input exposing (labelAbove)
import Element.Background as Background
import Element.Border as Border

import Components.MenuAtendente exposing (menuLayout)
import Components.Header exposing (headerLayout)
import Utils.Colors exposing (blue3, lightBlue3, gray1, gray1, gray3)

import Server.Agenda exposing(..)
import Server.ServerUtils exposing (..)
import Server.Funcionario exposing (Funcionario)
import Server.Funcionario exposing (FuncId(..))
import Server.Funcionario exposing (ServId(..))
import Server.Cliente exposing (AnimId(..))
import Route

type alias Model =
    { navKey : Nav.Key
    , agendamento : Agendamento
    , createError : Maybe String
    }

type Msg
    = FuncionarioId FuncId
    | FuncioarioNome String
    | FuncServicoId ServId
    | FuncServicoNome String
    | FuncServicoPreco Float
    | Observacao String
    | Data String
    | Horario String
    | AnimalId AnimId
    | AnimalNome String
    | AnimalEspecie String
    | AnimalRaca String
    | AnimalSexo String
    | AnimalNascimento String
    | AnimalPorte String
    | AnimalPelagem String
    | AnimalPeso Float
    | CreateAgendamento
    | AgendamentoCreated (Result Http.Error Agendamento)

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
                    { oldFuncionario | id = id } 

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
                    { oldServico | id = id }

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

        FuncServicoPreco preco ->
            let
                oldAgend =
                    model.agendamento

                oldFuncionario =
                    model.agendamento.funcionario

                oldServico =
                    model.agendamento.funcionario.servico

                updateServico =
                    { oldServico | preco = preco }

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
                    { oldAnimal | id = id } 

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

        AnimalEspecie especie ->
            let
                oldAgend =
                    model.agendamento

                oldAnimal =
                    model.agendamento.animal

                updateAnimal =
                    { oldAnimal | especie = especie } 

                updateAgendamento =
                    { oldAgend | animal = updateAnimal }
            in
            ( { model | agendamento = updateAgendamento }, Cmd.none )
        
        AnimalRaca raca ->
            let
                oldAgend =
                    model.agendamento

                oldAnimal =
                    model.agendamento.animal

                updateAnimal =
                    { oldAnimal | raca = raca } 

                updateAgendamento =
                    { oldAgend | animal = updateAnimal }
            in
            ( { model | agendamento = updateAgendamento }, Cmd.none )

        AnimalSexo sexo ->
            let
                oldAgend =
                    model.agendamento

                oldAnimal =
                    model.agendamento.animal

                updateAnimal =
                    { oldAnimal | sexo = sexo } 

                updateAgendamento =
                    { oldAgend | animal = updateAnimal }
            in
            ( { model | agendamento = updateAgendamento }, Cmd.none )
        
        AnimalNascimento dataDeNascimento ->
            let
                oldAgend =
                    model.agendamento

                oldAnimal =
                    model.agendamento.animal

                updateAnimal =
                    { oldAnimal | dataDeNascimento = dataDeNascimento } 

                updateAgendamento =
                    { oldAgend | animal = updateAnimal }
            in
            ( { model | agendamento = updateAgendamento }, Cmd.none )
        
        AnimalPorte porte ->
            let
                oldAgend =
                    model.agendamento

                oldAnimal =
                    model.agendamento.animal

                updateAnimal =
                    { oldAnimal | porte = porte } 

                updateAgendamento =
                    { oldAgend | animal = updateAnimal }
            in
            ( { model | agendamento = updateAgendamento }, Cmd.none )
        
        AnimalPelagem pelagem ->
            let
                oldAgend =
                    model.agendamento

                oldAnimal =
                    model.agendamento.animal

                updateAnimal =
                    { oldAnimal | pelagem = pelagem } 

                updateAgendamento =
                    { oldAgend | animal = updateAnimal }
            in
            ( { model | agendamento = updateAgendamento }, Cmd.none )
        
        AnimalPeso peso ->
            let
                oldAgend =
                    model.agendamento

                oldAnimal =
                    model.agendamento.animal

                updateAnimal =
                    { oldAnimal | peso = peso } 

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


view : Model -> Html.Html Msg
view model = 
  Element.layout [] <|
    row [ width fill, height fill ] 
      [
        el [ width (px 200), height fill, Background.color blue3 ]
          (menuLayout "./../../../assets/atendente.jpg" lightBlue3 )
      , el [ width fill, height fill ]
          (column [ width fill, height fill, padding 50, centerX, centerY, spacing 30, Background.color gray1 ] 
            [ 
              headerLayout blue3 lightBlue3 "Novo agendamento" "" ""
            , viewCreateError model.createError
            , viewForm model
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
                      { onPress = Just CreateAgendamento
                      , label = text "Adicionar"
                      } 
                )
            ]
          )
      ]

viewForm :  Model -> Element Msg
viewForm model =
      row [centerX, centerY, Background.color gray3 ] 
        [
          column [ width (px 525), height fill, padding 15, spacing 20 ] 
            [
              column [ width fill ]
                          [ Input.text [ height (px 35) ]
                              { onChange = FuncioarioNome 
                              , text = model.agendamento.funcionario.nome
                              , placeholder = Nothing 
                              , label = labelAbove [Font.size 14] (text "Nome do funcionário")
                              }
                          ]
              , column [ width fill ]
                          [ Input.text [ height (px 35) ]
                              { onChange = Observacao
                              , text = ""
                              , placeholder = Nothing 
                              , label = labelAbove [Font.size 14] (text "Observação")
                              }
                          ]
              , column [ width fill ]
                          [ Input.text [ height (px 35) ]
                              { onChange = Observacao
                              , text = ""
                              , placeholder = Nothing 
                              , label = labelAbove [Font.size 14] (text "Observação")
                              }
                          ]
              , row [ spacing 20 ] 
                      [
                         column [ width fill ]
                          [ Input.text [ height (px 35) ]
                              { onChange = Data
                              , text = ""
                              , placeholder = Nothing 
                              , label = labelAbove [Font.size 14] (text "Data")
                              }
                          ]
                        , column [ width fill ]
                                    [ Input.text [ height (px 35) ]
                                        { onChange = Horario
                                        , text = ""
                                        , placeholder =  Nothing 
                                        , label = labelAbove [Font.size 14] (text "Horário")
                                        }
                                    ]
                      ]
              -- , column [ width fill ]
              --             [ Input.text [ height (px 35) ]
              --                 { onChange = NameChanged
              --                 , text = ""
              --                 , placeholder = Nothing 
              --                 , label = labelAbove [Font.size 14] (text "Nome")
              --                 }
              --             ]
            ]
          -- , column [  width (px 525), height fill, padding 15, spacing 20 ]
          --   [
          --     column [ width fill ]
          --                 [ Input.text [ height (px 35) ]
          --                     { onChange = NameChanged
          --                     , text = ""
          --                     , placeholder = Nothing 
          --                     , label = labelAbove [Font.size 14] (text "Nome")
          --                     }
          --                 ]
          --     , column [ width fill ]
          --                 [ Input.text [ height (px 35) ]
          --                     { onChange = NameChanged
          --                     , text = ""
          --                     , placeholder = Nothing 
          --                     , label = labelAbove [Font.size 14] (text "Nome")
          --                     }
          --                 ]
          --     , column [ width fill ]
          --                 [ Input.text [ height (px 35) ]
          --                     { onChange = NameChanged
          --                     , text = ""
          --                     , placeholder = Nothing 
          --                     , label = labelAbove [Font.size 14] (text "Nome")
          --                     }
          --                 ]
          --   ]
        ]
        
emptyAgendamento : Agendamento
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
        , especie = ""
        , raca = ""
        , sexo = ""
        , dataDeNascimento = ""
        , porte = ""
        , pelagem = ""
        , peso = 0.0
      }
    }

emptyFuncionario : Funcionario
emptyFuncionario =
 {
    id = emptyFuncionarioId
    , nome = "" 
    , email = ""
    , cpf = ""
    , perfil = [0]
    , login = "" 
    , servico = 
      { 
        id = emptyServicoId
      , nome = "" 
      , preco = 0.0
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

createAgendamento : Agendamento -> Cmd Msg
createAgendamento agendamento =
    Http.post
        { url = "https://vidapet-backend.herokuapp.com/agenda"
        , body = Http.jsonBody (newAgendEncoder agendamento)
        , expect = Http.expectJson AgendamentoCreated agendaDecoder
        }   
        