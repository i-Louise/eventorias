//
//  EventListViewTests.swift
//  EventoriasUITests
//
//  Created by Louise Ta on 08/12/2024.
//

import XCTest
@testable import Eventorias

final class EventListViewTests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments.append("UI_TEST_MODE")
        app.launchEnvironment["UI_TEST_LOGGED_IN"] = "true"
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app.terminate()
    }
    
    func testList() throws {
        let eventItem = app.staticTexts["eventItemView"]
        let filterMenu = app.buttons["filterMenu"]
        let categoryButton = app.buttons["categoryButton"]
        
        XCTAssertTrue(eventItem.exists)
        XCTAssertTrue(filterMenu.exists)
        XCTAssertTrue(categoryButton.exists)
        XCTAssertEqual(app.cells.count, 1)
    }
    
    func testNavigationToDetailView() throws {
        let eventList = app.cells
        XCTAssertEqual(eventList.count, 1)
                        
        app.cells.element(boundBy: 0).tap()
        
        let eventDetailTitle = app.staticTexts["eventTitle"]
        XCTAssertTrue(eventDetailTitle.exists)
    }
    
    func testButtonCreateEvent() throws {
        let createEventButton = app.buttons["createEventButton"]
        let createEvent = app.staticTexts["Creation of an event"]

        createEventButton.tap()
        
        XCTAssertTrue(createEvent.exists)
    }
}
