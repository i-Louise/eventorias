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
        app.launchArguments.append("UI_TEST_MODE")
        app.launch()
        
        let signUpButton = app.buttons["signUpButton"]
        signUpButton.tap()
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    func test_GivenRegistrationViewFields_WhenAppLaunches_ThenEnsureTextFieldsArePresent() throws {
        // Given
        let placeHolderProfilePicture = app.images["placeHolderProfilePicture"]
        let imagePickerView = app.buttons["imagePickerView"]
        
        let firstNameField = app.textFields["firstNameTextField"]
        let lastNameField = app.textFields["lastNameTextField"]
        let emailField = app.textFields["emailTextField"]
        let passwordSecuredField = app.secureTextFields["passwordSecuredTextField"]
        let passwordConfirmSecuredField = app.secureTextFields["passwordConfirmSecuredField"]
        
        let createButton = app.buttons["createButton"]
        
        // Then
        XCTAssertTrue(placeHolderProfilePicture.exists)
        XCTAssertTrue(imagePickerView.exists)
        XCTAssertTrue(firstNameField.exists)
        XCTAssertTrue(lastNameField.exists)
        XCTAssertTrue(emailField.exists)
        XCTAssertTrue(passwordSecuredField.exists)
        XCTAssertTrue(passwordConfirmSecuredField.exists)
        XCTAssertTrue(createButton.exists)
    }
    
    func test_GivenRegistrationView_WhenUserTapPasswordVisibilityButton_ThenEnsurePasswordVisibilityIsToggled() throws {
        let elementsQuery = app.scrollViews.otherElements
        let passwordsecuredfieldButton = elementsQuery.buttons["passwordSecuredField"]
        passwordsecuredfieldButton.tap()
        
        let passwordsecuredfieldButton2 = elementsQuery.buttons["passwordSecuredField"]
        passwordsecuredfieldButton2.tap()
        
        let passwordconfirmsecuredfieldButton = elementsQuery.buttons["passwordConfirmSecuredField"]
        passwordconfirmsecuredfieldButton.tap()
        
        let passwordconfirmsecuredfieldButton2 = elementsQuery.buttons["passwordConfirmSecuredField"]
        passwordconfirmsecuredfieldButton2.tap()
        elementsQuery.secureTextFields["passwordSecuredField"].tap()
        passwordsecuredfieldButton.tap()
        
        let passwordsecuredfieldTextField = elementsQuery.textFields["passwordSecuredField"]
        passwordsecuredfieldTextField.tap()
        passwordsecuredfieldTextField.tap()
        passwordsecuredfieldButton2.tap()
        passwordconfirmsecuredfieldButton.tap()
        
        let passwordconfirmsecuredfieldTextField = elementsQuery.textFields["passwordConfirmSecuredField"]
        passwordconfirmsecuredfieldTextField.tap()
        passwordconfirmsecuredfieldTextField.tap()
        passwordconfirmsecuredfieldButton2.tap()
    }
    
    func test_GivenImagePickerView_WhenUserTapPhotoLibraryPickerButton_ThenEnsureImagePickerIsPresented() throws {
                
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Attachments"].tap()
        
        app.otherElements["photos_layout"].images["Photo, 30 mars 2018, 21:14"].tap()
        elementsQuery.buttons["Camera"].tap()
        
        let photocaptureButton = app.buttons["PhotoCapture"]
        photocaptureButton.tap()
        photocaptureButton.tap()
        app.staticTexts["Cancel"].tap()
    }
    
    func test_GivenRegistrationView_WhenUserCloseIt_ThenEnsureTheViewIsClosed() throws {
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.staticTexts["registrationView"].swipeDown()
    }
}
