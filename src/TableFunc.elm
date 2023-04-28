module TableFunc exposing (..)

import Element exposing (..)

type alias Funcionario =
    { id : String
    , funcName : String
    , service : String
    , cpf : String
    , email : String
    , celular : String
    , actions : String
    }

funcionarios : List Funcionario
funcionarios =
    [ { id = "0"
      , funcName = "Priscila Milena Luciana Aragão"
      , service = "Banho e Tosa"
      , cpf = "627.816.947-97"
      , email = "priscila_aragao@atualvendas.com"
      , celular =  "(13) 98766-5308"
      , actions = "Excluir e Deletar"
      }
    , { id = "1"
      , funcName = "Elisa Sandra Santos"
      , service = "Veterinário"
      , cpf = "467.367.052-31"
      , email = "elisa_sandra_santos@iega.com.br"
      , celular = "123"
      , actions = "(13) 98755-7388"
      }
    , { id = "2"
      , funcName = "Otávio Sara Moraes"
      , service = "Banho e Tosa"
      , cpf = "514.643.740-82"
      , email = "otavio.elza.moraes@rgsa.com.br"
      , celular = "(21) 99408-3437"
      , actions = "Excluir e Deletar"
      }
    ]
tableData : Element msg
tableData = 
    table []
    { data = funcionarios
    , columns =
        [ { header = text "ID"
            , width = px 100
            , view =
                    \funcionario ->
                        text funcionario.id
          }
        , { header = text "Funcionário"
            , width = px 100
            , view =
                    \funcionario ->
                        Element.text funcionario.funcName
          }
        , { header = text "Serviço"
            , width = px 250
            , view =
                    \funcionario ->
                        Element.text funcionario.service
        }
        , { header = text "CPF"
            , width = px 150
            , view =
                    \funcionario ->
                        Element.text funcionario.cpf
        }
        , { header = text "Email"
            , width = px 465
            , view =
                \funcionario ->
                    Element.text funcionario.email
        }
        , { header = text "Celular"
            , width = px 465
            , view =
                \funcionario ->
                    Element.text funcionario.celular
        }
        , { header = text "Ações"
            , width = px 200
            , view =
                \funcionario ->
                    Element.text funcionario.actions
        }
        ]
    }