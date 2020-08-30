# Tobi (鳶)

A work in progress RSS/Atom reader.

## Build from source

Tobi is written in PureScript Halogen, [tauri](https://github.com/tauri-apps/tauri) is used to package Tobi as a desktop app.

Prerequisites

- yarn or npm
- spago
- cargo
- Development package of openssl, e.g. `libssl-dev` on Ubuntu or `openssl-devel` on Fedora

```
git clone https://github.com/nonbili/tobi
cd tobi
cargo install tauri-bundler
yarn
yarn build
```

An executable named `tobi` can be found inside the `src-tauri/target/release` folder.

## Development

```
git clone https://github.com/nonbili/tobi
cd tobi
yarn
yarn start:ps
yarn dev
yarn tauri
```
