import Foundation
import PokemonData

extension PokemonDetailView {
    struct Model {
        var isLoading: Bool = false

        mutating func updateStates(with newState: LoadingState<[Pokemon]>) {
            switch newState {
            case .loading:
                isLoading = true
            default:
                isLoading = false
            }
        }
    }
}
