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
        
        let passwordsecuredfieldButton2 = elementsQuery/*@START_MENU_TOKEN@*/.buttons["passwordSecuredField"]/*[[".buttons[\"Hide\"]",".buttons[\"passwordSecuredField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        passwordsecuredfieldButton2.tap()
        
        let passwordconfirmsecuredfieldButton = elementsQuery.buttons["passwordConfirmSecuredField"]
        passwordconfirmsecuredfieldButton.tap()
        
        let passwordconfirmsecuredfieldButton2 = elementsQuery/*@START_MENU_TOKEN@*/.buttons["passwordConfirmSecuredField"]/*[[".buttons[\"Hide\"]",".buttons[\"passwordConfirmSecuredField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        passwordconfirmsecuredfieldButton2.tap()
        elementsQuery/*@START_MENU_TOKEN@*/.secureTextFields["passwordSecuredField"]/*[[".secureTextFields[\"Password\"]",".secureTextFields[\"passwordSecuredField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        passwordsecuredfieldButton.tap()
        
        let passwordsecuredfieldTextField = elementsQuery/*@START_MENU_TOKEN@*/.textFields["passwordSecuredField"]/*[[".textFields[\"Password\"]",".textFields[\"passwordSecuredField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        passwordsecuredfieldTextField.tap()
        passwordsecuredfieldTextField.tap()
        passwordsecuredfieldButton2.tap()
        passwordconfirmsecuredfieldButton.tap()
        
        let passwordconfirmsecuredfieldTextField = elementsQuery/*@START_MENU_TOKEN@*/.textFields["passwordConfirmSecuredField"]/*[[".textFields[\"Confirm password\"]",".textFields[\"passwordConfirmSecuredField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        passwordconfirmsecuredfieldTextField.tap()
        passwordconfirmsecuredfieldTextField.tap()
        passwordconfirmsecuredfieldButton2.tap()
    }
    
    func test_GivenImagePickerView_WhenUserTapPhotoLibraryPickerButton_ThenEnsureImagePickerIsPresented() throws {
                
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Attachments"].tap()
        
        app/*@START_MENU_TOKEN@*/.otherElements["photos_layout"].images["Photo, 30 mars 2018, 21:14"]/*[[".otherElements[\"photoLibrary\"]",".otherElements[\"Photos\"]",".scrollViews[\"content_scroll_view\"].otherElements[\"photos_layout\"]",".otherElements[\"photos_sectioned_layout\"]",".otherElements[\"PXAssetsSectionLayout-Group\"]",".otherElements[\"PXZoomablePhotosLayout-Group\"]",".otherElements[\"PXGZoomLayout-Group\"]",".otherElements[\"PXGDecoratingLayout-Group\"]",".otherElements[\"Photo, 30 mars 2018, 21:14, Photo, 08 août 2012, 23:55, Photo, 08 août 2012, 23:29, Photo, 08 août 2012, 20:52, Photo, 09 octobre 2009, 23:09, Photo, 13 mars 2011, 01:17\"].images[\"Photo, 30 mars 2018, 21:14\"]",".otherElements[\"PXGGridLayout-Group\"].images[\"Photo, 30 mars 2018, 21:14\"]",".images[\"Photo, 30 mars 2018, 21:14\"]",".otherElements[\"photos_layout\"]"],[[[-1,11,3],[-1,2,3],[-1,1,2],[-1,0,1]],[[-1,11,3],[-1,2,3],[-1,1,2]],[[-1,11,3],[-1,2,3]],[[-1,10],[-1,9],[-1,8],[-1,7,8],[-1,6,7],[-1,5,6],[-1,4,5],[-1,3,4]],[[-1,10],[-1,9],[-1,8],[-1,7,8],[-1,6,7],[-1,5,6],[-1,4,5]],[[-1,10],[-1,9],[-1,8],[-1,7,8],[-1,6,7],[-1,5,6]],[[-1,10],[-1,9],[-1,8],[-1,7,8],[-1,6,7]],[[-1,10],[-1,9],[-1,8],[-1,7,8]],[[-1,10],[-1,9],[-1,8]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        elementsQuery.buttons["Camera"].tap()
        
        let photocaptureButton = app/*@START_MENU_TOKEN@*/.buttons["PhotoCapture"]/*[[".otherElements[\"camera\"]",".buttons[\"Take Picture\"]",".buttons[\"PhotoCapture\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        photocaptureButton.tap()
        photocaptureButton.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Cancel"]/*[[".otherElements[\"camera\"]",".buttons[\"Cancel\"].staticTexts[\"Cancel\"]",".staticTexts[\"Cancel\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    func test_GivenRegistrationView_WhenUserCloseIt_ThenEnsureTheViewIsClosed() throws {
        let elementsQuery = XCUIApplication().scrollViews.otherElements
        elementsQuery/*@START_MENU_TOKEN@*/.staticTexts["registrationView"]/*[[".staticTexts[\"Register\"]",".staticTexts[\"registrationView\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeDown()
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
