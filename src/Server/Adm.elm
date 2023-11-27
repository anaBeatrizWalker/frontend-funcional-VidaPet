module Server.Adm exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as Decode
import Json.Decode exposing (Decoder, field, int, list, map5, string)
import RemoteData exposing (WebData)
import Html.Events exposing (onInput, onClick)
import Server.Atendente exposing (Msg(..))

type AdmId = AdmId Int

type alias Administrador = 
    {
        id : AdmId
        , nome : String
        , email : String
        , cpf : String
        , login : String
    }

type alias Model =
    { adms : WebData (List Administrador) }

type Msg
    = GetAllAdms
    | AdmsReceived (WebData (List Administrador))
    | DeleteAdm AdmId
    | AdmDeleted (Result Http.Error String)
    | UpdateNomeAdm String
    | UpdateEmailAdm String
    | UpdateCPFAdm String
    | UpdateLoginAdm String

baseUrl : String
baseUrl = 
    "https://vidapet-backend.herokuapp.com/adm"

getAdministradores : Cmd Msg
getAdministradores =
    Http.get
        { url = baseUrl
        , expect = 
            list admDecoder 
                |> Http.expectJson (RemoteData.fromResult >> AdmsReceived)
        }

--delete
delAdministrador : AdmId -> Cmd Msg
delAdministrador admId = 
    Http.request
        {
            method = "DELETE"
            , headers = []
            , url = (baseUrl ++ "/" ++ idToString admId)
            , body = Http.emptyBody
            , expect = Http.expectString AdmDeleted
            , timeout = Nothing
            , tracker = Nothing
        }

admDecoder : Decoder Administrador
admDecoder =
    map5 Administrador
        (field "id" idDecoder)
        (field "nome" string)
        (field "email" string)
        (field "cpf" string)
        (field "login" string)

idDecoder : Decoder AdmId
idDecoder =
    Decode.map AdmId int

idToString : AdmId -> String
idToString (AdmId id) =
    String.fromInt id

-- buscando adm 
fetchAdm : AdmId -> Cmd Msg
fetchAdm admId =
    Http.get
        { url = "https://vidapet-backend.herokuapp.com/adm/" ++ Administrador.idToString admId
        , expect = 
            list admDecoder 
                |> Http.expectJson (RemoteData.fromResult >> AdmsReceived)
        }

-- editando adm 
editAdm : Administrador -> Html Msg
editAdm adm =
    Html.form []
        [ div []
            [ text "Nome"
            , br [] []
            , input 
                [ type_ "text"
                , value adm.nome
                , onInput UpdateNomeAdm
                ]
                []
            ]
        , br [] []
        , div [] 
            [ text "E-mail"
            , br [] []
            , input 
                [ type_ "text"
                , value adm.email
                , onInput UpdateEmailAdm
                ]
                []
            ]
        , br [] []
        , div []
            [ text "CPF"
            , br [] []
            , input 
                [type_ "text"
                , value adm.cpf
                , onInput UpdateCPFAdm
                ]
                []
            ]
        , br [] []
        , div []
            [ text "Login"
            , br [] []
            , input 
                [ type_ "text"
                , value adm.login
                , onInput UpdateLoginAdm
                ]
                []
            ]
        ]
