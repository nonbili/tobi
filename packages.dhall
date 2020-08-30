let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.13.6-20200502/packages.dhall sha256:1e1ecbf222c709b76cc7e24cf63af3c2089ffd22bbb1e3379dfd3c07a1787694

let nonbili =
      https://github.com/nonbili/package-sets/releases/download/v0.7/packages.dhall sha256:b09c8d62a7a1e04fd150d32d80f575c0f1e6d82f2dc2a763eb4271cdb61a154d

let overrides = {=}

let additions = {=}

in  upstream // nonbili // overrides // additions
