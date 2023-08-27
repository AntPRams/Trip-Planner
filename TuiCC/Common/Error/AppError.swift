import Foundation

enum AppError: Error {
    case noPathsAvailable
    case originMissing
    case destinationMissing
    case pathMissing
}

extension AppError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noPathsAvailable:
            return Localizable.appErrorNoPathsAvailable
        case .originMissing:
            return Localizable.appErrorOriginMissing
        case .destinationMissing:
            return Localizable.appErrorDestinationMissing
        case .pathMissing:
            return Localizable.appErrorPathMissing
        }
    }
}

