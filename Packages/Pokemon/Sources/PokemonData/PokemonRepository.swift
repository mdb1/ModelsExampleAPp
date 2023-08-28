import Combine
import Foundation

/*
 The repository layer will be public and will use Combine to publish the UI models.
 It's marked as ObservableObject to be able to inject it as `environmentObject` into the UI layer.
 It will use the `Dependencies` approach to make it easier to use and to test.
 We could add disk cache capabilities in this layer.
 We could also provide an enum with a FetchStrategy, so the UI can let the repository know which type of data
 it wants (ie: network, diskCache, inMemory, etc).
 We should provide a way to "clear" the repositories, so, for example, we clear all the data on log out.
 */
public final class PokemonRepository: ObservableObject {
    public var pokemonsPublisher = CurrentValueSubject<LoadingState<[Pokemon]>, Never>(.idle)
    private let dependencies: Dependencies
    private var inMemoryPokemons: [Pokemon] = []

    public convenience init() {
        self.init(dependencies: .default)
    }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

public extension PokemonRepository {
    @MainActor
    func loadAllPokemons() async {
        pokemonsPublisher.send(.loading)

        do {
            let apiPokemons = try await dependencies.getAllPokemons()
            let pokemons = apiPokemons.map(\.uiModel)
            inMemoryPokemons = pokemons
            pokemonsPublisher.send(.success(inMemoryPokemons))
        } catch {
            pokemonsPublisher.send(.failure(error))
        }
    }

    @MainActor
    /// Removes the pokemon with the given id.
    /// - Parameters:
    ///   - id: the `id` of the pokemon.
    ///   - optimisticDelete: if `true` the repository will send the updated list of pokemons automatically,
    ///   while deleting with the API in the background. If the API call fails, the repository will re-publish the entire list.
    func removePokemon(
        id: String,
        optimisticDelete: Bool = false
    ) async {
        do {
            var mutablePokemons = inMemoryPokemons
            mutablePokemons.removeAll { pokemon in
                pokemon.id == id
            }
            if optimisticDelete {
                pokemonsPublisher.send(.success(mutablePokemons))
            } else {
                pokemonsPublisher.send(.loading)
            }

            // Delete the pokemon.
            try await dependencies.deletePokemon(id)
            // Refetch all the pokemons.
            await loadAllPokemons()
        } catch {
            pokemonsPublisher.send(.failure(Errors.deletionError))
            /// Re-Publish all the pokemons (without the deletion)
            pokemonsPublisher.send(.success(inMemoryPokemons))
        }
    }

    @MainActor
    func wipe() {
        pokemonsPublisher.send(.idle)
        inMemoryPokemons = []
    }

    enum Errors: Error {
        case deletionError
    }
}

extension PokemonRepository {
    struct Dependencies {
        var getAllPokemons: () async throws -> [APIPokemon]
        var deletePokemon: (_ id: String) async throws -> ()

        static var `default`: Self {
            let service = PokemonService()
            return Self.init {
                return try await service.getAllPokemons()
            } deletePokemon: { pokemonId in
                return try await service.removePokemon(id: pokemonId)
            }
        }
    }
}
