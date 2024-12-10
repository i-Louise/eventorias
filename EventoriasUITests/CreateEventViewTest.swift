//
//  CreateEventViewTest.swift
//  EventoriasUITests
//
//  Created by Louise Ta on 09/12/2024.
//

import XCTest

final class CreateEventViewTest: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments.append("UI_TEST_MODE")
        app.launchEnvironment["UI_TEST_LOGGED_IN"] = "true"
        app.launch()
        
        let createEventButton = app.buttons["createEventButton"]
        createEventButton.tap()
    }
    
    override func tearDownWithError() throws {
        app.terminate()
    }

    func testCreateEventView() throws {
        let titleField = app.textFields["titleTextField"]
        let categoryPicker = app.staticTexts["categoryPicker"]
        let descriptionField = app.textFields["descriptionTextField"]
        let datePicker = app.datePickers["datePicker"]
        let addressField = app.textFields["addressTextField"]
        let imagePickerView = app.buttons["imagePickerView"]
        let validateButton = app.buttons["validateButton"]
        
        XCTAssertTrue(titleField.exists)
        XCTAssertTrue(categoryPicker.exists)
        XCTAssertTrue(descriptionField.exists)
        XCTAssertTrue(datePicker.exists)
        XCTAssertTrue(addressField.exists)
        XCTAssertTrue(imagePickerView.exists)
        XCTAssertTrue(validateButton.exists)
    }
    
    func testAddressAutoComplete() throws {
        let addressField = app.textFields["addressTextField"]
        let googleAutoComplete = app.otherElements["googleAutoComplete"]
        
        addressField.tap()
        
        XCTAssertTrue(googleAutoComplete.waitForExistence(timeout: 5))
    }
}
