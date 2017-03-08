module ACCUSchedule.Model exposing (initialModel, Model, presenters, proposals)

{-| The overal application model.
-}

import ACCUSchedule.Routing as Routing
import ACCUSchedule.Types as Types
import Material
import Navigation


type alias Model =
    { proposals : List Types.Proposal
    , presenters : List Types.Presenter
    , bookmarks : List Types.ProposalId
    , mdl : Material.Model
    , location : Routing.RoutePath
    }


{-| Find the presenters for a proposal.
-}
presenters : Model -> Types.Proposal -> List Types.Presenter
presenters model proposal =
    List.filter (\pres -> List.member pres.id proposal.presenters) model.presenters


proposals : Model -> Types.Presenter -> List Types.Proposal
proposals model presenter =
    List.filter (\prop -> List.member presenter.id prop.presenters) model.proposals


initialModel : List Types.ProposalId -> Navigation.Location -> Model
initialModel bookmarks location =
    { proposals = []
    , presenters = []
    , bookmarks = bookmarks
    , mdl = Material.model
    , location = Routing.parseLocation location
    }
