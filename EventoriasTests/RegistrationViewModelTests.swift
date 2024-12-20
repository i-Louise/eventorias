//
//  RegistrationViewModelTests.swift
//  EventoriasTests
//
//  Created by Louise Ta on 03/12/2024.
//

import XCTest
@testable import Eventorias

final class RegistrationViewModelTests: XCTestCase {
    
    var viewModel: RegistrationViewModel!
    var mockService: MockAuthenticationService!
    var mockImageUploader: MockImageUploader!
    
    override func setUp() {
        super.setUp()
        mockService = MockAuthenticationService()
        mockImageUploader = MockImageUploader()
        viewModel = RegistrationViewModel(authenticationService: mockService, imageUploader: mockImageUploader)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testOnSignUpAction_MissingFirstName() {
        // Given & When
        viewModel.onSignUpAction(
            firstName: "",
            lastName: "Doe",
            email: "test@example.com",
            password: "Password1!",
            confirmPassword: "Password1!",
            image: Data(),
            onSuccess: {},
            onFailure: {_ in
            })
        
        // Then
        XCTAssertEqual(viewModel.firstNameErrorMessage, "Please enter your first name.")
    }
    
    func testOnSignUpAction_MissingLastName() {
        // Given & When
        viewModel.onSignUpAction(
            firstName: "John",
            lastName: "",
            email: "test@example.com",
            password: "Password1!",
            confirmPassword: "Password1!",
            image: Data(),
            onSuccess: {},
            onFailure: {_ in }
        )

        // Then
        XCTAssertEqual(viewModel.lastNameErrorMessage, "Please enter your last name.")
    }
    
    func testOnSignUpAction_PasswordIncorrect() {
        // Given & When
        viewModel.onSignUpAction(
            firstName: "John",
            lastName: "Doe",
            email: "test@example.com",
            password: "incorrectPassword",
            confirmPassword: "incorrectPassword",
            image: Data(),
            onSuccess: {},
            onFailure: {_ in })

        // Then
        XCTAssertEqual(viewModel.passwordErrorMessage, "Password must be more than 6 characters, with at least one capital, numeric or special character.")
    }
    
    func testOnSignUpAction_InvalidEmail() {
        // Given & When
        viewModel.onSignUpAction(
            firstName: "John",
            lastName: "Doe",
            email: "invalid-email",
            password: "Password1!",
            confirmPassword: "Password1!",
            image: Data(),
            onSuccess: {},
            onFailure: {_ in })

        // Then
        XCTAssertEqual(viewModel.emailErrorMessage, "Incorrect email format.")
    }
    func testOnSignUpAction_PasswordsDoNotMatch() {
        // Given & When
        viewModel.onSignUpAction(
            firstName: "John",
            lastName: "Doe",
            email: "test@example.com",
            password: "Password1!",
            confirmPassword: "DifferentPassword1!",
            image: Data(),
            onSuccess: {},
            onFailure: {_ in })

        // Then
        XCTAssertEqual(viewModel.confirmPasswordErrorMessage, "Passwords are not matching.")
    }
    
    func testOnSignUpAction_ValidInput() {
        // Given
        let expectation = XCTestExpectation(description: "onSuccess is called")

        // When
        viewModel.onSignUpAction(
            firstName: "John",
            lastName: "Doe",
            email: "test@example.com",
            password: "Password1!",
            confirmPassword: "Password1!",
            image: Data(),
            onSuccess: {
                expectation.fulfill()
            },
            onFailure: { _ in
                XCTFail("onFailure should not be called for valid inputs.")
            }
        )
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false after successful sign-up.")
        XCTAssertNil(viewModel.firstNameErrorMessage, "No error message should be set for the first name.")
        XCTAssertNil(viewModel.lastNameErrorMessage, "No error message should be set for the last name.")
        XCTAssertNil(viewModel.emailErrorMessage, "No error message should be set for the email.")
        XCTAssertNil(viewModel.passwordErrorMessage, "No error message should be set for the password.")
        XCTAssertNil(viewModel.confirmPasswordErrorMessage, "No error message should be set for the password confirmation.")
    }
    
    func test_GivenValidInput_WhenSignUpActionIsCalled_ThenEnsureServicesAreCalled() {
        // Given
        let expectation = XCTestExpectation(description: "Services are called on success")

        // When
        viewModel.onSignUpAction(
            firstName: "John",
            lastName: "Doe",
            email: "test@example.com",
            password: "Password1!",
            confirmPassword: "Password1!",
            image: Data(),
            onSuccess: {
                expectation.fulfill()
            },
            onFailure: { _ in
                XCTFail("onFailure should not be called for valid inputs.")
            }
        )

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(self.mockImageUploader.imageUploaded, "ImageUploader should be called with valid input.")
            XCTAssertTrue(self.mockService.registrationCalled, "Registration service should be called with valid input.")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_GivenValidInput_WhenSignUpActionIsCalled_AndItFails_ThenReturnsAnErrorMessage() {
        let expectation = XCTestExpectation()
        mockService.shouldSucceedRegistration = false

        viewModel.onSignUpAction(
            firstName: "John",
            lastName: "Doe",
            email: "test@example.com",
            password: "Password1!",
            confirmPassword: "Password1!",
            image: Data(),
            onSuccess: {
                XCTFail()
            },
            onFailure: { alertMessage in
                XCTAssertEqual(alertMessage, "An error occured, while registering.")
                expectation.fulfill()
            }
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.mockImageUploader.imageUploaded)
            XCTAssertTrue(self.mockService.registrationCalled)
            XCTAssertEqual(self.viewModel.alertMessage, "An error occured, while registering.")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_GivenValidInput_WhenSignUpActionIsCalled_AndImageUploadFails_ThenReturnsAnErrorMessage() {
        let expectation = XCTestExpectation()
        mockImageUploader.shouldFail = true

        viewModel.onSignUpAction(
            firstName: "John",
            lastName: "Doe",
            email: "test@example.com",
            password: "Password1!",
            confirmPassword: "Password1!",
            image: Data(),
            onSuccess: {},
            onFailure: {_ in })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.mockImageUploader.imageUploaded)
            XCTAssertFalse(self.mockService.registrationCalled)
            XCTAssertEqual(self.viewModel.alertMessage, "Image upload failed")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
}
