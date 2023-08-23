import Foundation

protocol APICallerInterface {
    func fetch<T: Decodable>(from url: URL) async throws -> T
}

final class APICaller: APICallerInterface {
    
    func fetch<T: Decodable>(from url: URL) async throws -> T {
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        let fetchedData = try JSONDecoder().decode(T.self, from: try mapResponse(response: (data,response)))
        return fetchedData
    }
}
