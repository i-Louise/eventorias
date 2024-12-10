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
        app.launchArguments.append("UI_TEST_MODE")
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
    }
    
    func test_GivenLoginView_WhenAppIsRunning_ThenEnsureTextFieldsArePresent() throws {
        // Given
        let emailField = app.textFields["emailTextField"]
        let passwordSecuredField = app.secureTextFields["passwordSecuredTextField"]
        let signInButton = app.buttons["signInButton"]
        let signUpButton = app.buttons["signUpButton"]
        
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
}
