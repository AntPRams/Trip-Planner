import XCTest

final class MainViewTests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments.append("UITesting")
        app.launch()
    }

    override func tearDownWithError() throws { }

    func test_uiElements() throws {
        //given
        let title = app.staticTexts["Trip Planner"]
        let searchButtonLabel = app.buttons["searchButton"]
        let clearButtonLabel = app.buttons["clearButton"]
        let refreshButtonLabel = app.buttons["refreshButton"]
        
        //then
        XCTAssertTrue(title.exists)
        XCTAssertTrue(refreshButtonLabel.exists)
        XCTAssertTrue(clearButtonLabel.exists)
        XCTAssertTrue(searchButtonLabel.exists)
    }
    
    func test_dropdownListVisibilityWithResults() throws {
        //given
        let originTextField = app.textFields["originSearchField"]
        let dropDownlist = app.otherElements["dropDownListView"]
        let firstRow = dropDownlist.staticTexts["cityRow"]

        //when
        originTextField.tap()
        originTextField.typeText("Os")
        
        //then
        XCTAssertTrue(dropDownlist.exists)
        XCTAssertTrue(firstRow.exists)
        XCTAssertEqual(firstRow.label, "Oslo")
    }
    
    func test_dropdownListVisibilityWithoutResults() throws {
        //given
        let originTextField = app.textFields["originSearchField"]
        let dropDownlist = app.otherElements["dropDownListView"]

        //when
        originTextField.tap()
        originTextField.typeText("Foo")
        
        //then
        XCTAssertFalse(dropDownlist.exists)
    }
    
    func test_searchPathFromUsingSuggestions() throws {
        //given
        let originTextField = app.textFields["originSearchField"]
        let destinationTextField = app.textFields["destinationSearchField"]
        let dropDownlist = app.otherElements["dropDownListView"]
        let searchButton = app.buttons["searchButton"]
        let firstRow = dropDownlist.staticTexts["cityRow"]
        
        let bottomView = app.scrollViews["bottomScrollView"]
        let mapView = bottomView.otherElements["mapView"]
        let mapViewAnnotationsContainer = mapView.otherElements["AnnotationContainer"]
        let bestDealText = app.staticTexts["⭐️ Best deal"]
        let priceText = app.staticTexts["821 €"]
        
        //when
        originTextField.tap()
        originTextField.typeText("Lis")
        firstRow.tap()
        
        destinationTextField.tap()
        destinationTextField.typeText("An")
        firstRow.tap()
        searchButton.tap()
        
        //then
        XCTAssertTrue(bestDealText.waitForExistence(timeout: 0.2))
        XCTAssertTrue(priceText.waitForExistence(timeout: 0.2))
        XCTAssertTrue(mapView.waitForExistence(timeout: 0.2))
        XCTAssertTrue(mapViewAnnotationsContainer.waitForExistence(timeout: 0.2))
        XCTAssertFalse(dropDownlist.exists)
    }
    
    func test_clearPath() throws {
        //given
        let originTextField = app.textFields["originSearchField"]
        let destinationTextField = app.textFields["destinationSearchField"]
        let clearButton = app.buttons["clearButton"]
        let searchButton = app.buttons["searchButton"]
        
        let bottomView = app.scrollViews["bottomScrollView"]
        let mapView = bottomView.otherElements["mapView"]
        let bestDealText = app.staticTexts["⭐️ Best deal"]
        
        //when
        originTextField.tap()
        originTextField.typeText("Lisbon")
        
        destinationTextField.tap()
        destinationTextField.typeText("Oslo")
        searchButton.tap()
        
        XCTAssertTrue(mapView.waitForExistence(timeout: 0.2))
        XCTAssertTrue(bestDealText.waitForExistence(timeout: 0.2))
        
        clearButton.tap()
        
        //then
        XCTAssertFalse(mapView.exists)
        XCTAssertFalse(bestDealText.exists)
    }
    
    func test_searchError() throws {
        //given
        let originTextField = app.textFields["originSearchField"]
        let destinationTextField = app.textFields["destinationSearchField"]
        let searchButton = app.buttons["searchButton"]
        let alertView = app.alerts.firstMatch
        
        //when
        originTextField.tap()
        originTextField.typeText("Foo")
        
        destinationTextField.tap()
        destinationTextField.typeText("Foo")
        searchButton.tap()
        
        //then
        XCTAssertEqual(alertView.label, "Please select different cities.")
        alertView.buttons.firstMatch.tap()
    }
    
    func test_noPathsAvailableError() throws {
        //given
        let originTextField = app.textFields["originSearchField"]
        let destinationTextField = app.textFields["destinationSearchField"]
        let searchButton = app.buttons["searchButton"]
        let alertView = app.alerts.firstMatch
        
        //when
        originTextField.tap()
        originTextField.typeText("Foo")
        
        destinationTextField.tap()
        destinationTextField.typeText("Bar")
        searchButton.tap()
        
        //then
        XCTAssertEqual(alertView.label, "There are no paths available.")
        alertView.buttons.firstMatch.tap()
    }
}
