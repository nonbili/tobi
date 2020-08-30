module Model.Settings
  ( Settings
  , initialSettings
  , load
  , save
  ) where

import Tobi.Prelude

import Tobi.Api as Api

currentVersion :: Int
currentVersion = 0

type Settings =
  { version :: Int
  }

initialSettings :: Settings
initialSettings =
  { version: currentVersion
  }

load :: Api.Config -> Aff (Either String Settings)
load config = do
  ex <- Api.readJson (config.dataDir <> "/settings.json")
  pure $ either (const (Right initialSettings)) Right ex

save :: Api.Config -> Settings -> Aff Unit
save config settings = do
  Api.writeJson (config.dataDir <> "/settings.json") settings
