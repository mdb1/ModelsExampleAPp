import Foundation

public enum LoadingState<T>: Equatable {
    case idle
    case loading
    case success(T)
    case failure(Error)

    public static func == (lhs: LoadingState<T>, rhs: LoadingState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.success, .success):
            return true
        case (.failure, .failure):
            return true
        default:
            return false
        }
    }

    public var info: T? {
        switch self {
        case .success(let info):
            return info
        default:
            return nil
        }
    }
}
