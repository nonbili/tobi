module FFI.FeedParser
  ( Feed
  , Image
  , Item
  , fetch
  ) where

import Tobi.Prelude

import Control.Promise (Promise)
import Control.Promise as Promise
import Data.Argonaut.Core (Json)
import Data.Argonaut.Decode (decodeJson, printJsonDecodeError)

type Item =
  { link :: String
  , title :: String
  , content :: String
  , published :: String
  }

type Image =
  { title :: String
  , url :: String
  }

type Feed =
  { title :: String
  , image :: Maybe Image
  , items :: Array Item
  }

foreign import fetch_ :: String -> Effect (Promise Json)

fetch :: String -> Aff (Either String Feed)
fetch url =
  Promise.toAffE (fetch_ url) >>=
    pure <<< (lmap printJsonDecodeError <<< decodeJson)
