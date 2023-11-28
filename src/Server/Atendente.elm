module Server.Atendente exposing (..)


import Http
import Json.Decode as Decode
import Json.Decode exposing (Decoder, field, int, list, map5, string)
import RemoteData exposing (WebData)

-- import Browser.Dom exposing (Element)
-- import Char exposing (toUpper)
-- import Html exposing (..)
-- import Html.Attributes exposing (..)
-- import Html.Events exposing (onClick, onInput)

type AtenId = AtenId Int

type alias Atendente = 
    {
        id : AtenId
        , nome : String
        , email : String
        , cpf : String
        , login : String
    }

type alias Model =
    { atendentes : WebData (List Atendente) }

type Msg
    = GetAllAtendentes
    | AtendentesReceived (WebData (List Atendente))
    | DeleteAtendente AtenId
    | AtendenteDeleted (Result Http.Error String)
    | UpdateNomeAtendente String
    | UpdateCPFAtendente String 
    | UpdateEmailAtendente String
    | UpdateLoginAtendente String
    | SaveAtendente


baseUrl : String
baseUrl = 
    "https://vidapet-backend.herokuapp.com/atendentes"

getAtendentes : Cmd Msg
getAtendentes =
    Http.get
        { url = baseUrl
        , expect = 
            list atendenteDecoder 
                |> Http.expectJson (RemoteData.fromResult >> AtendentesReceived)
        }

--delete
delAtendente : AtenId -> Cmd Msg
delAtendente atenId = 
    Http.request
        {
            method = "DELETE"
            , headers = []
            , url = (baseUrl ++ "/" ++ idToString atenId)
            , body = Http.emptyBody
            , expect = Http.expectString AtendenteDeleted
            , timeout = Nothing
            , tracker = Nothing
        }

atendenteDecoder : Decoder Atendente
atendenteDecoder =
    map5 Atendente
        (field "id" idDecoder)
        (field "nome" string)
        (field "email" string)
        (field "cpf" string)
        (field "login" string)

idDecoder : Decoder AtenId
idDecoder =
    Decode.map AtenId int

idToString : AtenId -> String
idToString (AtenId id) =
    String.fromInt id

-- buscando atendente
fetchAtendente : AtenId -> Cmd Msg
fetchAtendente atenId =
    Http.get 
        { url = "https://vidapet-backend.herokuapp.com/atendentes/" ++ idToString atenId
        , expect = 
            list atendenteDecoder 
                |> Http.expectJson (RemoteData.fromResult >> AtendentesReceived)
        }

-- editando funcionario
-- editFuncionario : List Atendente -> Html Msg
-- editFuncionario atendente =
--     Html.form []
--         [ div []
--             [ text "Nome do(a) atendente" 
--             , br [] []
--             , input 
--                 [ type_ "text"
--                 , value atendente.nome
--                 , onInput UpdateNomeAtendente
--                 ]
--                 []
--             ]
--         , br [] []
--         , div []
--             [ text "E-mail"
--             , br [] []
--             , input 
--                 [ type_ "text"
--                 , value atendente.email
--                 , onInput UpdateEmailAtendente
--                 ]
--                 []
--             ]
--         , br [] []
--         , div []
--             [ text "CPF"
--             , br [] []
--             , input 
--                 [ type_ "text" 
--                 , value atendente.cpf
--                 , onInput UpdateCPFAtendente
--                 ]
--                 []
--             ]
--         , br [] []
--         , div []
--             [ text "Login"
--             , br [] []
--             , input 
--                 [ type_ "text"
--                 , value atendente.login
--                 , onInput UpdateLoginAtendente
--                 ]
--                 []
--             ]
--         , br [] []
--         , div []
--             [ button [ type_ "button", onClick SaveAtendente ] 
--                 [ text "Salvar alterações" ]
--             ]   
--         ]