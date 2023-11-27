module Main exposing (..)

import Html exposing (..)
import Browser exposing (UrlRequest, Document)
import Browser.Navigation as Nav
import Url exposing (Url)
import Route exposing (Route)

import Components.NotFoundPage exposing (notFoundView)
--Admin
import Pages.Administrador.ListClientes as ListClientes
import Pages.Administrador.ListAgenda as ListAgenda
import Pages.Administrador.ListFuncionarios as ListFuncionarios
import Pages.Administrador.ListAtendentes as ListAtendentes
import Pages.Administrador.ListAdms as ListAdms
--Cliente
import Pages.Cliente.ListAnimais as ListAnimais
import Pages.Cliente.ListAgenda as ListAgendaCliente
--Funcionario
import Pages.Funcionario.ListAgendaByFuncio as ListAgendaFunc
--Atendente 
import Pages.Atendente.ListAgenda as ListAgendaAtend
import Pages.Atendente.ListClientes as ListClientesAtend

import Server.Cliente as ClienteMsg
import Server.Agenda as AgendaMsg
import Server.Funcionario as FuncMsg
import Server.Atendente as AtendMsg
import Server.Adm as AdmMsg
import Server.Agenda as Agenda

type alias Model =
    { route : Route
    , page : Page
    , navKey : Nav.Key
    }

type Page
    = NotFoundPage
    --Admin
    | ListAgendaPage ListAgenda.Model
    | ListClientesPage ListClientes.Model
    | ListFuncPage ListFuncionarios.Model
    | ListAtendPage ListAtendentes.Model
    | ListAdmsPage ListAdms.Model
    --Cliente
    | ListAgendaClientePage ListAgendaCliente.Model
    | ListAnimaisClientePage ListAnimais.Model
    --Funcionario
    | ListAgendaFuncPage ListAgendaFunc.Model
    --Atendente
    | ListAgendaAtendPage ListAgendaAtend.Model
    | ListClientesAtendPage ListClientesAtend.Model

type Msg
    = LinkClicked UrlRequest
    | UrlChanged Url
    --Admin
    | ListAgendaPageMsg AgendaMsg.Msg
    | ListClientesPageMsg ClienteMsg.Msg
    | ListFuncPageMsg FuncMsg.Msg
    | ListAtendPageMsg AtendMsg.Msg
    | ListAdmsPageMsg AdmMsg.Msg
    --Cliente
    | ListAgendaClientePageMsg AgendaMsg.Msg
    | ListAnimaisClientePageMsg ClienteMsg.Msg
    --Funcionario
    | ListAgendaFuncPageMsg Agenda.Msg
    --Atendente
    | ListAgendaAtendPageMsg Agenda.Msg
    | ListClientesAtendPageMsg ClienteMsg.Msg

main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url navKey =
    let
        model =
            { route = Route.parseUrl url
            , page = NotFoundPage
            , navKey = navKey
            }
    in
    initCurrentPage ( model, Cmd.none )

initCurrentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
initCurrentPage ( model, existingCmds ) =
    let
        ( currentPage, mappedPageCmds ) =
            case model.route of
                Route.NotFound ->
                    ( NotFoundPage, Cmd.none )

                --Admin
                Route.AllClientes ->
                    let
                        ( pageModel, pageCmds ) =
                            ListClientes.init ()
                    in
                    ( ListClientesPage pageModel, Cmd.map ListClientesPageMsg pageCmds )
                
                Route.AllAgenda ->
                    let
                        ( pageModel, pageCmds ) =
                            ListAgenda.init ()
                    in
                    ( ListAgendaPage pageModel, Cmd.map ListAgendaPageMsg pageCmds )

                Route.AllFuncionarios ->
                    let
                        ( pageModel, pageCmds ) =
                            ListFuncionarios.init ()
                    in
                    ( ListFuncPage pageModel, Cmd.map ListFuncPageMsg pageCmds )

                Route.AllAtendentes ->
                    let
                        ( pageModel, pageCmds ) =
                            ListAtendentes.init ()
                    in
                    ( ListAtendPage pageModel, Cmd.map ListAtendPageMsg pageCmds )

                Route.AllAdms -> 
                    let
                        ( pageModel, pageCmds ) =
                            ListAdms.init ()
                    in
                    ( ListAdmsPage pageModel, Cmd.map ListAdmsPageMsg pageCmds )

                --Cliente
                Route.AnimaisByCliente clieId ->
                    let
                        ( pageModel, pageCmd ) =
                            ListAnimais.init clieId model.navKey
                    in
                    ( ListAnimaisClientePage pageModel, Cmd.map ListAnimaisClientePageMsg pageCmd )

                Route.AgendaByCliente clieId ->
                    let
                        ( pageModel, pageCmd ) =
                            ListAgendaCliente.init clieId model.navKey
                    in
                    ( ListAgendaClientePage pageModel, Cmd.map ListAgendaClientePageMsg pageCmd )

                --Funcionario
                Route.AgendaByFuncionario funcId ->
                    let
                        ( pageModel, pageCmd ) =
                            ListAgendaFunc.init funcId model.navKey
                    in
                    ( ListAgendaFuncPage pageModel, Cmd.map ListAgendaFuncPageMsg pageCmd )

                --Atendente
                Route.AllAgendaForAtend -> 
                    let
                        ( pageModel, pageCmds ) =
                            ListAgendaAtend.init ()
                    in
                    ( ListAgendaAtendPage pageModel, Cmd.map ListAgendaAtendPageMsg pageCmds )

                Route.AllClientesForAtend ->
                    let
                        ( pageModel, pageCmds ) =
                            ListClientesAtend.init ()
                    in
                    ( ListClientesAtendPage pageModel, Cmd.map ListClientesAtendPageMsg pageCmds )
    in
    ( { model | page = currentPage }
    , Cmd.batch [ existingCmds, mappedPageCmds ]
    )

view : Model -> Document Msg
view model =
    { title = "VidaPet"
    , body = [ currentView model ]
    }


currentView : Model -> Html Msg
currentView model =
    case model.page of
        NotFoundPage ->
            notFoundView

        --Admin
        ListClientesPage pageModel ->
            ListClientes.view pageModel
                |> Html.map ListClientesPageMsg

        ListAgendaPage pageModel ->
            ListAgenda.view pageModel
                |> Html.map ListAgendaPageMsg

        ListFuncPage pageModel ->
            ListFuncionarios.view pageModel
                |> Html.map ListFuncPageMsg

        ListAtendPage pageModel ->
            ListAtendentes.view pageModel
                |> Html.map ListAtendPageMsg

        ListAdmsPage pageModel ->
            ListAdms.view pageModel
                |> Html.map ListAdmsPageMsg

        --Cliente
        ListAnimaisClientePage pageModel ->
            ListAnimais.view pageModel
                |> Html.map ListAnimaisClientePageMsg
        
        ListAgendaClientePage pageModel ->
            ListAgendaCliente.view pageModel
                |> Html.map ListAgendaClientePageMsg

        --Funcionario
        ListAgendaFuncPage pageModel ->
            ListAgendaFunc.view pageModel
                |> Html.map ListAgendaFuncPageMsg

        --Atendente
        ListAgendaAtendPage pageModel -> 
            ListAgendaAtend.view pageModel
                |> Html.map ListAgendaAtendPageMsg

        ListClientesAtendPage pageModel -> 
            ListClientesAtend.view pageModel
                |> Html.map ListClientesAtendPageMsg

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.navKey (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Nav.load url
                    )

        ( UrlChanged url, _ ) ->
            let
                newRoute =
                    Route.parseUrl url
            in
            ( { model | route = newRoute }, Cmd.none )
                |> initCurrentPage

        --Admin
        ( ListClientesPageMsg subMsg, ListClientesPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    ListClientes.update subMsg pageModel
            in
            ( { model | page = ListClientesPage updatedPageModel }
            , Cmd.map ListClientesPageMsg updatedCmd
            )

        ( ListAgendaPageMsg subMsg, ListAgendaPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    ListAgenda.update subMsg pageModel
            in
            ( { model | page = ListAgendaPage updatedPageModel }
            , Cmd.map ListAgendaPageMsg updatedCmd
            )
        
        ( ListFuncPageMsg subMsg, ListFuncPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    ListFuncionarios.update subMsg pageModel
            in
            ( { model | page = ListFuncPage updatedPageModel }
            , Cmd.map ListFuncPageMsg updatedCmd
            )

        ( ListAtendPageMsg subMsg, ListAtendPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    ListAtendentes.update subMsg pageModel
            in
            ( { model | page = ListAtendPage updatedPageModel }
            , Cmd.map ListAtendPageMsg updatedCmd
            )

        ( ListAdmsPageMsg subMsg, ListAdmsPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    ListAdms.update subMsg pageModel
            in
            ( { model | page = ListAdmsPage updatedPageModel }
            , Cmd.map ListAdmsPageMsg updatedCmd
            )

        --Cliente
        ( ListAnimaisClientePageMsg subMsg, ListAnimaisClientePage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    ListAnimais.update subMsg pageModel
            in
            ( { model | page = ListAnimaisClientePage updatedPageModel }
            , Cmd.map ListAnimaisClientePageMsg updatedCmd
            )

        ( ListAgendaClientePageMsg subMsg, ListAgendaClientePage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    ListAgendaCliente.update subMsg pageModel
            in
            ( { model | page = ListAgendaClientePage updatedPageModel }
            , Cmd.map ListAgendaClientePageMsg updatedCmd
            )

        --Funcionario
        ( ListAgendaFuncPageMsg subMsg, ListAgendaFuncPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    ListAgendaFunc.update subMsg pageModel
            in
            ( { model | page = ListAgendaFuncPage updatedPageModel }
            , Cmd.map ListAgendaFuncPageMsg updatedCmd
            )

        --Atendente
        ( ListAgendaAtendPageMsg subMsg, ListAgendaAtendPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    ListAgendaAtend.update subMsg pageModel
            in
            ( { model | page = ListAgendaAtendPage updatedPageModel }
            , Cmd.map ListAgendaAtendPageMsg updatedCmd
            )

        ( ListClientesAtendPageMsg subMsg, ListClientesAtendPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    ListClientesAtend.update subMsg pageModel
            in
            ( { model | page = ListClientesAtendPage updatedPageModel }
            , Cmd.map ListClientesAtendPageMsg updatedCmd
            )

        ( _, _ ) ->
            ( model, Cmd.none )

