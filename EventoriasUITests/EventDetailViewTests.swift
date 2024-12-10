//
//  EventDetailViewTests.swift
//  EventoriasUITests
//
//  Created by Louise Ta on 09/12/2024.
//

import XCTest

final class EventDetailViewTests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments.append("UI_TEST_MODE")
        app.launchEnvironment["UI_TEST_LOGGED_IN"] = "true"
        app.launch()
        app.cells.element(boundBy: 0).tap()
    }
    
    override func tearDownWithError() throws {
        app.terminate()
    }

    func testEventDetailView() throws {
    
        let eventTitle = app.staticTexts["eventTitle"]
        let eventDate = app.staticTexts["eventDate"]
        let eventTime = app.staticTexts["eventTime"]
        let eventDescription = app.staticTexts["eventDescription"]
        let eventAddress = app.staticTexts["eventAddress"]
        let googleMapView = app.otherElements["googleMapView"]
        
        XCTAssertTrue(eventTitle.exists)
        XCTAssertTrue(eventDate.exists)
        XCTAssertTrue(eventTime.exists)
        XCTAssertTrue(eventDescription.exists)
        XCTAssertTrue(eventAddress.exists)
        XCTAssertTrue(googleMapView.exists)
    }
}
