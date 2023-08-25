import Foundation

/*
 API Models are the models defined by the Backend, the `Decodable` models.
 We will make them `internal` to make the UI layer completely agnostic of these models.
 */
struct APIPokemon: Decodable, Identifiable, Equatable {
    let id: String
    let name: String
    let imageUrl: String
    let type: `Type`
    let trainerId: String?
}

extension APIPokemon {
    enum `Type`: String, Decodable {
        case fire, water, grass
    }
}
