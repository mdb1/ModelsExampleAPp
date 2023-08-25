import Combine
@testable import PokemonData
import XCTest

final class PokemonRepositoryTests: XCTestCase {
    func test_loadAllPokemons_success() async {
        // Given
        let expectedPokemons: [APIPokemon] = [.mock]
        let sut = PokemonRepository(
            dependencies: .init(
                getAllPokemons: {
                    expectedPokemons
                }, deletePokemon: { _ in
                    ()
                }
            )
        )
        var cancellables: [AnyCancellable] = []

        // When
        let exp = expectation(description: "Publisher")

        sut.pokemonsPublisher.sink { result in
            switch result {
            case .idle:
                ()
            case .loading:
                ()
            case .success(let pokemons):
                XCTAssertEqual(pokemons.count, 1)
                XCTAssertEqual(pokemons, expectedPokemons.map(\.uiModel))
                exp.fulfill()
            case .failure:
                XCTFail("Shouldn't reach this point")
            }
        }
        .store(in: &cancellables)

        await sut.loadAllPokemons()
        await fulfillment(of: [exp], timeout: 1)
    }

    func test_loadAllPokemons_error() async {
        // Given
        let expectedError = SomeError()
        let sut = PokemonRepository(
            dependencies: .init(
                getAllPokemons: {
                    throw expectedError
                }, deletePokemon: { _ in
                    ()
                }
            )
        )
        var cancellables: [AnyCancellable] = []

        // When
        let exp = expectation(description: "Publisher")

        sut.pokemonsPublisher.sink { result in
            switch result {
            case .idle:
                ()
            case .loading:
                ()
            case .success:
                XCTFail("Shouldn't reach this point")
            case .failure(let error):
                XCTAssertEqual(error as? SomeError, expectedError)
                exp.fulfill()
            }
        }
        .store(in: &cancellables)

        await sut.loadAllPokemons()
        await fulfillment(of: [exp], timeout: 1)
    }

    func test_wipe() async {
        // Given
        let expectedError = SomeError()
        let sut = PokemonRepository(
            dependencies: .init(
                getAllPokemons: {
                    throw expectedError
                }, deletePokemon: { _ in
                    ()
                }
            )
        )
        sut.pokemonsPublisher = .init(.loading)

        // When
        await sut.wipe()

        // Then
        XCTAssertEqual(sut.pokemonsPublisher.value, .idle)
    }
}

extension APIPokemon {
    static var mock: Self {
        APIPokemon(id: "1", name: "Name", imageUrl: "url", type: .fire, trainerId: "2")
    }
}

extension Pokemon {
    static var mock: Self {
        let apiPokemonMock = APIPokemon.mock
        return apiPokemonMock.uiModel
    }
}

struct SomeError: Error, Equatable {}
