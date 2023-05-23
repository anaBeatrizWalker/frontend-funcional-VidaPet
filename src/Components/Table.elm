module Components.Table exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Utils.Colors exposing (gray1, gray2)
import Components.Buttons exposing (editButtonTable, deleteButtonTable)

--Telas estáticas (provisórias)
type alias Agenda =
    { nomeCliente : String
    , nomePet : String
    , servico : String
    , data : String
    , observacao : String
    }

--Telas estáticas (provisórias)
agendamentos : List Agenda
agendamentos =
    [ { nomeCliente = "David"
      , nomePet = "Bowie"
      , servico = "Banho e Tosa Higiênica"
      , data = "10/05/2023"
      , observacao = "Não passar perfume após o banho, pet tem alergia"
      }
    , { nomeCliente = "Cláudia"
      , nomePet = "Gaia"
      , servico = "Banho e Tosa Higiênica"
      , data = "10/05/2023"
      , observacao = "Não passar perfume após o banho, pet tem alergia"
      }
    , { nomeCliente = "Felipe"
      , nomePet = "Bob"
      , servico = "Banho e Tosa Higiênica"
      , data = "10/05/2023"
      , observacao = "Não passar perfume após o banho, pet tem alergia"
      }
    ]

--Telas estáticas (provisórias)
tableLayout : Element msg
tableLayout = 
    row [ width fill ] 
    [
      table [ Background.color gray1, Border.color gray2 ]
      tableContent
    ]

--Telas estáticas (provisórias)
tableContent : { data : List Agenda, columns : List (Column Agenda msg) }
tableContent = 
    { 
      data = agendamentos
      , columns =
          [ { header = tableHeader "Cliente"
              , width = fill
              , view =
                  \agendamento -> tableData agendamento.nomeCliente
            }
          , { header = tableHeader "Pet"
              , width = fill
              , view =
                  \agendamento -> tableData agendamento.nomePet
            }
          , { header = tableHeader "Serviço"
              , width = fill
              , view =
                  \agendamento -> tableData agendamento.servico
          }
          , { header = tableHeader "Data"
              , width = fill
              , view =
                  \agendamento -> tableData agendamento.data
          }
          , { header = tableHeader "Observação"
              , width = fill
              , view = 
                  \agendamento -> tableData agendamento.observacao
          }
          , { header = tableHeader "Ações"
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

--Telas dinâmicas
tableHeader : String -> Element msg
tableHeader titleColumn = row [ Font.bold, Font.size 18, Background.color gray2, padding 15 ] [text titleColumn]

--Telas dinâmicas
tableData : String -> Element msg
tableData data = row [ padding 10, Font.size 16, Border.color gray2, Border.widthEach {bottom = 0, left = 0, top = 1, right = 0} ] [text data]