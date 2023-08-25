@testable import PokemonData
@testable import PokemonUI
import XCTest

final class PokemonListViewModelTests: XCTestCase {
    func test_updateStates() {
        // Given
        var sut = PokemonListView.Model()
        XCTAssertEqual(sut.isLoading, false)
        XCTAssertEqual(sut.pokemons.count, 0)
        XCTAssertEqual(sut.pokemons, [])
        XCTAssertNil(sut.error)

        // When
        sut.updateStates(with: .loading)
        // Then
        XCTAssertEqual(sut.isLoading, true)
        // When
        let pokemonMock: Pokemon = .init(id: "", name: "", imageUrl: "", type: .fire)
        sut.updateStates(with: .success([pokemonMock]))
        // Then
        XCTAssertEqual(sut.isLoading, false)
        XCTAssertEqual(sut.pokemons.count, 1)
        XCTAssertEqual(sut.pokemons, [pokemonMock])
        // When
        let error = NSError(domain: "", code: 1)
        sut.updateStates(with: .failure(error))
        // Then
        XCTAssertEqual(sut.isLoading, false)
        XCTAssertNotNil(sut.error)
        XCTAssertEqual(sut.error as? NSError, error)
        // Wehn
        sut.updateStates(with: .idle)
        // Then
        XCTAssertEqual(sut.isLoading, false)
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.pokemons, [])
    }
}
