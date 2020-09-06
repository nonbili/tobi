module Model.Feed
  ( Feed
  , Item
  , fetch
  , save
  ) where

import Tobi.Prelude

import Data.String.Regex as Regex
import Data.String.Regex.Flags as RegexFlags
import Data.String.Regex.Unsafe (unsafeRegex)
import Data.Time.Duration as D
import FFI.FeedParser as FP
import Nonbili.DateTime as NbDT
import Tobi.Api as Api

type Item =
  { title :: String
  , content :: String
  , published :: String
  , read :: Boolean
  }

type Feed =
  { version :: Int
  , url :: String
  , title :: String
  , image :: Maybe FP.Image
  , items :: Array Item
  , lastFetched :: NbDT.DateTime
  , fetchFrequency :: NbDT.Milliseconds
  }

currentVersion :: Int
currentVersion = 0

rawItemToItem :: FP.Item -> Item
rawItemToItem { title, content, published } =
  { title
  , content
  , published
  , read: false
  }

rawFeedToFeed :: String -> NbDT.DateTime -> FP.Feed -> Feed
rawFeedToFeed url lastFetched { title, image, items } =
  { version: currentVersion
  , url
  , title
  , image
  , items: map rawItemToItem items
  , lastFetched
  , fetchFrequency: NbDT.Milliseconds $ D.fromDuration $ D.Days 1.0
  }

getFeedFileName :: Feed -> String
getFeedFileName feed =
  "/feeds/" <> Regex.replace re "_" feed.url <> ".json"
  where
  re = unsafeRegex "/" RegexFlags.global


fetch :: String -> Aff (Either String Feed)
fetch url = do
  eRaw <- FP.fetch url
  now <- liftEffect NbDT.now
  pure $ eRaw <#> rawFeedToFeed url now

save :: Api.Config -> Feed -> Aff Unit
save config feed = Api.writeJson (config.dataDir <> getFeedFileName feed) feed
