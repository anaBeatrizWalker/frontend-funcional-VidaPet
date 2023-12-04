--module Route exposing (..)
module Route exposing (Route(..), parseUrl, pushUrl)

import Browser.Navigation as Nav
import Url exposing (Url)
import Url.Parser exposing (..)
import Server.Cliente exposing (ClieId, clieIdParser)
import Server.Funcionario exposing (FuncId, funcIdParser)
import Server.Agenda exposing (AgenId, agenIdParser)
import Server.Adm exposing (idParser)
import Server.Adm exposing (Administrador, AdmId)
import Server.Adm as Adm

import Server.Atendente exposing (idParser)
import Server.Atendente exposing (Atendente, AtendenteId)
import Server.Atendente as Atendente


import Url exposing (Url)
import Url.Parser exposing (..)
import Server.Atendente exposing (AtendenteId)

type Route
    = Login
    | NotFound
    --Admin
    | AllAgenda
    | AllClientes
    | AllFuncionarios
    | AllAtendentes
    | AllAdms
    | NewAdministrador
    | Adm AdmId
    | NewAtendente
    | Atendente AtendenteId
    --Cliente
    | AgendaByCliente ClieId
    | AnimaisByCliente ClieId
    --Funcionario
    | AgendaByFuncionario FuncId
    --Atendente
    | AllAgendaForAtend
    | AllClientesForAtend
    | NewAgendamentoAtend
    | EditAgendamentoAtend AgenId

parseUrl : Url -> Route
parseUrl url =
    case parse matchRoute url of
        Just route ->
            route

        Nothing ->
            NotFound

matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ map Login (s "login") --/login
        , map AllAgenda (s "adm" </> s "agenda") --/adm/agenda
        , map AllClientes (s "adm" </> s "clientes") --/adm/clientes
        , map AllFuncionarios (s "adm" </> s "funcionarios") --/adm/funcionarios
        , map AllAtendentes (s "adm" </> s "atendentes") --/adm/atendentes
        , map NewAtendente (s "adm" </> s "atendentes" </> s "novo") --/adm/atendentes/novo
        , map Atendente (s "adm" </> s "atendentes" </> Atendente.idParser) --/adm/{id do atendente}
        , map AllAdms (s "adm") --/adm
        , map NewAdministrador (s "adm" </> s "novo") --/adm/novo
        , map Adm (s "adm" </> Adm.idParser) --/adm/{id do administrador}
        , map AgendaByCliente (s "cliente" </> s "agenda"  </> clieIdParser) --/cliente/agenda/{id do cliente}
        , map AnimaisByCliente (s "cliente" </> s "animais"  </> clieIdParser) --/cliente/animais/{id do cliente}
        , map AgendaByFuncionario (s "funcionario" </> s "agenda"  </> funcIdParser) --/funcionario/agenda/{id do funcionario}
        , map AllAgendaForAtend (s "atendente" </> s "agenda") --/atendente/agenda
        , map AllClientesForAtend (s "atendente" </> s "clientes") --/atendente/clientes
        , map NewAgendamentoAtend (s "atendente" </> s "agenda" </> s "novo") --/atendente/agenda/novo
        , map EditAgendamentoAtend (s "atendente" </> s "agenda" </> s "editar" </> agenIdParser) --/atendente/agenda/editar/{id do agendamento}
        ]

pushUrl : Route -> Nav.Key -> Cmd msg
pushUrl route navKey =
    routeToString route
        |> Nav.pushUrl navKey


routeToString : Route -> String
routeToString route =
    case route of

        NotFound ->
            "/not-found"

        AllAdms ->
            "/adm"

        AllAgendaForAtend ->
            "/atendente/agenda"

        NewAgendamentoAtend ->
            "/atendente/agenda/novo"

        NewAdministrador ->
            "/adm/new"
        
        Adm admId ->
            "/adm/" ++ Adm.idToString admId

        AllAtendentes ->
            "/adm/atendentes"

        Atendente atendenteId ->
            "/adm/atendentes/" ++ Atendente.idToString atendenteId

        NewAtendente ->
            "/atendentes/new"

        _ ->
            ""

