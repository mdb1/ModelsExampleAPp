import Foundation
import XCTest
@testable import PokemonData

final class PokemonMapperTests: XCTestCase {
    func test_mapper() {
        // Given
        let id = "1"
        let name = "Name"
        let imageUrl = "url"
        let type: APIPokemon.`Type` = .fire
        let trainerId = "2"

        let apiPokemon = APIPokemon(id: id, name: name, imageUrl: imageUrl, type: type, trainerId: trainerId)
        let expectedPokemon = Pokemon(id: id, name: name, imageUrl: imageUrl, type: type.uiModel)

        // When
        let pokemon = apiPokemon.uiModel

        // Then
        XCTAssertEqual(pokemon, expectedPokemon)
    }
}
