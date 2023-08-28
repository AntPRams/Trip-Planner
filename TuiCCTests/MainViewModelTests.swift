@testable import TuiCC
import XCTest
import Combine

class MainViewModelTests: XCTestCase {
    
    var sut: MainViewModel!
    var disposableBag: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        
        sut = MainViewModel()
        sut.originSearchFieldViewModel.text = "Lisbon"
        sut.destinationSearchFieldViewModel.text = "Ankara"
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
        let url = URLMocks.getMockDataUrl(for: .mockConnections)
        sut = MainViewModel(service: ConnectionsService(url: url))
        
        //when
        sut.fetchData()
        XCTAssertTrue(sut.currentState == .loading)
        
        //then
        sut.$cities
            .dropFirst() //Dropping the initial value
            .sink { cities in
                guard cities.isNotEmpty else {
                    XCTFail("Cities doesn't contain any value")
                    return
                }
                expectation.fulfill()
                XCTAssertEqual(cities, ["Lisbon", "London", "Oslo", "Berlin", "Rome", "Ankara"])
            }
            .store(in: &disposableBag)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_calculatePathError() throws {
        //when
        sut.calculatePaths()
        
        //then
        assertError(AppError.noPathsAvailable)
    }
    
    func test_fetchDataError() throws {
        //given
        let url = URLMocks.getMockDataUrl(for: .nullConnections)
        sut = MainViewModel(service: ConnectionsService(url: url))
        
        //when
        sut.fetchData()
        
        //then
        assertError(NetworkError.noData)
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
    
    func test_searchValidationErrors() {
        validateSearch(origin: String(), destination: String(), customError: .pathMissing)
        validateSearch(origin: "Some", destination: String(), customError: .destinationMissing)
        validateSearch(origin: String(), destination: "Some", customError: .originMissing)
        validateSearch(origin: "Some", destination: "Some", customError: .sameCityInBothFields)
    }
}

private extension MainViewModelTests {
    
    func assertError<T: Equatable>(_ customError: T) {
        //when
        let expectation = XCTestExpectation(description: "Did fail with expected error")
        
        //then
        sut.$error
            .dropFirst()
            .sink { error in
                expectation.fulfill()
                XCTAssertEqual(error as? T, customError)
            }
            .store(in: &disposableBag)
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func validateSearch(origin: String, destination: String, customError: AppError) {
        do {
            try sut.validateSearch(origin: origin, destination: destination)
        } catch {
            XCTAssertEqual(error as? AppError, customError)
        }
    }
}


