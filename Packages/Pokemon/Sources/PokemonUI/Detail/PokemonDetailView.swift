import Foundation
import SwiftUI
import PokemonData

/*
 This view get's initialized with a binding to the pokemon.
 This means that any change to that model, will be replicated in the parent view.
 The binding is directly taken from the parent's model, that gets updated when the repository publishes.
 So everything should be always in sync.
 For example, if the repository decided to publish a new list of pokemons, where the one we are seeing (same id)
 gets a change in their name, or type, this view would get automatically updated via the onReceive modifier.
 */
struct PokemonDetailView: View {
    @Binding var pokemon: Pokemon
    @EnvironmentObject private var repository: PokemonRepository
    @State private var model: Model = .init()

    public var body: some View {
        VStack(alignment: .leading) {
            Text(pokemon.name)
                .bold()
                .font(.title)
            Text("Type: \(pokemon.type.rawValue)")
            Text("Id: \(pokemon.id)")

            HStack {
                Button("Remove") {
                    Task {
                        await repository.removePokemon(id: pokemon.id)
                    }
                }
                .buttonStyle(BorderedButtonStyle())
                .tint(.red)

                Spacer()

                if model.isLoading {
                    ProgressView()
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .navigationTitle("Detail")
        .onReceive(repository.pokemonsPublisher) { newState in
            model.updateStates(with: newState)
        }
    }
}
