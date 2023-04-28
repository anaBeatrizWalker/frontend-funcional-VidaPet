module TableServ exposing (..)

import Element exposing (..)

type alias Servico =
    { id : String
    , service : String
    , valor : String
    , actions : String
    }

servicos : List Servico
servicos =
    [ { id = "0"
      , service = "Banho e Tosa"
      , valor = "Entre 100.00 a 200.00"
      , actions = "Excluir e Deletar"
      }
    , { id = "1"
      , service: "Exames"
      , valor: "A partir de 50 reais"
      , actions = "Exluir e Deletar"
      }
    , { id = "2"
      , service = "Vacina"
      , valor = "A partir de 150.00"
      , actions = "Excluir e Deletar"
      }
    ]
tableDataServ : Element msg
tableDataServ = 
    table []
    { data = funcionarios
    , columns =
        [ { header = text "ID"
            , width = px 100
            , view =
                    \funcionario ->
                        text funcionario.id
          }
        , { header = text "Serviço"
            , width = px 100
            , view =
                    \funcionario ->
                        Element.text funcionario.service
          }
        , { header = text "Valor"
            , width = px 250
            , view =
                    \funcionario ->
                        Element.text funcionario.valor
        }
        
        ]
    }