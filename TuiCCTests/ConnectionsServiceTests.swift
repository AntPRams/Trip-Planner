//
//  ConnectionsServiceTests.swift
//  TuiCCTests
//
//  Created by António Ramos on 23/08/2023.
//
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

    
    func test_fetchConnections() throws {
        
        Task {
            let connections = try await sut.fetchConnections()
            XCTAssertEqual(connections.count, 3)
        }
    }
}
