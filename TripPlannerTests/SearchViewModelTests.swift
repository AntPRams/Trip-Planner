@testable import TripPlanner
import XCTest
import Combine

final class SearchViewModelTests: XCTestCase {
    
    var sut: SearchFieldViewModel!
    var disposableBag = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        
        sut = SearchFieldViewModel(connectionType: .origin)
        sut.updateCities(["Tokyo", "London", "Los Angeles", "Cape Town"])
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func test_citiesFilter() {
        //then
        XCTAssertEqual(getFilterResults("o"), ["Tokyo", "London", "Los Angeles", "Cape Town"])
        XCTAssertEqual(getFilterResults("l"), ["London", "Los Angeles"])
        XCTAssertEqual(getFilterResults("C"), ["Cape Town"])
        XCTAssertEqual(getFilterResults("z"), [])
    }
    
    func test_shouldHideDropdownWhenCityIsWellWritten() {
        //given
        setDropdownFlags(isBeingEdited: true, text: "Tokyo")
        
        XCTAssertFalse(sut.showDropDown)
    }
    
    func test_shouldShowDropdownWithResults() {
        //given
        setDropdownFlags(isBeingEdited: true, text: "o")
        
        //then
        XCTAssertTrue(sut.showDropDown)
    }
    
    func test_shouldHideDropdownWithoutResults() {
        //given
        setDropdownFlags(isBeingEdited: true, text: "z")
        
        XCTAssertFalse(sut.showDropDown)
    }
    
    func test_shouldHideDropdownWhenIsNotBeingEdited() {
        //given
        setDropdownFlags(isBeingEdited: false, text: "Lo")
        
        XCTAssertFalse(sut.showDropDown)
    }
}

private extension SearchViewModelTests {
    
    func getFilterResults(_ query: String) -> [String] {
        let expectation = XCTestExpectation(description: "Did receive cities")
        var filteredCities = [String]()
        sut.performSearch(query: query)
        
        sut.$filteredCities
            .sink { cities in
                filteredCities = cities
                expectation.fulfill()
            }
            .store(in: &disposableBag)
        
        wait(for: [expectation], timeout: 0.1)
        
        return filteredCities
    }
    
    private func setDropdownFlags(isBeingEdited: Bool, text: String) {
        sut.isBeingEdited = isBeingEdited
        sut.text = text
        sut.performSearch(query: text)
        sut.shouldShowDropdown()
    }
}
