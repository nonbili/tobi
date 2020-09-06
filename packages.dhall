let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.13.8-20200831/packages.dhall sha256:cdb3529cac2cd8dd780f07c80fd907d5faceae7decfcaa11a12037df68812c83

let nonbili =
      https://github.com/nonbili/package-sets/releases/download/v0.9/packages.dhall sha256:0cfeb05b3787dbb1da744fba6f741746f482bed6f7442cfb41af7316dde97c5e

let overrides = {=}

let additions = {=}

in  upstream // nonbili // overrides // additions
