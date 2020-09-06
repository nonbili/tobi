module App.Types where

import Tobi.Prelude

import Halogen as H
import Model.Feed (Feed, Item)
import Model.Settings as Settings
import Tobi.Api as Api
import Web.Event.Event (Event)

type Message = Void

type Query = Const Void

data Action
  = Init
  | OnClickItem Item
  | OnClickOpenDialog
  | OnSubmitInitModal
  | OnSubmitLink Event
  | OnValueChange String


type HTML = H.ComponentHTML Action () Aff

type DSL = H.HalogenM State Action () Message Aff

type State =
  { config :: Api.Config
  , settings :: Settings.Settings
  , url :: String
  , feeds :: Array Feed
  , selectedFeedUrls :: Array String
  , selectedItem :: Maybe Item
  , isInitModalOpen :: Boolean
  }

initialState :: State
initialState =
  { config: Api.emptyConfig
  , settings: Settings.initialSettings
  , url: ""
  , feeds: []
  , selectedFeedUrls: []
  , selectedItem: Nothing
  , isInitModalOpen: false
  }
