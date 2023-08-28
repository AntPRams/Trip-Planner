@testable import TuiCC
import Foundation
import XCTest

final class ConnectionsServiceMock: ConnectionsServiceInterface {
    
    private var apiCaller: APICallerInterface
    private var payloadWithOptionals: Bool
    
    init(apiCaller: APICallerInterface = APICaller(), payloadWithOptionals: Bool = false) {
        self.apiCaller = apiCaller
        self.payloadWithOptionals = payloadWithOptionals
    }
    
    func fetchConnections() async throws -> [TuiCC.FlightConnection] {
        let url = Bundle(for: ConnectionsServiceMock.self)
            .url(
                forResource: Constants.fileName,
                withExtension: Constants.jsonExtension
            )!
        
        let data: Connections? = try await apiCaller.fetch(from: url)
        
        guard
            let flightConnections = data?.connections?.compactMap(FlightConnection.map(_:)),
            flightConnections.isNotEmpty
        else {
            throw NetworkError.notFound
        }
        
        return flightConnections
    }
}

private enum Constants {
    
    static let fileName = "connectionsPayloadMock"
    static let jsonExtension = "json"
}
