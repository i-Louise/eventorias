//
//  UserProfileViewTests.swift
//  EventoriasUITests
//
//  Created by Louise Ta on 09/12/2024.
//

import XCTest

final class UserProfileViewTests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments.append("UI_TEST_MODE")
        app.launchEnvironment["UI_TEST_LOGGED_IN"] = "true"
        app.launch()
        
        app.tabBars.buttons.element(boundBy: 1).tap()
    }
    
    override func tearDownWithError() throws {
        app.terminate()
    }

    func testExample() throws {
        let userProfileImage = app.images["userProfileImage"]
        let username = app.staticTexts["username"]
        let userEmail = app.staticTexts["userEmail"]
        
        XCTAssertTrue(userProfileImage.exists)
        XCTAssertTrue(username.exists)
        XCTAssertTrue(userEmail.exists)
    }
}
