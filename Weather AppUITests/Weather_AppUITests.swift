//
//  Weather_AppUITests.swift
//  Weather AppUITests
//
//  Created by Takudzwa Raisi on 2025/09/18.
//

import XCTest

final class Weather_AppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it's important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testSplashScreenAppears() throws {
        let app = XCUIApplication()
        app.launch()
        let splash = app.staticTexts["Weather App"]
        XCTAssertTrue(splash.waitForExistence(timeout: 2), "Splash screen should appear")
    }

    @MainActor
    func testTabNavigation() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Favourites"].tap()
        XCTAssertTrue(app.navigationBars["Favourites"].exists)
        app.tabBars.buttons["Map"].tap()
        XCTAssertTrue(app.otherElements["Map"].exists || app.staticTexts["Map"].exists)
        app.tabBars.buttons["Weather"].tap()
        XCTAssertTrue(app.staticTexts["Current Location"].exists)
    }

    @MainActor
    func testSearchAndAddFavourite() throws {
        let app = XCUIApplication()
        app.launch()
        app.navigationBars.buttons["magnifyingglass"].tap()
        let searchField = app.textFields["Search for a city or place"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 2))
        searchField.tap()
        searchField.typeText("London")
        app.buttons["Search"].tap()
        let londonCell = app.staticTexts["London"]
        XCTAssertTrue(londonCell.waitForExistence(timeout: 5))
        londonCell.tap()
        XCTAssertTrue(app.staticTexts["London"].exists)
    }

    @MainActor
    func testSelectAndRemoveFavourite() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Favourites"].tap()
        let firstCell = app.cells.element(boundBy: 0)
        if firstCell.exists {
            firstCell.tap()
            XCTAssertTrue(app.staticTexts[firstCell.staticTexts.element.label].exists)
            // Swipe to delete
            firstCell.swipeLeft()
            app.buttons["Delete"].tap()
            XCTAssertFalse(app.staticTexts[firstCell.staticTexts.element.label].exists)
        }
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
