import XCTest

final class MainViewTests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
    }

    func test_uiElements() throws {
        //given

        let title = app.staticTexts["Trip Planner"]
        let searchButtonLabel = app.buttons["searchButton"]
        let clearButtonLabel = app.buttons["clearButton"]
        let refreshButtonLabel = app.buttons["refreshButton"]
        
        //then
        XCTAssert(title.exists)
        XCTAssert(searchButtonLabel.exists)
        XCTAssert(clearButtonLabel.exists)
        XCTAssert(refreshButtonLabel.exists)
    }
    
    func test_dropdownListVisibility() throws {
        
        let originTextField = app.textFields["originSearchField"]
        originTextField.tap()
        originTextField.typeText("c")
        
    }
}
