import Foundation

public enum NetworkError: Error, LocalizedError {
    case redirected
    case notFound
    case badRequest
    case unauthorized
    case forbidden
    case serverError
    case http(httpResponse: HTTPURLResponse, data: Data)
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
        throw NetworkError.http(httpResponse: httpResponse, data: response.data)
    }
}
