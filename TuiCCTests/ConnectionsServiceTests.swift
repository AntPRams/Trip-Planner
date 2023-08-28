@testable import TuiCC
import XCTest

final class ConnectionsServiceTests: XCTestCase {
    
    var sut: ConnectionsServiceInterface!
    
    override func setUp() {
        super.setUp()
        sut = ConnectionsServiceMock()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_fetchConnections() async throws {
        //when
        let connections = try await sut.fetchConnections()
        
        //then
        XCTAssertTrue(connections.count == 6)
        XCTAssertTrue(connections[0].origin == "A")
        XCTAssertEqual(connections[5].destination, "E")
        XCTAssertEqual(connections[2].price, 200)
    }
}
