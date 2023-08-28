import Foundation
import PokemonData
import SwiftUI

extension PokemonListView {
    /*
     This is the source of truth for the view.
     Whenever anything changes in this model, the UI will react accordingly.
     */
    struct Model {
        var pokemons: [Pokemon] = []
        var isLoading: Bool = false
        var error: Error? = nil
        var isDisplayingDeletionErrorToast: Bool = false
    }
}

extension PokemonListView.Model {
    /*
     Whenever we receive a new update in the view, we will call this method to modify the state.
     This is the most important part of the UI layer to test.
     */
    mutating func updateStates(with newState: LoadingState<[Pokemon]>) {
        switch newState {
        case .idle:
            pokemons = []
            isLoading = false
            error = nil
        case .loading:
            isLoading = true
        case .success(let t):
            pokemons = t
            isLoading = false
            error = nil
        case .failure(let e):
            error = e
            if e as? PokemonRepository.Errors == .deletionError {
                isDisplayingDeletionErrorToast = true
            }
            isLoading = false
        }
    }

    var hasPokemons: Bool {
        !pokemons.isEmpty
    }
}
