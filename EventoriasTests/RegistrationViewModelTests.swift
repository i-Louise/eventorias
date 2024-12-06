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
        // Given
        let expectation = XCTestExpectation(description: "onLoading should be called and alertMessage should be set for missing first name")
        var isLoadingCalled = false

        // When
        viewModel.onSignUpAction(
            firstName: "",
            lastName: "Doe",
            email: "test@example.com",
            password: "Password1!",
            confirmPassword: "Password1!",
            image: Data()
        ) { isLoading in
            isLoadingCalled = isLoading
            expectation.fulfill()
        }

        // Then
        XCTAssertNotNil(viewModel.alertMessage, "alertMessage should be set when the first name is missing")
        XCTAssertEqual(viewModel.alertMessage, "Please enter your first name.")
        XCTAssertFalse(isLoadingCalled, "onLoading should be called with false after validation fails")

        wait(for: [expectation], timeout: 1.0)
    }
    func testOnSignUpAction_MissingLastName() {
        // Given
        let expectation = XCTestExpectation(description: "onLoading should be called and alertMessage should be set for missing last name")
        var isLoadingCalled = false

        // When
        viewModel.onSignUpAction(
            firstName: "John",
            lastName: "",
            email: "test@example.com",
            password: "Password1!",
            confirmPassword: "Password1!",
            image: Data()
        ) { isLoading in
            isLoadingCalled = isLoading
            expectation.fulfill()
        }

        // Then
        XCTAssertNotNil(viewModel.alertMessage)
        XCTAssertEqual(viewModel.alertMessage, "Please enter your last name.")
        XCTAssertFalse(isLoadingCalled, "onLoading should be called with false after validation fails")

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testOnSignUpAction_PasswordIncorrect() {
        // Given
        let expectation = XCTestExpectation(description: "onLoading should be called and alertMessage should be set for not setting a correct password")
        var isLoadingCalled = false

        // When
        viewModel.onSignUpAction(
            firstName: "John",
            lastName: "Doe",
            email: "test@example.com",
            password: "incorrectPassword",
            confirmPassword: "incorrectPassword",
            image: Data()
        ) { isLoading in
            isLoadingCalled = isLoading
            expectation.fulfill()
        }

        // Then
        XCTAssertNotNil(viewModel.alertMessage)
        XCTAssertEqual(viewModel.alertMessage, "Password must be more than 6 characters, with at least one capital, numeric or special character.")
        XCTAssertFalse(isLoadingCalled, "onLoading should be called with false after validation fails")

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testOnSignUpAction_InvalidEmail() {
        // Given
        let expectation = XCTestExpectation(description: "onLoading should be called and alertMessage should be set for invalid email")
        var isLoadingCalled = false

        // When
        viewModel.onSignUpAction(
            firstName: "John",
            lastName: "Doe",
            email: "invalid-email",
            password: "Password1!",
            confirmPassword: "Password1!",
            image: Data()
        ) { isLoading in
            isLoadingCalled = isLoading
            expectation.fulfill()
        }

        // Then
        XCTAssertNotNil(viewModel.alertMessage, "alertMessage should be set for invalid email")
        XCTAssertEqual(viewModel.alertMessage, "Incorrect email format.")
        XCTAssertFalse(isLoadingCalled, "onLoading should be called with false after validation fails")

        wait(for: [expectation], timeout: 1.0)
    }
    func testOnSignUpAction_PasswordsDoNotMatch() {
        // Given
        let expectation = XCTestExpectation(description: "onLoading should be called and alertMessage should be set for password mismatch")
        var isLoadingCalled = false

        // When
        viewModel.onSignUpAction(
            firstName: "John",
            lastName: "Doe",
            email: "test@example.com",
            password: "Password1!",
            confirmPassword: "DifferentPassword1!",
            image: Data()
        ) { isLoading in
            isLoadingCalled = isLoading
            expectation.fulfill()
        }

        // Then
        XCTAssertNotNil(viewModel.alertMessage, "alertMessage should be set when passwords do not match")
        XCTAssertEqual(viewModel.alertMessage, "Passwords are not matching.")
        XCTAssertFalse(isLoadingCalled, "onLoading should be called with false after validation fails")

        wait(for: [expectation], timeout: 1.0)
    }
    func testOnSignUpAction_ValidInput() {
        // Given
        var isLoadingCalled = false

        // When
        viewModel.onSignUpAction(
            firstName: "John",
            lastName: "Doe",
            email: "test@example.com",
            password: "Password1!",
            confirmPassword: "Password1!",
            image: Data()
        ) { isLoading in
            isLoadingCalled = isLoading
        }

        // Then
        XCTAssertTrue(isLoadingCalled, "onLoading should be called with true while processing")
    }
    func test_GivenValidInput_WhenSignUpActionIsCalled_ThenEnsureRegistrationIsCalled() {
        let expectation = XCTestExpectation()

        viewModel.onSignUpAction(
            firstName: "John",
            lastName: "Doe",
            email: "test@example.com",
            password: "Password1!",
            confirmPassword: "Password1!",
            image: Data()
        ) {_ in }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.mockImageUploader.imageUploaded)
            XCTAssertTrue(self.mockService.registrationCalled)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
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
            image: Data()
        ) {_ in }
        
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
            image: Data()
        ) {_ in }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.mockImageUploader.imageUploaded)
            XCTAssertFalse(self.mockService.registrationCalled)
            XCTAssertEqual(self.viewModel.alertMessage, "Image upload failed")
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
            image: Data()
        ) {_ in }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.mockImageUploader.imageUploaded)
            XCTAssertFalse(self.mockService.registrationCalled)
            XCTAssertEqual(self.viewModel.alertMessage, "Image upload failed")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
}
