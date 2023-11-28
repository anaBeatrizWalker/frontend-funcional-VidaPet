module Route exposing (..)

import Url exposing (Url)
import Url.Parser exposing (..)
import Server.Cliente exposing (ClieId, clieIdParser)
import Server.Funcionario exposing (FuncId)
import Server.Funcionario exposing (funcIdParser)

type Route
    = NotFound
    --Admin
    | AllAgenda
    | AllClientes
    | AllFuncionarios
    | AllAtendentes
    | AllAdms
    --Cliente
    | AgendaByCliente ClieId
    | AnimaisByCliente ClieId
    --Funcionario
    | AgendaByFuncionario FuncId
    --Atendente
    | AllAgendaForAtend
    | AllClientesForAtend
    | NewAgendamentoAtend

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
        [ map AllAgenda (s "adm" </> s "agenda") --/adm/agenda
        , map AllClientes (s "adm" </> s "clientes") --/adm/clientes
        , map AllFuncionarios (s "adm" </> s "funcionarios") --/adm/funcionarios
        , map AllAtendentes (s "adm" </> s "atendentes") --/adm/atendentes
        , map AllAdms (s "adm") --/adm
        , map AgendaByCliente (s "cliente" </> s "agenda"  </> clieIdParser) --/cliente/agenda/{id do cliente}
        , map AnimaisByCliente (s "cliente" </> s "animais"  </> clieIdParser) --/cliente/animais/{id do cliente}
        , map AgendaByFuncionario (s "funcionario" </> s "agenda"  </> funcIdParser) --/funcionario/agenda/{id do funcionario}
        , map AllAgendaForAtend (s "atendente" </> s "agenda") --/atendente/agenda
        , map AllClientesForAtend (s "atendente" </> s "clientes") --/atendente/clientes
        , map NewAgendamentoAtend (s "atendente" </> s "agenda" </> s "novo")
        ]
