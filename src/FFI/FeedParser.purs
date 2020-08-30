module FFI.FeedParser
  ( parse
  , fetch
  ) where

import Tobi.Prelude

import Control.Promise (Promise)
import Control.Promise as Promise
import Data.Argonaut.Core (Json)
import Data.Argonaut.Decode (decodeJson)
import Model.Feed (Feed)

foreign import parse_ :: String -> Effect (Promise Json)

parse :: String -> Aff (Either String Feed)
parse xml = Promise.toAffE (parse_ xml) >>= pure <<< decodeJson

foreign import fetch_ :: String -> Effect (Promise Json)

fetch :: String -> Aff (Either String Feed)
fetch url = Promise.toAffE (fetch_ url) >>= pure <<< decodeJson
