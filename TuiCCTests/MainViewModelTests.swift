@testable import TuiCC
import XCTest
import Combine

class MainViewModelTests: XCTestCase {
    
    var sut: MainViewModel!
    var disposableBag: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        
        sut = MainViewModel(networkProvider: ConnectionsServiceMock())
        disposableBag = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        sut = nil
        disposableBag = nil
        super.tearDown()
    }
    
    func test_fetchData() {
        //given
        let expectation = XCTestExpectation(description: "Did receive payload")
        
        //when
        sut.fetchData()
        
        //then
        sut.$connections
            .dropFirst() //Dropping the initial value
            .sink { connections in
                guard connections.isNotEmpty else {
                    XCTFail("Did not receive data")
                    return
                }
                expectation.fulfill()
            }
            .store(in: &disposableBag)
            
        wait(for: [expectation])
    }
    
    func test_extractCities() {
        //given
        let expectation = XCTestExpectation(description: "Did set cities")
        
        //when
        sut.fetchData()
        
        //then
        sut.$cities
            .dropFirst() //Dropping the initial value
            .sink { [weak self] cities in
                guard let self, cities.isNotEmpty else {
                    return
                }
                expectation.fulfill()
                XCTAssertEqual(sut.cities, ["Porto", "Madrid", "Paris", "Lisbon"])
            }
            .store(in: &disposableBag)
        
        wait(for: [expectation])
    }
}
