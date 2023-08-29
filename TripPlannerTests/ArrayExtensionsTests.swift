@testable import TripPlanner
import XCTest

final class ExtensionsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_arrayRemoveDuplicates() {
        //given
        var array = ["a", "b", "c", "d", "a", "e", "b", "a"]
        
        //when
        array.removeDuplicates()
        
        //then
        XCTAssertTrue(array.count == 5)
        XCTAssertEqual(["a", "b", "c", "d", "e"], array)
    }
    
    func test_isNotEmpty() {
        //given
        let emptyArray = [Any]()
        let notEmptyArray = [1, 2, 3]
        
        //then
        XCTAssertFalse(emptyArray.isNotEmpty)
        XCTAssertTrue(notEmptyArray.isNotEmpty)
    }
    
    func test_stringIsNotEmpty() {
        //given
        let emptyString = String()
        let notEmptyString = "some"
        
        //then
        XCTAssertFalse(emptyString.isNotEmpty)
        XCTAssertTrue(notEmptyString.isNotEmpty)
    }
}
