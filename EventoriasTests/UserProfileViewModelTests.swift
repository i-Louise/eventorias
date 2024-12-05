//
//  UserProfileViewModelTests.swift
//  EventoriasTests
//
//  Created by Louise Ta on 05/12/2024.
//

import XCTest
@testable import Eventorias

final class UserProfileViewModelTests: XCTestCase {
    private var mockUserService: UserServiceMock!
    private var viewModel: UserProfileViewModel!
    
    override func setUp() {
        super.setUp()
        mockUserService = UserServiceMock()
        viewModel = UserProfileViewModel(userService: mockUserService)
    }
    override func tearDown() {
        viewModel = nil
        mockUserService = nil
        super.tearDown()
    }
    
    func test_FetchUserProfileSuccess() {
        let expectation = XCTestExpectation()
        
        let expectedUser = UserResponseModel(email: "test@test.com", firstName: "John", lastName: "Doe", profilePicture: "fakeUrl")
        mockUserService.user = expectedUser
        mockUserService.shouldSucceed = true
        
        viewModel.onActionFetchingUserProfile()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.user, expectedUser)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_FetchUserProfileFailure() {
        let expectation = XCTestExpectation()
        
        let expectedUser = UserResponseModel(email: "test@test.com", firstName: "John", lastName: "Doe", profilePicture: "fakeUrl")
        mockUserService.user = expectedUser
        mockUserService.shouldSucceed = false
        
        viewModel.onActionFetchingUserProfile()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNil(self.viewModel.user)
            XCTAssertEqual(self.viewModel.errorMessage, "Could not load your profile.")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
}
