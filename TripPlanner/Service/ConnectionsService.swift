import Foundation

protocol Service {
    associatedtype DataType
    func fetchConnections() async throws -> [DataType]
}

final class ConnectionsService: Service {
    typealias DataType = FlightConnection
    
    // MARK: - Properties
    
    private var apiCaller: APICallerInterface
    private var url: URL?
    
    // MARK: - Init
    
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
    
    // MARK: - Public interface
    
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
