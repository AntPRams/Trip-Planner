import Foundation

protocol Service {
    associatedtype DataType
    func fetchConnections() async throws -> [DataType]
}

final class ConnectionsService: Service {
    typealias DataType = FlightConnection
    
    private var apiCaller: APICallerInterface
    private var url: URL?
    
    init(
        apiCaller: APICallerInterface = APICaller(),
        url: URL? = EndPoint.connections.url
    ) {
        if ProcessInfo.processInfo.arguments.contains("UITesting") {
            self.url = URLMocks.getMockDataUrl(for: .mockConnections)
        } else {
            self.url = url
        }
        
        self.apiCaller = apiCaller
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
