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
import Pages.Administrador.NewAtendente as  NewAtendente
import Pages.Administrador.EditAtendente as EditAtendente
import Pages.Administrador.ListAdms as ListAdms
import Pages.Administrador.NewAdministrador as  NewAdministrador
import Pages.Administrador.EditAdministrador as EditAdministrador



--Cliente
import Pages.Cliente.ListAnimais as ListAnimais
import Pages.Cliente.ListAgenda as ListAgendaCliente
--Funcionario
import Pages.Funcionario.ListAgendaByFuncio as ListAgendaFunc
--Atendente 
import Pages.Atendente.ListAgenda as ListAgendaAtend
import Pages.Atendente.ListClientes as ListClientesAtend
import Pages.Atendente.NewAgendamento as NewAgendamentoAtend
import Pages.Atendente.EditAgendamento as EditAgendamentoAtend
import Login as Login

import Server.Cliente as ClienteMsg
import Server.Agenda as AgendaMsg
import Server.Funcionario as FuncMsg


import Route exposing (Route(..))

type alias Model =
    { route : Route
    , page : Page
    , navKey : Nav.Key
    }

type Page
    = LoginPage Login.Model
    | NotFoundPage
    --Admin
    | ListAgendaPage ListAgenda.Model
    | ListClientesPage ListClientes.Model
    | ListFuncPage ListFuncionarios.Model
    | ListAtendentesPage ListAtendentes.Model
    | NewAtendentePage NewAtendente.Model
    | EditAtendentePage EditAtendente.Model
    | ListAdmsPage ListAdms.Model
    | NewAdministradorPage NewAdministrador.Model
    | EditAdministradorPage EditAdministrador.Model
    --Cliente
    | ListAgendaClientePage ListAgendaCliente.Model
    | ListAnimaisClientePage ListAnimais.Model
    --Funcionario
    | ListAgendaFuncPage ListAgendaFunc.Model
    --Atendente
    | ListAgendaAtendPage ListAgendaAtend.Model
    | ListClientesAtendPage ListClientesAtend.Model
    | NewAgendamentoAtendPage NewAgendamentoAtend.Model
    | EditAgendamentoAtendPage EditAgendamentoAtend.Model

type Msg
    = LinkClicked UrlRequest
    | UrlChanged Url
    | LoginMsg Login.Msg
    --Admin
    | ListAgendaPageMsg AgendaMsg.Msg
    | ListClientesPageMsg ClienteMsg.Msg
    | ListFuncPageMsg FuncMsg.Msg
    | ListAtendentesPageMsg ListAtendentes.Msg
    | NewAtendentePageMsg NewAtendente.Msg
    | EditAtendentePageMsg EditAtendente.Msg
    | ListAdmsPageMsg ListAdms.Msg
    | NewAdministradorPageMsg NewAdministrador.Msg
    | EditAdministradorPageMsg EditAdministrador.Msg
    --Cliente
    | ListAgendaClientePageMsg AgendaMsg.Msg
    | ListAnimaisClientePageMsg ClienteMsg.Msg
    --Funcionario
    | ListAgendaFuncPageMsg AgendaMsg.Msg
    --Atendente
    | ListAgendaAtendPageMsg AgendaMsg.Msg
    | ListClientesAtendPageMsg ClienteMsg.Msg
    | NewAgendamentoAtendPageMsg NewAgendamentoAtend.Msg
    | EditAgendamentoAtendPageMsg EditAgendamentoAtend.Msg

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

                Route.Login ->
                    let
                        (pageModel, pageCmds) =
                            Login.init model.navKey
                    in
                    (LoginPage pageModel, Cmd.map LoginMsg pageCmds)


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
                            ListAtendentes.init
                    in
                    ( ListAtendentesPage pageModel, Cmd.map ListAtendentesPageMsg pageCmds )

                Route.Atendente atendenteId ->
                    let
                        ( pageModel, pageCmd ) =
                            EditAtendente.init atendenteId model.navKey
                    in
                    ( EditAtendentePage pageModel, Cmd.map EditAtendentePageMsg pageCmd )

                Route.NewAtendente ->
                    let
                        ( pageModel, pageCmd ) =
                            NewAtendente.init model.navKey
                    in
                    ( NewAtendentePage pageModel, Cmd.map NewAtendentePageMsg pageCmd )

                Route.AllAdms ->
                    let
                        ( pageModel, pageCmds ) =
                            ListAdms.init
                    in
                    ( ListAdmsPage pageModel, Cmd.map ListAdmsPageMsg pageCmds )

                Route.NewAdministrador ->
                    let
                        ( pageModel, pageCmd ) =
                            NewAdministrador.init model.navKey
                    in
                    ( NewAdministradorPage pageModel, Cmd.map NewAdministradorPageMsg pageCmd )

                Route.Adm admId ->
                    let
                        ( pageModel, pageCmd ) =
                            EditAdministrador.init admId model.navKey
                    in
                    ( EditAdministradorPage pageModel, Cmd.map EditAdministradorPageMsg pageCmd )

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

                Route.NewAgendamentoAtend ->
                    let
                        (pageModel, pageCmds) =
                            NewAgendamentoAtend.init model.navKey
                    in
                    (NewAgendamentoAtendPage pageModel, Cmd.map NewAgendamentoAtendPageMsg pageCmds)

                Route.EditAgendamentoAtend agendId-> 
                    let
                        (pageModel, pageCmds) =
                            EditAgendamentoAtend.init agendId model.navKey
                    in
                    (EditAgendamentoAtendPage pageModel, Cmd.map EditAgendamentoAtendPageMsg pageCmds)

    in
    ( { model | page = currentPage } , Cmd.batch [ existingCmds, mappedPageCmds ])

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

        LoginPage pageModel ->
            Login.view pageModel
                |> Html.map LoginMsg

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

        ListAtendentesPage pageModel ->
            ListAtendentes.view pageModel
                |> Html.map ListAtendentesPageMsg

        EditAtendentePage pageModel ->
            EditAtendente.view pageModel
                |> Html.map EditAtendentePageMsg

        NewAtendentePage pageModel ->
            NewAtendente.view pageModel
                |> Html.map NewAtendentePageMsg

        ListAdmsPage pageModel ->
            ListAdms.view pageModel
                |> Html.map ListAdmsPageMsg

        NewAdministradorPage pageModel ->
            NewAdministrador.view pageModel
                |> Html.map NewAdministradorPageMsg

        EditAdministradorPage pageModel ->
            EditAdministrador.view pageModel
                |> Html.map EditAdministradorPageMsg

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

        NewAgendamentoAtendPage pageModel ->
            NewAgendamentoAtend.view pageModel 
                |> Html.map NewAgendamentoAtendPageMsg

        EditAgendamentoAtendPage pageModel ->
            EditAgendamentoAtend.view pageModel
                |> Html.map EditAgendamentoAtendPageMsg

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

        (LoginMsg subMsg, LoginPage pageModel) ->
            let
                (updatedPageModel, updatedCmd) =
                    Login.update subMsg pageModel
            in
            ({model | page = LoginPage updatedPageModel}, Cmd.map LoginMsg updatedCmd)

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

        ( ListAtendentesPageMsg subMsg, ListAtendentesPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    ListAtendentes.update subMsg pageModel
            in
            ( { model | page = ListAtendentesPage updatedPageModel }
            , Cmd.map ListAtendentesPageMsg updatedCmd
            )

        ( EditAtendentePageMsg subMsg, EditAtendentePage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    EditAtendente.update subMsg pageModel
            in
            ( { model | page = EditAtendentePage updatedPageModel }
            , Cmd.map EditAtendentePageMsg updatedCmd
            )

        ( NewAtendentePageMsg subMsg, NewAtendentePage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    NewAtendente.update subMsg pageModel
            in
            ( { model | page = NewAtendentePage updatedPageModel }
            , Cmd.map NewAtendentePageMsg updatedCmd
            )


        ( ListAdmsPageMsg subMsg, ListAdmsPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    ListAdms.update subMsg pageModel
            in
            ( { model | page = ListAdmsPage updatedPageModel }
            , Cmd.map ListAdmsPageMsg updatedCmd
            )

        ( NewAdministradorPageMsg subMsg, NewAdministradorPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    NewAdministrador.update subMsg pageModel
            in
            ( { model | page = NewAdministradorPage updatedPageModel }
            , Cmd.map NewAdministradorPageMsg updatedCmd
            )

        ( EditAdministradorPageMsg subMsg, EditAdministradorPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    EditAdministrador.update subMsg pageModel
            in
            ( { model | page = EditAdministradorPage updatedPageModel }
            , Cmd.map EditAdministradorPageMsg updatedCmd
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

        (NewAgendamentoAtendPageMsg subMsg, NewAgendamentoAtendPage pageModel) ->
            let
                (updatePageModel, updateCmd) =
                    NewAgendamentoAtend.update subMsg pageModel
            in
            ({model | page = NewAgendamentoAtendPage updatePageModel}, Cmd.map NewAgendamentoAtendPageMsg updateCmd)

        (EditAgendamentoAtendPageMsg subMsg, EditAgendamentoAtendPage pageModel) ->
            let
                (updatePageModel, updateCmd) =
                    EditAgendamentoAtend.update subMsg pageModel
            in
            ({model | page = EditAgendamentoAtendPage updatePageModel}, Cmd.map EditAgendamentoAtendPageMsg updateCmd)
            

        ( _, _ ) ->
            ( model, Cmd.none )

