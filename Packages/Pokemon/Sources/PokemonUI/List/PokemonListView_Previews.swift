import Foundation
// We can use @testable import to be able to access the `internal` init of the repository.
// By doing so, we can inject mock dependencies for the previews.
@testable import PokemonData
import SwiftUI

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView()
            .environmentObject(
                PokemonRepository(
                    dependencies: .init(
                        getAllPokemons: {
                            try await Task.sleep(for: .seconds(1))
                            return [
                                .init(
                                    id: "1",
                                    name: "Mock",
                                    imageUrl: "",
                                    type: .grass,
                                    trainerId: nil
                                )
                            ]
                        }, deletePokemon: { _ in
                            ()
                        }
                    )
                )
            )
    }
}
