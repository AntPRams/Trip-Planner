//
//  TuiCCTests.swift
//  TuiCCTests
//
//  Created by António Ramos on 23/08/2023.
//

import XCTest
@testable import TuiCC

final class ArrayExtensionsTests: XCTestCase {
    
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
}
