//
//  SignInViewTests.swift
//  EventoriasUITests
//
//  Created by Louise Ta on 06/12/2024.
//

import XCTest
@testable import Eventorias

final class SignInViewTests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_GivenLoginView_WhenAppLaunches_ThenEnsureTextFieldsArePresent() throws {
        // Given
        let emailField = app.textFields["emailTextField"]
        let passwordSecuredField = app.secureTextFields["passwordSecuredTextField"]
        let signInButton = app.buttons["signInButton"]
        let signUpButton = app.buttons["signUpButton"]
        
        // When
        app.launch()
        
        // Then
        XCTAssertTrue(emailField.exists)
        XCTAssertTrue(passwordSecuredField.exists)
        XCTAssertTrue(signInButton.exists)
        XCTAssertTrue(signUpButton.exists)
    }
    
    func test_GivenLoginView_WhenUserTapPasswordVisibilityButton_ThenEnsurePasswordVisibilityIsToggled() throws {
        // Given
        let passwordSecuredField = app.secureTextFields["passwordSecuredTextField"]
        let passwordTextField = app.textFields["passwordTextField"]
        let passwordVisibilityButton = app.buttons["passwordVisibilityButton"]
        
        // When
        XCTAssertTrue(passwordSecuredField.exists)
        passwordVisibilityButton.tap()
        
        // Then
        XCTAssertFalse(passwordSecuredField.exists)
        XCTAssertTrue(passwordTextField.exists)
    }
    
    func test_GivenLoginView_WhenSignUpButtonIsTapped_ThenEnsureSignUpViewIsPresented() throws {
        // Given
        let signUpButton = app.buttons["signUpButton"]
        let popoverTitle = app.staticTexts["registrationView"]
        
        // When
        signUpButton.tap()
        
        XCTAssertTrue(popoverTitle.exists)
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
