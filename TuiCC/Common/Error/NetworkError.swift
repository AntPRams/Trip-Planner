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

func mapResponse(response: (data: Data, response: URLResponse)) throws -> Data {
    guard let httpResponse = response.response as? HTTPURLResponse else {
        return response.data
    }
    
    switch httpResponse.statusCode {
    case 200..<300:
        return response.data
    case 300..<400:
        throw NetworkError.redirected
    case 400:
        throw NetworkError.badRequest
    case 401:
        throw NetworkError.unauthorized
    case 403:
        throw NetworkError.forbidden
    case 404:
        throw NetworkError.notFound
    case 500..<600:
        throw NetworkError.serverError
    default:
        throw NetworkError.unknown
    }
}
