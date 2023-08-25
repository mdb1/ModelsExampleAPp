import Foundation

/*
 The service layer is the one that communicates with the backend.
 It serves the exact same purpose as what we currently have in the app.
 All the Services should be `internal` and return the `internal` API models.
 The repository will take care of transforming the models to the `public` UI models.
 */
final class PokemonService {
    private var allPokemons: [APIPokemon] = [
        .init(id: "1", name: "Bulbasaur", imageUrl: "", type: .grass, trainerId: nil),
        .init(id: "2", name: "Charmander", imageUrl: "", type: .fire, trainerId: nil),
        .init(id: "3", name: "Squirtle", imageUrl: "", type: .water, trainerId: nil)
    ]

    func getAllPokemons() async throws -> [APIPokemon] {
        // Simulate network request
        try await Task.sleep(nanoseconds: 1_000_000_000)

        return allPokemons
    }

    func removePokemon(id: String) async throws -> () {
        // Simulate network request
        try await Task.sleep(nanoseconds: 1_000_000_000)

        allPokemons.removeAll { pokemon in
            pokemon.id == id
        }
    }
}
