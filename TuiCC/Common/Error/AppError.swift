import Foundation

enum AppError: Error {
    case noPathsAvailable
}

extension AppError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noPathsAvailable:
            return AppConstants.localized(.appErrorNoPathsAvailable)
        }
    }
}

