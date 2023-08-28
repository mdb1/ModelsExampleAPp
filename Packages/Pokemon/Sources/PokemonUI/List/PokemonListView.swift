import PokemonData
import SwiftUI

public struct PokemonListView: View {
    // Environment object to share the same instance with all the sub views.
    @EnvironmentObject private var repository: PokemonRepository
    // State property to react to the changes.
    @State private var model: Model = .init()

    public init() {}

    public var body: some View {
        NavigationView {
            List {
                ForEach($model.pokemons) { pokemon in
                    pokemonRowView(pokemon)
                }
                loadButton
                wipeButton
            }
            .navigationTitle("Pokemon List")
            // We subscribe to the repository's publisher.
            .onReceive(repository.pokemonsPublisher) { newState in
                // And every time we receive a value we update the state.
                model.updateStates(with: newState)
            }
            .alert(isPresented: $model.isDisplayingDeletionErrorToast) {
                Alert(title: Text("Error removing Pokemon"))
            }
        }
    }
}

private extension PokemonListView {
    func pokemonRowView(_ pokemon: Binding<Pokemon>) -> some View {
        NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
            VStack(alignment: .leading) {
                Text(pokemon.wrappedValue.name)
                    .bold()
                Text("Type: \(pokemon.wrappedValue.type.rawValue)")
                Text("Id: \(pokemon.id)")
            }
        }
    }

    @ViewBuilder
    var loadButton: some View {
        if !model.hasPokemons {
            HStack {
                Button("Load Pokemons") {
                    Task {
                        await repository.loadAllPokemons()
                    }
                }
                Spacer()
                if model.isLoading {
                    ProgressView()
                }
            }
        }
    }

    var wipeButton: some View {
        Button("Wipe Data") {
            repository.wipe()
        }
    }
}
