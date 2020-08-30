module App.Eval where

import Tobi.Prelude

import App.Types (DSL)
import Effect.Aff as Aff
import Effect.Class.Console as Console
import Halogen as H
import Model.Feed (Feed)
import Model.Settings as Settings
import Tauri.FS as TauriFS
import Tobi.Api as Api

init :: DSL Unit
init = do
  liftAff (Aff.attempt Api.loadConfig) >>= case _ of
    Left _ -> H.modify_ $ _ { isInitModalOpen = true }
    Right res -> case res of
      Left _ -> liftAff $ Console.error "Failed to parse config.json"
      Right config -> do
        H.modify_ $ _ { config = config }
        load

load :: DSL Unit
load = do
  state <- H.get
  files <- liftAff $ TauriFS.readDir (state.config.dataDir <> "/feeds") Api.emptyFsOpt
  (xs :: Array (Either String Feed)) <- sequence $ files <#> \file -> do
    liftAff (Api.readJson file.path)
  for_ (sequence xs) \feeds -> do
    H.modify_ $ _
      { feeds = feeds
      , selectedFeeds = feeds
      }

  liftAff (Settings.load state.config) >>= traverse_ \settings -> do
    H.modify_ $ _
      { settings = settings
      }
