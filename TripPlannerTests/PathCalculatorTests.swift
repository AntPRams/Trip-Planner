@testable import TripPlanner
import XCTest
import Combine

class PathCalculatorTests: XCTestCase {
    
    var sut: PathCalculator!
    
    override func setUp() {
        super.setUp()
        
        sut = PathCalculator()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_generatePathSuccessfully() async throws {
        //given
        await sut.updateConnections(createFlightConnections())
        
        //when
        let path = try await sut.generatePath(from: "Lisbon", to: "Ankara")
        
        //then
        XCTAssertEqual(path.price, 30)
        XCTAssertEqual(path.formattedValue, "30 €")
        XCTAssertEqual(path.stopOvers.count, 3)
        XCTAssertEqual(path.stopOvers[0], ["Lisbon", "Oslo"])
        XCTAssertEqual(path.stopOvers[2], ["Rome", "Ankara"])
    }
    
    func test_generatePathWithFailure() async throws {
        //given
        await sut.updateConnections(createFlightConnections())
        
        //when
        do {
            let path = try await sut.generatePath(from: "Oslo", to: "Lisbon")
            XCTFail("It's supposed to throw error")
        } catch {
            //then
            XCTAssertEqual(error as? AppError, .noPathsAvailable)
        }
    }
}

private extension PathCalculatorTests {
    
    func createFlightConnections() -> [FlightConnection] {
        [
            .stub(price: 10, origin: "Lisbon", destination: "Oslo"),
            .stub(price: 31, origin: "Lisbon", destination: "Ankara"),
            .stub(price: 10, origin: "Rome", destination: "Ankara"),
            .stub(price: 10, origin: "Oslo", destination: "Rome")
        ]
    }
}


//
//func test_calculatePath() async throws {
//    //given
//    await sut.pathCalculator.updateConnections(createFlightConnections())
//    
//    //when
//    sut.calculatePaths()
//    XCTAssertTrue(sut.currentState == .loading)
//    
//    //then
//    sut.$pathResult
//        .sink { [weak self] path in
//            guard let self, let path else {
//                XCTFail("Failed to get path")
//                return
//            }
//            XCTAssertTrue(sut.currentState == .idle)
//            XCTAssertEqual(path.formattedValue, "821")
//            XCTAssertEqual(path.stopOvers.last, ["F", "E"])
//            XCTAssertEqual(path.stopOvers.first, ["A", "B"])
//            XCTAssertEqual(path.coordinates.first?.latitude, 1)
//            XCTAssertEqual(path.coordinates.last?.longitude, 123)
//        }
//        .store(in: &disposableBag)
//}
