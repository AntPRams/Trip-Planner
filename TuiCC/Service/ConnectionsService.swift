import Foundation

final class ConnectionsService: ConnectionsServiceInterface {
    
    private var apiCaller: APICallerInterface
    
    private let mockurl = Bundle(for: ConnectionsService.self).url(
        forResource: "payload",
        withExtension: "json"
    )
    
    init(apiCaller: APICallerInterface = APICaller()) {
        self.apiCaller = apiCaller
    }
    
    func fetchConnections() async throws -> [Connection] {
        guard let url = EndPoint.connections() else {
            throw NetworkError.notFound
        }
        
        let data: Connections = try await apiCaller.fetch(from: url)
        
        guard data.connections.isNotEmpty else {
            throw NetworkError.notFound
        }
        
        return data.connections
    }
}
