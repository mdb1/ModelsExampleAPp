import Foundation
import SwiftUI
@testable import PokemonData

struct PokemonDetailView_Previews: PreviewProvider {
    struct DetailWrapper: View {
        @State var pokemon: Pokemon = .init(id: "1", name: "Mock", imageUrl: "", type: .water)

        var body: some View {
            PokemonDetailView(pokemon: $pokemon)
                .environmentObject(
                    PokemonRepository(
                        dependencies: .init(
                            getAllPokemons: {
                                []
                            }, deletePokemon: { _ in
                                ()
                            }
                        )
                    )
                )
        }
    }

    static var previews: some View {
        NavigationView {
            DetailWrapper()
        }
    }
}
