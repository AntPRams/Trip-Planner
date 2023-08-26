import Foundation

enum NetworkError: Error {
    case redirected
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case unknown
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .redirected:
            return AppConstants.localized(.networkErrorBadRequest)
        case .badRequest:
            return AppConstants.localized(.networkErrorBadRequest)
        case .unauthorized, .forbidden:
            return AppConstants.localized(.networkErrorUnauthorized)
        case .notFound:
            return AppConstants.localized(.networkErrorNotFound)
        case .serverError:
            return AppConstants.localized(.networkError500GenericMessage)
        case .unknown:
            return AppConstants.localized(.networkErrorUnknown)
        }
    }
}
