import Foundation

final class ConnectionsService: ConnectionsServiceInterface {
    
    private var apiCaller: APICallerInterface
    
    init(apiCaller: APICallerInterface = APICaller()) {
        self.apiCaller = apiCaller
    }
    
    func fetchConnections() async throws -> [Connection] {
        let data: Connections = try await apiCaller.fetch(from: URL(string: "https://raw.githubusercontent.com/TuiMobilityHub/ios-code-challenge/master/connections.json")!)
        
        guard data.connections.isNotEmpty else {
            throw NetworkError.notFound
        }
        
        return data.connections
    }
}
