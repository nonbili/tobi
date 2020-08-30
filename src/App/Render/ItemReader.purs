module App.Render.ItemReader where

import Tobi.Prelude

import App.Types (HTML, State)
import Halogen.HTML as HH
import Nonbili.Halogen as NBH

render :: State -> HTML
render state =
  HH.div_
  [ NBH.fromMaybe state.selectedItem \item ->
      NBH.element "article-reader"
      [ NBH.attr "value" item.content ]
      []
  ]
