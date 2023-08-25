import Foundation

/*
 UI models are defined as `public`, these are the models that the UI layer will observe,
 and react to the changes in them.
 */
public struct Pokemon: Decodable, Identifiable, Equatable {
    public let id: String
    public let name: String
    public let imageUrl: String
    public let type: `Type`
}

public extension Pokemon {
    enum `Type`: String, Decodable {
        case fire, water, grass, unknown
    }
}
