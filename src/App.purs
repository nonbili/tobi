module App
  ( app
  ) where

import Tobi.Prelude

import App.Eval as Eval
import App.Render.InitModal as InitModal
import App.Render.ItemList as ItemList
import App.Render.ItemReader as ItemReader
import App.Types (Action(..), DSL, HTML, Message, Query, State, initialState)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Model.Feed as Feed
import Nonbili.Halogen as NbH
import Tauri.Dialog as Dialog
import Tobi.Api as Api
import Web.Event.Event as Event

render :: State -> HTML
render state =
  HH.div_
  [ HH.div_
    [ HH.form
      [ class_ "bg-blue-200 py-2 px-4"
      , HE.onSubmit $ Just <<< OnSubmitLink
      ]
      [ HH.input
        [ class_ "py-1 px-2 rounded w-1/3 border-none"
        , HP.value state.url
        , HP.required true
        , HP.placeholder "Subscribe to https://example.com/feed.xml"
        , NbH.attr "onfocus" "setTimeout(() => this.select())"
        , HE.onValueChange $ Just <<< OnValueChange
        ]
      , HH.button
        [ class_ "hidden"
        , HP.type_ HP.ButtonSubmit
        ]
        [ HH.text "Add"]
      ]
    ]
  , ItemList.render state
  , ItemReader.render state
  , NbH.when state.isInitModalOpen \\ InitModal.render state
  ]

app :: H.Component HH.HTML Query Unit Message Aff
app = H.mkComponent
  { initialState: const initialState
  , render
  , eval: H.mkEval $ H.defaultEval
      { handleAction = handleAction
      , initialize = Just Init
      }
  }

handleAction :: Action -> DSL Unit
handleAction = case _ of
  Init -> do
    Eval.init

  OnSubmitLink event -> do
    H.liftEffect $ Event.preventDefault event
    state <- H.get
    H.liftAff (Feed.fetchUrl state.url) >>= traverse_ \feed -> do
      H.modify_ \s -> s
        { feeds = [feed]
        , selectedFeeds = [feed]
        }
      liftAff $ Feed.save state.config feed

  OnValueChange url -> do
    H.modify_ $ _ { url = url }

  OnClickItem item -> do
    H.modify_ $ _ { selectedItem = Just item }

  OnClickOpenDialog -> do
    dir <- liftAff $ Dialog.open { directory: true }
    H.modify_ $ _ { config { dataDir = dir } }

  OnSubmitInitModal -> do
    state <- H.get
    liftAff $ Api.saveConfig state.config
    Eval.load
    H.modify_ $ _ { isInitModalOpen = false }
