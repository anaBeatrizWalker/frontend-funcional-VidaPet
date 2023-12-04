{-module Server.Atendente exposing (..)


import Http
import Json.Decode as Decode
import Json.Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required, optional)
import RemoteData exposing (WebData)
import Server.ServerUtils exposing (baseUrlDefault)

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
    baseUrlDefault ++ "atendentes"

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
    Decode.succeed Atendente
       |> required "id" idDecoder
       |> required "nome" string
       |> optional "email" string "-"
       |> optional "cpf" string "-"
       |> optional "login" string "-"

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

-}

module Server.Atendente exposing
    ( Atendente
    , AtendenteId
    , emptyAtendente
    , idParser
    , idToString
    , newAtendenteEncoder
    , atendenteDecoder
    , atendenteEncoder
    , atendentesDecoder
    )

import Json.Decode as Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required, optional)
import Json.Encode as Encode
import Url.Parser exposing (Parser, custom)

type alias Atendente =
    { id : AtendenteId
    , nome : String
    , email : String
    , documento : String
    }

type AtendenteId
    = AtendenteId Int

atendentesDecoder : Decoder (List Atendente)
atendentesDecoder =
    list atendenteDecoder

atendenteDecoder : Decoder Atendente
atendenteDecoder =
    Decode.succeed Atendente
        |> required "id" idDecoder
        |> required "nome" string
        |> optional "email" string "-"
        |> optional "documento" string "-"

idDecoder : Decoder AtendenteId
idDecoder =
    Decode.map AtendenteId int

idToString : AtendenteId -> String
idToString (AtendenteId id) =
    String.fromInt id


idParser : Parser (AtendenteId -> a) a
idParser =
    custom "ATENDENTEID" <|
        \atendenteId ->
            Maybe.map AtendenteId (String.toInt atendenteId)


atendenteEncoder : Atendente -> Encode.Value
atendenteEncoder atendente =
    Encode.object
        [ ( "id", encodeId atendente.id )
        , ( "nome", Encode.string atendente.nome )
        , ( "email", Encode.string atendente.email )
        , ( "documento", Encode.string atendente.documento )
        ]


newAtendenteEncoder : Atendente -> Encode.Value
newAtendenteEncoder atendente =
    Encode.object
        [ ( "nome", Encode.string atendente.nome )
        , ( "email", Encode.string atendente.email )
        , ( "documento", Encode.string atendente.documento )
        ]


encodeId : AtendenteId-> Encode.Value
encodeId (AtendenteId id) =
    Encode.int id


emptyAtendente : Atendente
emptyAtendente =
    { id = emptyAtendenteId
    , nome = ""
    , email = ""
    , documento = ""
    }


emptyAtendenteId : AtendenteId
emptyAtendenteId =
    AtendenteId -1
