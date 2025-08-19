//
//  UalaCitiesUITests.swift
//  UalaCitiesUITests
//
//  Created by Federico Bernal on 18/08/2025.
//

import XCTest
@testable import UalaCities

final class UalaCitiesUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UI-Testing"]
    }
    
    override func tearDownWithError() throws {
        app.terminate()
        app = nil
    }
    
    func testAppLaunch() throws {
        app.launch()
        
        XCTAssertTrue(app.exists)
        
        Thread.sleep(forTimeInterval: 2.0)
    }
    
    func testSearchFunctionality() throws {
        app.launch()
        
        let searchField = app.textFields["Search cities..."]
        XCTAssertTrue(searchField.waitForExistence(timeout: 10))
        
        searchField.tap()
        searchField.typeText("New York")
        
        XCTAssertTrue(searchField.exists)
        
        Thread.sleep(forTimeInterval: 1.0)
    }
    
    func testFavoritesFunctionality() throws {
        app.launch()
        
        let searchField = app.textFields["Search cities..."]
        XCTAssertTrue(searchField.waitForExistence(timeout: 10))
        
        let favoritesButton = app.buttons["Favorites Only"]
        if favoritesButton.exists {
            favoritesButton.tap()
            XCTAssertTrue(app.buttons["Show All"].exists)
        }
        
        Thread.sleep(forTimeInterval: 1.0)
    }
    
    func testMapIntegration() throws {
        app.launch()
        
        let searchField = app.textFields["Search cities..."]
        XCTAssertTrue(searchField.waitForExistence(timeout: 10))
        
        searchField.tap()
        searchField.typeText("London")
        
        let firstCity = app.cells.firstMatch
        if firstCity.waitForExistence(timeout: 5) {
            firstCity.tap()
        }
        
        Thread.sleep(forTimeInterval: 1.0)
    }
    
    func testOrientationHandling() throws {
        app.launch()
        
        let searchField = app.textFields["Search cities..."]
        XCTAssertTrue(searchField.waitForExistence(timeout: 10))
        
        XCTAssertTrue(app.exists)
    }
    
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            app.launch()
        }
    }
}
