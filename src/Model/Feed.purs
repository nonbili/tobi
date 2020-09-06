module Model.Feed
  ( Feed
  , Item
  , fetchUrl
  , fetchFeed
  , fetchFeedIfNeeded
  , save
  ) where

import Tobi.Prelude

import Data.Array as Array
import Data.JSDate as JSDate
import Data.String.Regex as Regex
import Data.String.Regex.Flags as RegexFlags
import Data.String.Regex.Unsafe (unsafeRegex)
import Data.Time.Duration as D
import FFI.FeedParser as FP
import Nonbili.DateTime as NbDT
import Tobi.Api as Api

type Item =
  { link :: String
  , title :: String
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
rawItemToItem { link, title, content, published } =
  { link
  , title
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

-- | Update feed items by newly fetched items.
updateFeedItems :: Array Item -> Array FP.Item -> Array Item
updateFeedItems =
  foldr \cur acc -> case Array.findIndex (\x -> x.link == cur.link) acc of
    Nothing -> Array.cons (rawItemToItem cur) acc
    Just index -> fromMaybe acc $
      acc # Array.modifyAt index \item -> item
        { title = cur.title
        , content = cur.content
        , published = cur.published
        }

fetchUrl :: String -> Aff (Either String Feed)
fetchUrl url = do
  eRaw <- FP.fetch url
  now <- liftEffect NbDT.now
  pure $ eRaw <#> rawFeedToFeed url now

fetchFeed :: Feed -> Aff (Either String Feed)
fetchFeed feed = do
  eRaw <- FP.fetch feed.url
  now <- liftEffect NbDT.now
  pure $ eRaw <#> \{title, image, items} -> feed
    { title = title
    , image = image
    , items = updateFeedItems feed.items items
    }

fetchFeedIfNeeded :: Feed -> Aff (Either String Feed)
fetchFeedIfNeeded feed = do
  NbDT.DateTime now <- liftEffect NbDT.now
  let
    NbDT.DateTime lastFetched = feed.lastFetched
    dur = JSDate.getTime now - JSDate.getTime lastFetched
  if NbDT.Milliseconds (D.Milliseconds dur) >= feed.fetchFrequency
    then fetchFeed feed
    else pure $ Left ""

getFeedFileName :: Feed -> String
getFeedFileName feed =
  "/feeds/" <> Regex.replace re "_" feed.url <> ".json"
  where
  re = unsafeRegex "/" RegexFlags.global

save :: Api.Config -> Feed -> Aff Unit
save config feed = Api.writeJson (config.dataDir <> getFeedFileName feed) feed
