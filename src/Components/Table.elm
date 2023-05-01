module Components.Table exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Utils.Colors exposing (gray1, gray2)
import Components.Buttons exposing (editButtonTable, deleteButtonTable)

type alias Agenda =
    { clientName : String
    , petName : String
    , service : String
    , date : String
    , observation : String
    }

agendamentos : List Agenda
agendamentos =
    [ { clientName = "David"
      , petName = "Bowie"
      , service = "Banho e Tosa Higiênica"
      , date = "10/05/2023"
      , observation = "Não passar perfume após o banho, pet tem alergia"
      }
    , { clientName = "Cláudia"
      , petName = "Gaia"
      , service = "Banho e Tosa Higiênica"
      , date = "10/05/2023"
      , observation = "Não passar perfume após o banho, pet tem alergia"
      }
    , { clientName = "Felipe"
      , petName = "Bob"
      , service = "Banho e Tosa Higiênica"
      , date = "10/05/2023"
      , observation = "Não passar perfume após o banho, pet tem alergia"
      }
    , { clientName = "Júlia"
      , petName = "Luli"
      , service = "Banho e Tosa Higiênica"
      , date = "10/05/2023"
      , observation = "Não passar perfume após o banho, pet tem alergia"
      }
    , { clientName = "Pedro"
      , petName = "Francisco"
      , service = "Banho e Tosa Higiênica"
      , date = "10/05/2023"
      , observation = "Não passar perfume após o banho, pet tem alergia"
      }
    ]

tableLayout : Element msg
tableLayout = 
    row [ width fill ] 
    [
      table [ Background.color gray1, Border.color gray2 ]
      { data = agendamentos
      , columns =
          [ { header = row [ Font.bold, Font.size 18, Background.color gray2, padding 15 ] [text "Cliente"]
              , width = fill
              , view =
                  \agendamento ->
                  row [ padding 10, Font.size 16, Border.color gray2, Border.widthEach {bottom = 0, left = 0, top = 1, right = 0} ] 
                    [
                        text agendamento.clientName
                    ]
            }
          , { header = row [ Font.bold, Font.size 18, Background.color gray2, padding 15 ] [text "Pet"]
              , width = fill
              , view =
                  \agendamento ->
                  row [ padding 10, Font.size 16, Border.color gray2, Border.widthEach {bottom = 0, left = 0, top = 1, right = 0} ] 
                    [
                        Element.text agendamento.petName
                    ]
            }
          , { header = row [ Font.bold, Font.size 18, Background.color gray2, padding 15 ] [text "Serviço"]
              , width = fill
              , view =
                  \agendamento ->
                  row [ padding 10, Font.size 16, Border.color gray2, Border.widthEach {bottom = 0, left = 0, top = 1, right = 0} ] 
                    [
                      Element.text agendamento.service
                    ]
          }
          , { header = row [ Font.bold, Font.size 18, Background.color gray2, padding 15 ] [text "Data"]
              , width = fill
              , view =
                  \agendamento ->
                  row [ padding 10, Font.size 16, Border.color gray2, Border.widthEach {bottom = 0, left = 0, top = 1, right = 0} ] 
                    [
                      Element.text agendamento.date
                    ]
          }
          , { header = row [ Font.bold, Font.size 18, Background.color gray2, padding 15 ] [text "Observação"]
              , width = fill
              , view =
                  \agendamento ->
                  row [ padding 10, Font.size 16, Border.color gray2, Border.widthEach {bottom = 0, left = 0, top = 1, right = 0} ] 
                    [
                      Element.text agendamento.observation
                    ]
          }
          , { header = row [ Font.bold, Font.size 18, Background.color gray2, padding 15 ] [text "Ações"]
              , width = fill
              , view =
                  \_ ->
                  row [ spacing 20, padding 10, Border.color gray2, Border.widthEach {bottom = 0, left = 0, top = 1, right = 0} ] 
                    [
                      column [ centerX ] 
                        [
                          editButtonTable Nothing
                        ]
                      , column [ centerX ] 
                        [
                          deleteButtonTable Nothing
                        ]
                    ]
                  
          }
          ]
      }
    ]