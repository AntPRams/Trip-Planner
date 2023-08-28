import Foundation

enum AppError: Error {
    case noPathsAvailable
    case originMissing
    case destinationMissing
    case pathMissing
    case sameCityInBothFields
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
        case .sameCityInBothFields:
            return Localizable.appErrorSameCityInBothFields
        }
    }
}

