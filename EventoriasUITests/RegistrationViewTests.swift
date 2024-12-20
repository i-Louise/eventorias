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
        let imagePickerView = app.buttons["imagePickerView"]
        
        let firstNameField = app.textFields["firstNameTextField"]
        let lastNameField = app.textFields["lastNameTextField"]
        let emailField = app.textFields["emailTextField"]
        let passwordSecuredField = app.secureTextFields["passwordSecuredTextField"]
        let passwordConfirmSecuredField = app.secureTextFields["passwordConfirmSecuredField"]
        
        let createButton = app.buttons["createButton"]
        
        // Then
        XCTAssertTrue(imagePickerView.exists)
        XCTAssertTrue(firstNameField.exists)
        XCTAssertTrue(lastNameField.exists)
        XCTAssertTrue(emailField.exists)
        XCTAssertTrue(passwordSecuredField.exists)
        XCTAssertTrue(passwordConfirmSecuredField.exists)
        XCTAssertTrue(createButton.exists)
    }
    
    func test_GivenRegistrationView_WhenUserTapPasswordVisibilityButton_ThenEnsurePasswordVisibilityIsToggled() throws {
        // Given
        let elementsQuery = app.scrollViews.otherElements
        let passwordVisibilityButton = elementsQuery.buttons["passwordSecuredField"]
        let passwordConfirmVisibilityButton = elementsQuery.buttons["passwordConfirmSecuredField"]
        let passwordSecureField = elementsQuery.secureTextFields["passwordSecuredField"]
        let passwordTextField = elementsQuery.textFields["passwordSecuredField"]
        let passwordConfirmSecureField = elementsQuery.secureTextFields["passwordConfirmSecuredField"]
        let passwordConfirmTextField = elementsQuery.textFields["passwordConfirmSecuredField"]

        // When & Then: Toggle password visibility
        passwordVisibilityButton.tap()
        XCTAssertTrue(passwordTextField.exists, "Password field should switch to visible state.")
        XCTAssertFalse(passwordSecureField.exists, "Secure password field should not exist in visible state.")
        
        passwordVisibilityButton.tap()
        XCTAssertTrue(passwordSecureField.exists, "Password field should switch back to secure state.")
        XCTAssertFalse(passwordTextField.exists, "Visible password field should not exist in secure state.")

        // When & Then: Toggle password confirm visibility
        passwordConfirmVisibilityButton.tap()
        XCTAssertTrue(passwordConfirmTextField.exists, "Password confirm field should switch to visible state.")
        XCTAssertFalse(passwordConfirmSecureField.exists, "Secure password confirm field should not exist in visible state.")
        
        passwordConfirmVisibilityButton.tap()
        XCTAssertTrue(passwordConfirmSecureField.exists, "Password confirm field should switch back to secure state.")
        XCTAssertFalse(passwordConfirmTextField.exists, "Visible password confirm field should not exist in secure state.")
    }
    
    func test_GivenImagePickerView_WhenUserTapPhotoLibraryPickerButton_ThenEnsureImagePickerIsPresented() throws {
        let elementsQuery = app.scrollViews.otherElements

        let attachmentsButton = elementsQuery.buttons["Attachments"]
        XCTAssertTrue(attachmentsButton.waitForExistence(timeout: 5), "Attachments button should exist")
        attachmentsButton.tap()

        let photosLayout = app.otherElements["photos_layout"]
        XCTAssertTrue(photosLayout.waitForExistence(timeout: 5), "Photos layout should exist")
        
        let photo = photosLayout.images["Photo, 30 mars 2018, 21:14"]
        XCTAssertTrue(photo.waitForExistence(timeout: 5), "Photo should exist")
        photo.tap()
        
        let cameraButton = elementsQuery.buttons["Camera"]
        XCTAssertTrue(cameraButton.waitForExistence(timeout: 5), "Camera button should exist")
        cameraButton.tap()
        
        let photoCaptureButton = app.buttons["PhotoCapture"]
        XCTAssertTrue(photoCaptureButton.waitForExistence(timeout: 5), "PhotoCapture button should exist")
        XCTAssertTrue(photoCaptureButton.isHittable, "PhotoCapture button should be hittable")
        photoCaptureButton.tap()
        
        photoCaptureButton.tap()

        let cancelButton = app.staticTexts["Cancel"]
        XCTAssertTrue(cancelButton.waitForExistence(timeout: 5), "Cancel button should exist")
        cancelButton.tap()
    }
}
