@testable import TuiCC
import Foundation
import XCTest

final class ConnectionsServiceMock: ConnectionsServiceInterface {
    
    private var apiCaller: APICallerInterface
    
    init(apiCaller: APICallerInterface = APICaller()) {
        self.apiCaller = apiCaller
    }
    
    func fetchConnections() async throws -> [TuiCC.Connection] {
        let url = Bundle(for: ConnectionsServiceMock.self).url(
            forResource: "connectionsMock",
            withExtension: "json"
        )
        let data: Connections = try await apiCaller.fetch(from: url!)
        
        return data.connections
    }
}
