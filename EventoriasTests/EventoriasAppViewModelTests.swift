//
//  EventoriasAppViewModelTests.swift
//  EventoriasTests
//
//  Created by Louise Ta on 05/12/2024.
//

import XCTest
@testable import Eventorias

final class EventoriasAppViewModelTests: XCTestCase {
    let mockAuthenticationService = MockAuthenticationService()
    let mockImageUploader = MockImageUploader()
    let mockEventService = MockEventService()
    let mockAddEventService = MockAddEventService()
    let mockUserService = UserServiceMock()
    
    func test_GivenAuthenticationViewModel_WhenNoLogin_ThenEnsureIsLoggedIsFalse() {
        let underTest = EventoriasAppViewModel(
            isLogged: false,
            authenticationService: mockAuthenticationService,
            imageUploader: mockImageUploader,
            eventService: mockEventService,
            addEventService: mockAddEventService,
            userService: mockUserService
        )
        let authenticationViewModel = underTest.authenticationViewModel
        
        XCTAssertFalse(underTest.isLogged)
    }
    
    func test_GivenAuthenticationViewModel_WhenLoginSucceeds_ThenEnsureIsLoggedIsTrue() {
        let underTest = EventoriasAppViewModel(
            isLogged: false,
            authenticationService: mockAuthenticationService,
            imageUploader: mockImageUploader,
            eventService: mockEventService,
            addEventService: mockAddEventService,
            userService: mockUserService
        )
        let authenticationViewModel = underTest.authenticationViewModel
        
        authenticationViewModel.onLoginSucceed()
        
        XCTAssertTrue(underTest.isLogged)
    }
}
