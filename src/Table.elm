module Table exposing (..)

import Element exposing (..)

type alias Agenda =
    { clientName : String
    , petName : String
    , service : String
    , date : String
    , observation : String
    , actions : String
    }

agendamentos : List Agenda
agendamentos =
    [ { clientName = "David"
      , petName = "Bowie"
      , service = "Banho e Tosa Higiênica"
      , date = "10/05/2023"
      , observation = "Não passar perfume após o banho, pet tem alergia"
      , actions = "Excluir e Deletar"
      }
    , { clientName = "Cláudia"
      , petName = "Gaia"
      , service = "Banho e Tosa Higiênica"
      , date = "10/05/2023"
      , observation = "Não passar perfume após o banho, pet tem alergia"
      , actions = "Excluir e Deletar"
      }
    , { clientName = "Felipe"
      , petName = "Bob"
      , service = "Banho e Tosa Higiênica"
      , date = "10/05/2023"
      , observation = "Não passar perfume após o banho, pet tem alergia"
      , actions = "Excluir e Deletar"
      }
    , { clientName = "Júlia"
      , petName = "Luli"
      , service = "Banho e Tosa Higiênica"
      , date = "10/05/2023"
      , observation = "Não passar perfume após o banho, pet tem alergia"
      , actions = "Excluir e Deletar"
      }
    , { clientName = "Pedro"
      , petName = "Francisco"
      , service = "Banho e Tosa Higiênica"
      , date = "10/05/2023"
      , observation = "Não passar perfume após o banho, pet tem alergia"
      , actions = "Excluir e Deletar"
      }
    ]
tableData : Element msg
tableData = 
    table []
    { data = agendamentos
    , columns =
        [ { header = text "Cliente"
            , width = px 100
            , view =
                    \agendamento ->
                        text agendamento.clientName
          }
        , { header = text "Pet"
            , width = px 100
            , view =
                    \agendamento ->
                        Element.text agendamento.petName
          }
        , { header = text "Serviço"
            , width = px 250
            , view =
                    \agendamento ->
                        Element.text agendamento.service
        }
        , { header = text "Data"
            , width = px 150
            , view =
                    \agendamento ->
                        Element.text agendamento.date
        }
        , { header = text "Observação"
            , width = px 100
            , view =
                \agendamento ->
                    Element.text agendamento.observation
        }
        , { header = text "Ações"
            , width = px 200
            , view =
                \agendamento ->
                    Element.text agendamento.actions
        }
        ]
    }