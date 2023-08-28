import Foundation

final class ConnectionsService {
    
    private var apiCaller: APICallerInterface
    private var url: URL?
    
    init(
        apiCaller: APICallerInterface = APICaller(),
        url: URL? = EndPoint.connections.url
    ) {
        self.apiCaller = apiCaller
        self.url = url
    }
    
    func fetchConnections() async throws -> [FlightConnection] {
        guard let url else {
            throw NetworkError.unknown
        }
        
        let data: Connections? = try await apiCaller.fetch(from: url)
        
        guard
            let flightConnections = data?.connections?.compactMap(FlightConnection.map(_:)),
            flightConnections.isNotEmpty
        else {
            throw NetworkError.noData
        }
        
        return flightConnections
    }
}
