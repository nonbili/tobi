module App.Render.InitModal
  ( render
  ) where

import Tobi.Prelude

import App.Types (Action(..), HTML, State)
import Data.String as String
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Nonbili.Halogen as Nbh

render :: State -> HTML
render state =
  HH.div
  [ class_ "fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center"
  ]
  [ HH.div
    [ class_ "bg-white p-8 shadow-xl"
    ]
    [ HH.div
      [ class_ "flex items-baseline"]
      [ HH.h1
        [ class_ "text-2xl mr-3"]
        [ HH.text "Welcome to Tobi"]
      , HH.p
        [ class_ "border-b border-green-500"]
        [ HH.text "an RSS/Atom feed reader"]
      ]
    , HH.p
      [ class_ "mt-6"]
      [ HH.text "Choose a folder to save all your feeds"
      , HH.button
        [ class_ $ "Btn-secondary ml-3"
        , HE.onClick $ Just <<< const OnClickOpenDialog
        ]
        [ HH.text "Select"]
      ]
    , Nbh.unless (String.null state.config.dataDir) \\
        HH.div
        [ class_ "mt-12"]
        [ HH.text "Great, you selected"
        , HH.mark
          [ class_ "bg-gray-200 ml-1 py-1 px-2 rounded text-gray-700 font-mono"]
          [ HH.text state.config.dataDir ]
        , HH.button
          [ class_ "text-white py-2 px-4 cursor-pointer block bg-green-500 mt-2"
          , HE.onClick $ Just <<< const OnSubmitInitModal
          ]
          [ HH.text "Get Started"]
        ]
    ]
  ]
