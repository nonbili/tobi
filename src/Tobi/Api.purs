module Tobi.Api where

import Tobi.Prelude

import Data.Argonaut.Core (Json)
import Data.Argonaut.Decode (class DecodeJson, decodeJson, printJsonDecodeError)
import Data.Argonaut.Encode (class EncodeJson, encodeJson)
import Data.Argonaut.Parser (jsonParser)
import Effect.Aff as Aff
import Tauri.FS as FS

foreign import stringify :: Json -> String

type Config =
  { dataDir :: String
  }

emptyConfig :: Config
emptyConfig =
  { dataDir: ""
  }

emptyFsOpt :: FS.FsOptions
emptyFsOpt = { dir: Nothing }

loadConfig :: Aff (Either String Config)
loadConfig = do
  -- Create a folder inside the system config folder. e.g. `~/.config/tobi` on
  -- Linux.
  Aff.attempt (FS.readDir "tobi" { dir: Just FS.Config }) >>= case _ of
    Right _ -> do
      pure unit
    Left _ -> do
      FS.createDir "tobi" { dir: Just FS.Config }

  config <- FS.readTextFile "config.json" { dir: Just FS.App }
  pure $ (lmap printJsonDecodeError <<< decodeJson) =<< jsonParser config

saveConfig :: Config -> Aff Unit
saveConfig config = do
  FS.writeTextFile "config.json" (stringify $ encodeJson config)
    { dir: Just FS.App }
  Aff.apathize $ FS.createDir (config.dataDir <> "/feeds") emptyFsOpt

readJson :: forall a. DecodeJson a => FS.FilePath -> Aff (Either String a)
readJson path = Aff.attempt (FS.readTextFile path emptyFsOpt) >>= case _ of
  Left e -> pure $ Left $ Aff.message e
  Right txt -> pure $ (lmap printJsonDecodeError <<< decodeJson) =<< jsonParser txt

writeJson :: forall a. EncodeJson a => FS.FilePath -> a -> Aff Unit
writeJson path x =
  FS.writeTextFile path (stringify $ encodeJson x) emptyFsOpt
