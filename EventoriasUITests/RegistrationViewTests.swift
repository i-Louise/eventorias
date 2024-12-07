//
//  RegistrationViewTests.swift
//  EventoriasUITests
//
//  Created by Louise Ta on 06/12/2024.
//

import XCTest
@testable import Eventorias

final class RegistrationViewTests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_GivenRegistrationViewFields_WhenAppLaunches_ThenEnsureTextFieldsArePresent() throws {
        // Given
        let signUpButton = app.buttons["signUpButton"]
        let placeHolderProfilePicture = app.images["placeHolderProfilePicture"]
        let cameraButton = app.buttons["cameraButton"]
        let galleryButton = app.buttons["galleryButton"]
        
        let firstNameField = app.textFields["firstNameTextField"]
        let lastNameField = app.textFields["lastNameTextField"]
        let emailField = app.textFields["emailTextField"]
        let passwordSecuredField = app.secureTextFields["passwordSecuredTextField"]
        let passwordConfirmSecuredField = app.secureTextFields["passwordConfirmSecuredField"]
        
        let createButton = app.buttons["createButton"]
        
        // When
        signUpButton.tap()
        
        // Then
        XCTAssertTrue(placeHolderProfilePicture.exists)
        XCTAssertTrue(cameraButton.exists)
        XCTAssertTrue(galleryButton.exists)
        XCTAssertTrue(firstNameField.exists)
        XCTAssertTrue(lastNameField.exists)
        XCTAssertTrue(emailField.exists)
        XCTAssertTrue(passwordSecuredField.exists)
        XCTAssertTrue(passwordConfirmSecuredField.exists)
        XCTAssertTrue(createButton.exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
