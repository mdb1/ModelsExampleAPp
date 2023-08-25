import Foundation

/*
 We need mappers between the API and UI layers, these mappers can be `internal`,
 given they will be used only inside the `Data` library.
 */
extension APIPokemon {
    var uiModel: Pokemon {
        Pokemon(
            id: id,
            name: name,
            imageUrl: imageUrl,
            type: type.uiModel
        )
    }
}

extension APIPokemon.`Type` {
    var uiModel: Pokemon.`Type` {
        .init(rawValue: self.rawValue) ?? .unknown
    }
}
