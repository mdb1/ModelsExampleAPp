// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pokemon",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "PokemonUI",
            targets: ["PokemonUI"]
        ),
        .library(
            name: "PokemonData",
            targets: ["PokemonData"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PokemonUI",
            dependencies: [
                "PokemonData",
            ]
        ),
        .target(
            name: "PokemonData",
            dependencies: []
        ),
        .testTarget(
            name: "PokemonUITests",
            dependencies: [
                "PokemonUI",
                "PokemonData"
            ]
        ),
        .testTarget(
            name: "PokemonDataTests",
            dependencies: ["PokemonData"]
        )
    ]
)
