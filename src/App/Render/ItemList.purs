module App.Render.ItemList where

import Tobi.Prelude

import App.Types (Action(..), HTML, State)
import Data.Array as Array
import Halogen.HTML as HH
import Halogen.HTML.Events as HE

render :: State -> HTML
render state =
  HH.div_
  [ HH.ul_ $ items <#> \item ->
      HH.li
      [ HE.onClick $ Just <<< const (OnClickItem item) ]
      [ HH.text item.title ]
  ]
  where
  items = Array.concat $ _.items <$> state.selectedFeeds
