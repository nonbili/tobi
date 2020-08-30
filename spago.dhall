{ name = "tobi"
, dependencies =
  [ "aff-promise"
  , "argonaut-generic"
  , "effect"
  , "halogen"
  , "halogen-nselect"
  , "nonbili"
  , "nonbili-dom"
  , "nonbili-halogen"
  , "now"
  , "psci-support"
  , "routing"
  , "tauri"
  , "template-literals"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
