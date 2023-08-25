@testable import PokemonData
@testable import PokemonUI
import XCTest

final class PokemonDetailViewModelTests: XCTestCase {
    func test_updateStates() {
        // Given
        var sut = PokemonDetailView.Model()
        XCTAssertEqual(sut.isLoading, false)

        // When
        sut.updateStates(with: .loading)
        // Then
        XCTAssertEqual(sut.isLoading, true)
        // When
        sut.updateStates(with: .success([.init(id: "", name: "", imageUrl: "", type: .fire)]))
        // Then
        XCTAssertEqual(sut.isLoading, false)
        // When
        let error = NSError(domain: "", code: 1)
        sut.updateStates(with: .failure(error))
        // Then
        XCTAssertEqual(sut.isLoading, false)
    }
}
