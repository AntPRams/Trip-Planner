@testable import TuiCC
import XCTest
import Combine

class MainViewModelTests: XCTestCase {
    
    var sut: MainViewModel!
    var disposableBag: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        
        sut = MainViewModel(networkProvider: ConnectionsServiceMock())
        sut.originSearchFieldViewModel.text = "A"
        sut.destinationSearchFieldViewModel.text = "E"
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
            .sink { cities in
                guard cities.isNotEmpty else {
                    XCTFail("Cities doesn't contain any value")
                    return
                }
                expectation.fulfill()
                XCTAssertEqual(cities, ["A", "B", "C", "D", "F", "E"])
            }
            .store(in: &disposableBag)
        
        wait(for: [expectation], timeout: 3)
    }
    
    func test_calculatePath() async throws {
        //given
        try await injectMockData()
        
        //when
        sut.calculatePaths()
        XCTAssertTrue(sut.currentState == .loading)
        
        //then
        sut.$pathResult
            .dropFirst()
            .sink { [weak self] path in
                guard let self, let path else {
                    XCTFail("Failed to get path")
                    return
                }
                XCTAssertTrue(sut.currentState == .idle)
                XCTAssertEqual(path.formattedValue, "821")
                XCTAssertEqual(path.stopOvers.last, ["F", "E"])
                XCTAssertEqual(path.stopOvers.first, ["A", "B"])
                XCTAssertEqual(path.coordinates.first?.latitude, 1)
                XCTAssertEqual(path.coordinates.last?.longitude, 123)
            }
            .store(in: &disposableBag)
    }
    
    func test_clearData() {
        //given
        sut.pathResult = .stub()
        
        //when
        XCTAssertNotNil(sut.pathResult)
        XCTAssertTrue(sut.originSearchFieldViewModel.text.isNotEmpty)
        XCTAssertTrue(sut.destinationSearchFieldViewModel.text.isNotEmpty)
        sut.clear()
        
        //then
        XCTAssertNil(sut.pathResult)
        XCTAssertFalse(sut.originSearchFieldViewModel.text.isNotEmpty)
        XCTAssertFalse(sut.destinationSearchFieldViewModel.text.isNotEmpty)
        
    }
}

private extension MainViewModelTests {
    func injectMockData() async throws {
        let connections = try await ConnectionsServiceMock().fetchConnections()
        await sut.pathCalculator.updateConnections(connections)
    }
}

