module Model.Feed
  ( Feed
  , Image
  , Item
  , save
  ) where

import Tobi.Prelude

import Data.String.Regex as Regex
import Data.String.Regex.Flags as RegexFlags
import Data.String.Regex.Unsafe (unsafeRegex)
import Tobi.Api as Api

type Item =
  { title :: String
  , content :: String
  , published :: String
  }

type Image =
  { title :: String
  , url :: String
  }

type Feed =
  { title :: String
  , link :: String
  , image :: Maybe Image
  , items :: Array Item
  }

getFeedFileName :: Feed -> String
getFeedFileName feed =
  "/feeds/" <> Regex.replace re "_" feed.link <> ".json"
  where
  re = unsafeRegex "/" RegexFlags.global


save :: Api.Config -> Feed -> Aff Unit
save config feed = Api.writeJson (config.dataDir <> getFeedFileName feed) feed
