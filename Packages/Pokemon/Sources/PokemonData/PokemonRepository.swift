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

    public convenience init() {
        self.init(dependencies: .default)
    }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    @MainActor
    public func loadAllPokemons() async {
        pokemonsPublisher.send(.loading)

        do {
            let apiPokemons = try await dependencies.getAllPokemons()
            let pokemons = apiPokemons.map(\.uiModel)
            pokemonsPublisher.send(.success(pokemons))
        } catch {
            pokemonsPublisher.send(.failure(error))
        }
    }

    @MainActor
    public func removeVehicle(id: String) async {
        switch pokemonsPublisher.value {
        case .success(let pokemons):
            do {
                var mutablePokemons = pokemons
                if let pokemonIndex = pokemons.firstIndex(where: { pokemon in
                    pokemon.id == id
                }) {
                    pokemonsPublisher.send(.loading)
                    try await dependencies.deletePokemon(id)
                    mutablePokemons.remove(at: pokemonIndex)
                    pokemonsPublisher.send(.success(mutablePokemons))
                }
            } catch {
                pokemonsPublisher.send(.failure(error))
            }
        default:
            ()
        }
    }

    @MainActor
    public func wipe() {
        pokemonsPublisher.send(.idle)
    }
}

extension PokemonRepository {
    struct Dependencies {
        var getAllPokemons: () async throws -> [APIPokemon]
        var deletePokemon: (_ id: String) async throws -> ()

        static var `default`: Self {
            Self.init {
                return try await PokemonService().getAllPokemons()
            } deletePokemon: { pokemonId in
                return try await PokemonService().removePokemon(id: pokemonId)
            }
        }
    }
}
