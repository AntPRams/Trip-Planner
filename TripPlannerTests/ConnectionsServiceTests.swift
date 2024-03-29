@testable import TripPlanner
import XCTest

final class ConnectionsServiceTests: XCTestCase {
    
    var sut: ConnectionsService!
    
    override func setUp() {
        super.setUp()
        let url = URLMocks.getMockDataUrl(for: .mockConnections)
        sut = ConnectionsService(url: url)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_fetchData() async throws {
        //when
        let connections = try await sut.fetchConnections()
        
        //then
        XCTAssertTrue(connections.count == 6)
        XCTAssertTrue(connections[0].origin == "Lisbon")
        XCTAssertEqual(connections[5].destination, "Ankara")
        XCTAssertEqual(connections[2].price, 200)
    }
}
