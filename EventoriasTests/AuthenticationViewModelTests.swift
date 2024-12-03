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
        var invalidEmail = "invalid"
        var password = "password"
        let expectation = XCTestExpectation(description: "alertMessage should be set when email is invalid")
        
        //When
        viewModel.onLoginAction(email: invalidEmail, password: password) { isLoading in }
        
        XCTAssertEqual(viewModel.alertMessage, "Incorrect email format, please try again.")
        expectation.fulfill()
    }
    func test_givenEmptyPassword_WhenOnLoginActionIsCalled_ThenReturnsAnError() {
        // Given
        var validMail = "test@example.com"
        var invalidPassword = ""
        let expectation = XCTestExpectation(description: "alertMessage should be set when password is empty")
        
        // When
        viewModel.onLoginAction(email: validMail, password: invalidPassword) { isLoading in }
        
        // Then
        XCTAssertEqual(viewModel.alertMessage, "Please enter your password.")
        expectation.fulfill()
    }
    
    func test_givenValidCredentials_WhenOnLoginActionIsCalled_ThenReturnsSuccess() async {
        
        // Given
        var email = "test@example.com"
        var password = "password123"
        mockService.shouldSucceedLogin = true
        
        viewModel.onLoginAction(email: email, password: password) { isLoading in }
        
        XCTAssertNil(viewModel.alertMessage, "alertMessage should be nil when the input is valid")
        XCTAssertTrue(mockService.loginCalled, "The login function should be called")
    }
    
    func test_givenValidCredentials_WhenOnLoginActionIsCalledAndShouldSucceedFalse_ThenReturnsFailure() async {
        
        // Given
        var email = "test@example.com"
        var password = "password123"
        mockService.shouldSucceedLogin = false
        
        viewModel.onLoginAction(email: email, password: password) { isLoading in }
        
        XCTAssertEqual(viewModel.alertMessage, "An error occur. Please try again.")
        XCTAssertTrue(mockService.loginCalled, "The login function should be called")
    }
}
