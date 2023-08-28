import Foundation

final class ConnectionsService: ConnectionsServiceInterface {
    
    private var apiCaller: APICallerInterface
    
    private let mockurl = Bundle(for: ConnectionsService.self).url(
        forResource: "connectionsPayloadMock",
        withExtension: "json"
    )
    
    init(apiCaller: APICallerInterface = APICaller()) {
        self.apiCaller = apiCaller
    }
    
    func fetchConnections() async throws -> [FlightConnection] {
        guard let url = EndPoint.connections() else {
            throw NetworkError.notFound
        }
        
        let data: Connections? = try await apiCaller.fetch(from: mockurl!)
        
        guard
            let flightConnections = data?.connections?.compactMap(FlightConnection.map(_:)),
            flightConnections.isNotEmpty
        else {
            throw NetworkError.notFound
        }
        
        return flightConnections
    }
}
