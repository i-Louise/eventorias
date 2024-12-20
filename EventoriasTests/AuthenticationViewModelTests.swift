//
//  AuthenticationViewModelTests.swift
//  EventoriasTests
//
//  Created by Louise Ta on 03/12/2024.
//

import XCTest
@testable import Eventorias

final class AuthenticationViewModelTests: XCTestCase {
    
    var viewModel: SignInViewModel!
    var mockService: MockAuthenticationService!
    private var mockImageUploader: MockImageUploader!
    
    override func setUp() {
        mockService = MockAuthenticationService()
        mockImageUploader = MockImageUploader()
        mockImageUploader.shouldFail = false
        viewModel = SignInViewModel(
            authenticationService: mockService,
            imageUploader: mockImageUploader
        ) {
            print("Login succeeded")
        }
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        mockImageUploader = nil
        super.tearDown()
    }
    
    func test_givenInvalidEmail_WhenOnLoginActionIsCalled_ThenReturnsErrorMessage() {
        // Given
        let invalidEmail = "invalid"
        let password = "password"
        
        //When
        viewModel.onLoginAction(email: invalidEmail, password: password)
        
        XCTAssertEqual(viewModel.alertMessage, "Incorrect email format, please try again.")
    }
    func test_givenEmptyPassword_WhenOnLoginActionIsCalled_ThenReturnsAnError() {
        // Given
        let validMail = "test@example.com"
        let invalidPassword = ""
        
        // When
        viewModel.onLoginAction(email: validMail, password: invalidPassword)
        
        // Then
        XCTAssertEqual(viewModel.alertMessage, "Please enter your password.")
    }
    
    func test_givenValidCredentials_WhenOnLoginActionIsCalled_ThenReturnsSuccess() {
        let expectation = XCTestExpectation(description: "Authentication service call expectation")

        // Given
        let email = "test@example.com"
        let password = "password123"
        mockService.shouldSucceedLogin = true
        
        viewModel.onLoginAction(email: email, password: password)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNil(self.viewModel.alertMessage)
            XCTAssertTrue(self.mockService.loginCalled)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_givenValidCredentials_WhenOnLoginActionIsCalledAndShouldSucceedFalse_ThenReturnsFailure() {
        let expectation = XCTestExpectation(description: "Authentication service fail expectation")

        // Given
        let email = "test@example.com"
        let password = "password123"
        mockService.shouldSucceedLogin = false
        
        viewModel.onLoginAction(email: email, password: password)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.alertMessage, "Please check your credentials and try again.")
            XCTAssertTrue(self.mockService.loginCalled)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
}
