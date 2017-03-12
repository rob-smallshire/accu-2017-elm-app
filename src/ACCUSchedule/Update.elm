module ACCUSchedule.Update exposing (update)

import ACCUSchedule.Comms as Comms
import ACCUSchedule.Msg as Msg
import ACCUSchedule.Model exposing (Model)
import ACCUSchedule.Routing as Routing
import ACCUSchedule.Storage as Storage
import Material
import Navigation
import Return exposing (command, singleton)


update : Msg.Msg -> Model -> ( Model, Cmd Msg.Msg )
update msg model =
    case msg of
        Msg.FetchData ->
             singleton model
                 |> command (Comms.fetchProposals model)
                 |> command (Comms.fetchPresenters model)

        Msg.ProposalsResult (Ok proposals) ->
            { model | proposals = proposals } ! []

        Msg.ProposalsResult (Err msg) ->
            -- TODO: display error message or something...maybe a button for
            -- re-fetching the proposals.
            model ! []

        Msg.PresentersResult (Ok presenters) ->
            { model | presenters = presenters } ! []

        Msg.PresentersResult (Err msg) ->
            -- TODO: display error message or something...
            model ! []

        Msg.VisitProposal proposal ->
            ( model, Navigation.newUrl (Routing.proposalUrl proposal.id) )

        Msg.VisitPresenter presenter ->
            ( model, Navigation.newUrl (Routing.presenterUrl presenter.id) )

        Msg.VisitSearch term ->
            ( model, Navigation.modifyUrl (Routing.searchUrl term) )

        Msg.ToggleBookmark id ->
            let
                bookmarks =
                    if List.member id model.bookmarks then
                        List.filter (\pid -> pid /= id) model.bookmarks
                    else
                        id :: model.bookmarks
            in
                -- TODO: Store the new bookmarks array via the port
                { model | bookmarks = bookmarks } ! [ Storage.store bookmarks ]

        Msg.RaiseProposal raised id ->
            let
                props =
                    List.map
                        (\p ->
                            if p.id == id then
                                { p | raised = raised }
                            else
                                p
                        )
                        model.proposals
            in
                { model | proposals = props } ! []

        Msg.UrlChange location ->
            { model | location = Routing.parseLocation location } ! []

        Msg.Mdl mdlMsg ->
            Material.update Msg.Mdl mdlMsg model
