//
//  AuthenticationViewModelTests.swift
//  EventoriasTests
//
//  Created by Louise Ta on 03/12/2024.
//

import XCTest
@testable import Eventorias

final class AuthenticationViewModelTests: XCTestCase {
    
    var viewModel: AuthenticationViewModel!
    var mockService: MockAuthenticationService!
    
    override func setUp() {
        super.setUp()
        mockService = MockAuthenticationService()
        viewModel = AuthenticationViewModel(authenticationService: mockService, {
            print("Login succeeded")
        })
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func test_givenInvalidEmail_WhenOnLoginActionIsCalled_ThenReturnsErrorMessage() {
        // Given
        let invalidEmail = "invalid"
        let password = "password"
        
        //When
        viewModel.onLoginAction(email: invalidEmail, password: password) { isLoading in }
        
        XCTAssertEqual(viewModel.alertMessage, "Incorrect email format, please try again.")
    }
    func test_givenEmptyPassword_WhenOnLoginActionIsCalled_ThenReturnsAnError() {
        // Given
        let validMail = "test@example.com"
        let invalidPassword = ""
        
        // When
        viewModel.onLoginAction(email: validMail, password: invalidPassword) { isLoading in }
        
        // Then
        XCTAssertEqual(viewModel.alertMessage, "Please enter your password.")
    }
    
    func test_givenValidCredentials_WhenOnLoginActionIsCalled_ThenReturnsSuccess() {
        let expectation = XCTestExpectation(description: "Authentication service call expectation")

        // Given
        let email = "test@example.com"
        let password = "password123"
        mockService.shouldSucceedLogin = true
        
        viewModel.onLoginAction(email: email, password: password) { isLoading in }
        
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
        
        viewModel.onLoginAction(email: email, password: password) { isLoading in }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.alertMessage, "An error occur. Please try again.")
            XCTAssertTrue(self.mockService.loginCalled)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
}
