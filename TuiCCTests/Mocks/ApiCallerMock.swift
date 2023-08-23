@testable import TuiCC
import Foundation
import XCTest

final class ApiCallerMock: APICallerInterface {
    
    var expectation: XCTestExpectation
    
    init(expectation: XCTestExpectation) {
        self.expectation = expectation
    }
    
    func fetch<T: Decodable>(from url: URL) async throws -> T {
    
        
        return Error
    }
}
